import pygame
import numpy as np
from PIL import Image
import sys
import serial
import serial.tools.list_ports
import time

class DrawingHarness:
    def __init__(self):
        pygame.init()
        
        # UART Settings
        self.ser = None
        self.COM_PORT = 'COM42' # CHANGE THIS to your actual port
        self.BAUD_RATE = 115200
        
        # Canvas settings
        self.canvas_size = 112  # 4x of 28x28 for clean integer downscaling
        self.scale_factor = 5   # Display scale for easier drawing
        self.display_size = self.canvas_size * self.scale_factor
        
        # Window settings
        self.window_width = self.display_size + 300
        self.window_height = self.display_size + 100
        self.screen = pygame.display.set_mode((self.window_width, self.window_height))
        pygame.display.set_caption("Drawing Harness")
        
        # Colors
        self.WHITE = (255, 255, 255)
        self.BLACK = (0, 0, 0)
        self.GRAY = (200, 200, 200)
        self.DARK_GRAY = (100, 100, 100)
        self.BLUE = (100, 150, 255)
        
        # Canvas data (64x64)
        self.canvas = np.zeros((self.canvas_size, self.canvas_size), dtype=np.uint8)
        
        # Downscaled image (28x28)
        # CHANGED: Use uint8 (0-255) instead of int8 (0-127)
        self.downscaled = np.zeros((28, 28), dtype=np.uint8)
        
        # Drawing settings
        self.brush_size = 5
        self.is_drawing = False
        self.is_erasing = False
        self.last_pos = None  # Track last mouse position for interpolation
        
        # Font
        self.font = pygame.font.Font(None, 24)
        self.small_font = pygame.font.Font(None, 18)
        
        # Button rectangles
        self.clear_button = pygame.Rect(self.display_size + 20, 50, 120, 40)
        self.process_button = pygame.Rect(self.display_size + 160, 50, 120, 40)
        self.save_button = pygame.Rect(self.display_size + 20, 110, 120, 40)
        self.send_button = pygame.Rect(self.display_size + 20, 170, 120, 40)
        self.brush_up_button = pygame.Rect(self.display_size + 160, 110, 55, 40)
        self.brush_down_button = pygame.Rect(self.display_size + 225, 110, 55, 40)
        
        self.clock = pygame.time.Clock()

    def init_uart(self):
        """Try to initialize UART connection"""
        try:
            if self.ser and self.ser.is_open:
                return True
                
            print(f"Attempting to connect to {self.COM_PORT}...")
            self.ser = serial.Serial(self.COM_PORT, self.BAUD_RATE, timeout=1)
            print(f"Successfully connected to {self.COM_PORT}")
            return True
        except Exception as e:
            print(f"UART Error: {e}")
            print("Available ports:")
            ports = serial.tools.list_ports.comports()
            for port in ports:
                print(f"- {port.device}")
            return False

    def send_to_fpga(self):
        """Send the downscaled image to FPGA via UART"""
        # Ensure we have the latest downscaled image
        self.downscale_image()
        
        if not self.init_uart():
            return

        try:
            # CHANGED: Direct send of uint8 data (no scaling needed)
            flat_data = self.downscaled.flatten()
            
            # Send bytes
            bytes_written = self.ser.write(flat_data.tobytes())
            print(f"Sent {bytes_written} bytes to FPGA.")
            
        except Exception as e:
            print(f"Error sending data: {e}")
            if self.ser:
                self.ser.close()
                self.ser = None
        
    def clear_canvas(self):
        """Clear the drawing canvas"""
        self.canvas = np.zeros((self.canvas_size, self.canvas_size), dtype=np.uint8)
        self.downscaled = np.zeros((28, 28), dtype=np.uint8)
        self.last_pos = None
        
    def draw_at_canvas_pos(self, canvas_x, canvas_y, erase=False):
        """Draw at a specific canvas coordinate"""
        if 0 <= canvas_x < self.canvas_size and 0 <= canvas_y < self.canvas_size:
            # Draw with brush size
            for dx in range(-self.brush_size, self.brush_size + 1):
                for dy in range(-self.brush_size, self.brush_size + 1):
                    px, py = canvas_x + dx, canvas_y + dy
                    if 0 <= px < self.canvas_size and 0 <= py < self.canvas_size:
                        if dx*dx + dy*dy <= self.brush_size * self.brush_size:
                            self.canvas[py, px] = 0 if erase else 255
    
    def draw_line(self, pos1, pos2, erase=False):
        """Draw a line between two positions using Bresenham's algorithm"""
        x1, y1 = pos1[0] // self.scale_factor, pos1[1] // self.scale_factor
        x2, y2 = pos2[0] // self.scale_factor, pos2[1] // self.scale_factor
        
        dx = abs(x2 - x1)
        dy = abs(y2 - y1)
        sx = 1 if x1 < x2 else -1
        sy = 1 if y1 < y2 else -1
        err = dx - dy
        
        while True:
            self.draw_at_canvas_pos(x1, y1, erase)
            
            if x1 == x2 and y1 == y2:
                break
                
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x1 += sx
            if e2 < dx:
                err += dx
                y1 += sy
    
    def draw_pixel(self, pos, erase=False):
        """Draw on the canvas at the given position"""
        x, y = pos
        # Convert screen coordinates to canvas coordinates
        canvas_x = x // self.scale_factor
        canvas_y = y // self.scale_factor
        
        # If we have a last position, draw a line to connect
        if self.last_pos is not None:
            self.draw_line(self.last_pos, pos, erase)
        else:
            self.draw_at_canvas_pos(canvas_x, canvas_y, erase)
        
        # Update last position
        self.last_pos = pos
    
    def downscale_image(self):
        """Downscale the canvas to 28x28 uint8 grayscale"""
        # Convert numpy array to PIL Image
        img = Image.fromarray(self.canvas, mode='L')
        
        # Resize to 28x28 using LANCZOS resampling for better quality
        img_resized = img.resize((28, 28), Image.Resampling.LANCZOS)
        
        # CHANGED: Keep range 0-255 and use uint8
        self.downscaled = np.array(img_resized, dtype=np.uint8)
        
        print("\n28x28 Downscaled Image (uint8):")
        print(self.downscaled)
        print(f"\nShape: {self.downscaled.shape}")
        print(f"Data type: {self.downscaled.dtype}")
        print(f"Min value: {self.downscaled.min()}, Max value: {self.downscaled.max()}")
        
        return self.downscaled
    
    def save_images(self):
        """Save both the original canvas and downscaled image"""
        # Save original canvas
        canvas_img = Image.fromarray(self.canvas, mode='L')
        canvas_img.save('canvas_original.png')
        
        # CHANGED: Save 28x28 downscaled (already in uint8 0-255 range)
        downscaled_img = Image.fromarray(self.downscaled, mode='L')
        downscaled_img.save('downscaled_28x28.png')
        
        # Save numpy array as .npy file
        np.save('downscaled_28x28.npy', self.downscaled)
        
        print("\nImages saved:")
        print(f"- canvas_original.png ({self.canvas_size}x{self.canvas_size})")
        print("- downscaled_28x28.png")
        print("- downscaled_28x28.npy")
    
    def draw_button(self, rect, text, color=None):
        """Draw a button with text"""
        if color is None:
            color = self.BLUE
        pygame.draw.rect(self.screen, color, rect)
        pygame.draw.rect(self.screen, self.BLACK, rect, 2)
        
        text_surf = self.small_font.render(text, True, self.WHITE)
        text_rect = text_surf.get_rect(center=rect.center)
        self.screen.blit(text_surf, text_rect)
    
    def draw_ui(self):
        """Draw the user interface"""
        # Draw canvas background
        canvas_rect = pygame.Rect(0, 0, self.display_size, self.display_size)
        pygame.draw.rect(self.screen, self.WHITE, canvas_rect)
        
        # Draw canvas content
        for y in range(self.canvas_size):
            for x in range(self.canvas_size):
                if self.canvas[y, x] > 0:
                    rect = pygame.Rect(
                        x * self.scale_factor,
                        y * self.scale_factor,
                        self.scale_factor,
                        self.scale_factor
                    )
                    pygame.draw.rect(self.screen, self.BLACK, rect)
        
        # Draw canvas border
        pygame.draw.rect(self.screen, self.BLACK, canvas_rect, 2)
        
        # Draw buttons
        self.draw_button(self.clear_button, "Clear")
        self.draw_button(self.process_button, "Process")
        self.draw_button(self.save_button, "Save")
        self.draw_button(self.send_button, "Send to FPGA", self.DARK_GRAY)
        self.draw_button(self.brush_up_button, "+", self.DARK_GRAY)
        self.draw_button(self.brush_down_button, "-", self.DARK_GRAY)
        
        # Draw brush size indicator
        brush_text = self.small_font.render(f"Brush: {self.brush_size}", True, self.BLACK)
        self.screen.blit(brush_text, (self.display_size + 160, 125))
        
        # Draw downscaled preview if available
        if np.any(self.downscaled != 0):
            preview_y = 200
            preview_text = self.font.render("28x28 Preview:", True, self.BLACK)
            self.screen.blit(preview_text, (self.display_size + 20, preview_y - 30))
            
            # Draw 28x28 preview (scaled up for visibility)
            preview_scale = 8
            for y in range(28):
                for x in range(28):
                    # CHANGED: Use value directly (0-255)
                    value = int(self.downscaled[y, x])
                    color = (value, value, value)
                    rect = pygame.Rect(
                        self.display_size + 20 + x * preview_scale,
                        preview_y + y * preview_scale,
                        preview_scale,
                        preview_scale
                    )
                    pygame.draw.rect(self.screen, color, rect)
            
            # Draw preview border
            preview_rect = pygame.Rect(
                self.display_size + 20,
                preview_y,
                28 * preview_scale,
                28 * preview_scale
            )
            pygame.draw.rect(self.screen, self.BLACK, preview_rect, 2)
        
        # Draw instructions
        instructions = [
            "Left Click: Draw",
            "Right Click: Erase",
            "Process: Downscale to 28x28",
            "Save: Export images",
            "Send: Transmit to FPGA"
        ]
        
        inst_y = self.display_size - 100
        inst_title = self.small_font.render("Instructions:", True, self.BLACK)
        self.screen.blit(inst_title, (10, inst_y))
        
        for i, inst in enumerate(instructions):
            text = self.small_font.render(inst, True, self.DARK_GRAY)
            self.screen.blit(text, (10, inst_y + 20 + i * 18))
    
    def handle_click(self, pos, button):
        """Handle mouse click events"""
        # Check button clicks
        if self.clear_button.collidepoint(pos):
            self.clear_canvas()
            print("Canvas cleared")
        elif self.process_button.collidepoint(pos):
            self.downscale_image()
        elif self.save_button.collidepoint(pos):
            self.save_images()
        elif self.send_button.collidepoint(pos): # Handle Send Click
            self.send_to_fpga()
        elif self.brush_up_button.collidepoint(pos):
            self.brush_size = min(10, self.brush_size + 1)
            print(f"Brush size: {self.brush_size}")
        elif self.brush_down_button.collidepoint(pos):
            self.brush_size = max(1, self.brush_size - 1)
            print(f"Brush size: {self.brush_size}")
        # Check if clicking on canvas
        elif pos[0] < self.display_size and pos[1] < self.display_size:
            if button == 1:  # Left click - draw
                self.is_drawing = True
                self.draw_pixel(pos, erase=False)
            elif button == 3:  # Right click - erase
                self.is_erasing = True
                self.draw_pixel(pos, erase=True)
    
    def run(self):
        """Main game loop"""
        running = True
        
        print("Drawing Harness Started")
        print("=" * 50)
        print("Controls:")
        print("- Left click and drag to draw")
        print("- Right click and drag to erase")
        print("- Click 'Clear' to reset canvas")
        print("- Click 'Process' to downscale to 28x28")
        print("- Click 'Save' to export images")
        print("- Use +/- buttons to adjust brush size")
        print("=" * 50)
        
        while running:
            self.screen.fill(self.WHITE)
            
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    self.handle_click(event.pos, event.button)
                
                elif event.type == pygame.MOUSEBUTTONUP:
                    self.is_drawing = False
                    self.is_erasing = False
                    self.last_pos = None  # Reset for next stroke
                
                elif event.type == pygame.MOUSEMOTION:
                    if self.is_drawing:
                        self.draw_pixel(event.pos, erase=False)
                    elif self.is_erasing:
                        self.draw_pixel(event.pos, erase=True)
                
                elif event.type == pygame.KEYDOWN:
                    if event.key == pygame.K_c:
                        self.clear_canvas()
                    elif event.key == pygame.K_p:
                        self.downscale_image()
                    elif event.key == pygame.K_s:
                        self.save_images()
            
            self.draw_ui()
            pygame.display.flip()
            self.clock.tick(60)  # 60 FPS
        
        pygame.quit()
        sys.exit()


if __name__ == "__main__":
    app = DrawingHarness()
    app.run()