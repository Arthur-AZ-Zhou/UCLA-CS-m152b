# Drawing Harness - 112x112 to 28x28 Image Downscaler

A pygame-based drawing application that allows you to draw on a 112x112 canvas and downscale it to a 28x28 int8 grayscale image.

## Installation

Install the required dependencies:

```bash
pip install -r requirements.txt
```

## Usage

Run the application:

```bash
python drawing_harness.py
```

## Controls

### Mouse Controls
- **Left Click + Drag**: Draw in black
- **Right Click + Drag**: Erase (draw in white)

### Buttons
- **Clear**: Reset the canvas
- **Process**: Downscale the image to 28x28 and display preview
- **Save**: Export images to files
- **+ / -**: Adjust brush size

### Keyboard Shortcuts
- **C**: Clear canvas
- **P**: Process/downscale image
- **S**: Save images

## Features

- **112x112 Drawing Canvas**: Perfect 4x scaling to 28x28 for clean downscaling, displayed at 5x scale (560x560 pixels) for easy interaction
- **Variable Brush Size**: Adjustable from 1 to 5 pixels
- **Real-time Drawing**: Smooth drawing experience at 60 FPS with continuous brush strokes
- **High-Quality Downscaling**: Uses LANCZOS resampling for smooth 28x28 output with integer scaling
- **Multiple Export Formats**:
  - `canvas_original.png`: Original drawing (112x112)
  - `downscaled_28x28.png`: Downscaled image
  - `downscaled_28x28.npy`: NumPy array (int8) for direct use in Python

## Output Format

The downscaled image is a 28x28 numpy array with `dtype=np.int8`, containing grayscale values from 0 (black) to 127 (white). The original 0-255 range is scaled down by a factor of 2 to fit properly within the int8 range without negative value wraparound.

When you click "Process", the console will display:
- The complete 28x28 array
- Shape and data type confirmation
- Min and max pixel values

## Use Cases

Perfect for:
- MNIST-style digit recognition preprocessing
- Creating test images for neural networks
- Image processing experiments
- Quick sketching and downscaling workflows

