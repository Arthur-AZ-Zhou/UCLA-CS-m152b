`timescale 1ns / 1ps

module main(
    input wire clk,
    input wire reset, // Center Button
    input wire RsRx,  // UART RX
    output wire [15:0] led, // Debug LEDs
    output wire [6:0] seg,  // 7-segment cathodes
    output wire [3:0] an    // 7-segment anodes
);

    // --- Clock Divider (100MHz -> 25MHz) ---
    reg [1:0] clk_div;
    always @(posedge clk) begin
        clk_div <= clk_div + 1;
    end
    wire clk_25mhz = clk_div[1]; // Divide by 4

    // --- Signals ---
    wire [7:0] uart_data;
    wire uart_valid;
    
    reg [9:0] write_addr;
    reg img_loaded;
    
    // --- ML Core Signals ---
    wire ml_start;
    wire ml_done;
    wire [3:0] prediction;
    
    // Image RAM Interface
    wire [9:0] ml_img_addr;
    wire [7:0] ml_img_data;
    
    // Hidden RAM Interface
    wire [6:0] hid_addr_wr, hid_addr_rd;
    wire hid_we;
    wire [31:0] hid_wdata, hid_rdata;
    wire [6:0] hid_addr_mux; // Muxed address for RAM

    // Debug: Display received byte on LEDs
    // LED 15: Image Loaded
    // LED 14: ML Done
    // LED 0-3: Prediction
    assign led[15] = img_loaded;
    assign led[14] = ml_done;
    assign led[3:0] = prediction;
    assign led[13:4] = 0;

    // --- 1. UART Receiver ---
    // Note: We need to update UartRx to expect 25MHz clock!
    UartRx uart_inst (
        .clk(clk_25mhz),
        .reset(reset),
        .rx(RsRx),
        .data(uart_data),
        .valid(uart_valid)
    );

    // --- 2. Image RAM ---
    ImageRam ram_inst (
        .clk(clk_25mhz),
        // Write Port (UART)
        .we_a(uart_valid),      
        .addr_a(write_addr),
        .data_in_a(uart_data),
        // Read Port (ML Core)
        .addr_b(ml_img_addr),
        .data_out_b(ml_img_data)
    );

    // --- 3. Hidden RAM ---
    // Mux logic inside ComputeEngine handles read vs write phases? 
    // Actually ComputeEngine outputs separate read/write addresses, 
    // but HiddenRam has separate Read/Write ports!
    // Port A: Write (from L1 compute)
    // Port B: Read (for L2 compute)
    // BUT HiddenRam.v I wrote earlier is Simple Dual Port (Write Port, Read Port).
    // Let's check HiddenRam ports: we, addr_wr, data_in, addr_rd, data_out. Perfect.
    
    HiddenRam hid_ram_inst (
        .clk(clk_25mhz),
        .we(hid_we),
        .addr_wr(hid_addr_wr),
        .data_in(hid_wdata),
        .addr_rd(hid_addr_rd), // Note: ComputeEngine needs to output this
        .data_out(hid_rdata)
    );
    // Wait, ComputeEngine outputs `hidden_addr`. It uses ONE address pointer 
    // because it never reads and writes at the same time.
    // So we need to wire `hidden_addr` to BOTH addr_wr and addr_rd.
    assign hid_addr_wr = hid_addr_mux;
    assign hid_addr_rd = hid_addr_mux;

    // --- 4. Compute Engine ---
    ComputeEngine ml_core (
        .clk(clk_25mhz),
        .reset(reset),
        .start(ml_start),
        .done(ml_done),
        .predicted_digit(prediction),
        
        // Image RAM
        .img_addr(ml_img_addr),
        .img_data(ml_img_data),
        
        // Hidden RAM
        .hidden_addr(hid_addr_mux),
        .hidden_we(hid_we),
        .hidden_wdata(hid_wdata),
        .hidden_rdata(hid_rdata)
    );

    // --- 5. Display Driver ---
    // Show "dONE" when done, or the digit?
    // Let's just show the digit.
    // Note: Display driver is combinational (no clk), so it's fine.
    SegmentDisplayDriver seg_driver (
        .num(prediction),
        .seg(seg),
        .an(an)
    );

    // --- 6. Control Logic ---
    // Start ML when image is fully loaded
    assign ml_start = img_loaded; 
    // Note: This holds `start` high forever. ComputeEngine should handle this 
    // (start on rising edge or level? My code used `if (start)` in IDLE, so level is fine 
    // as long as it transitions out of IDLE).

    always @(posedge clk_25mhz) begin
        if (reset) begin
            write_addr <= 0;
            img_loaded <= 0;
        end else begin
            if (uart_valid) begin
                // If we haven't filled the memory yet
                if (write_addr < 784) begin
                    write_addr <= write_addr + 1;
                    
                    // Check if we just wrote the LAST byte (783)
                    if (write_addr == 783) begin
                        img_loaded <= 1;
                    end
                end 
            end
            
            // Auto-reset image loader if we want to load a NEW image?
            // For now, require manual RESET button press to load new image.
        end
    end

endmodule
