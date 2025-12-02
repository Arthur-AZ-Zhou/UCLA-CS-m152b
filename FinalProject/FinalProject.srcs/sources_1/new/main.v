`timescale 1ns / 1ps

module main(
    input wire clk,         // 100 MHz System Clock
    input wire reset,       // Center Button (Active High)
    input wire RsRx,        // UART RX Line
    output wire [15:0] led, // Debug LEDs
    output wire [6:0] seg,  // 7-Segment Cathodes
    output wire [3:0] an    // 7-Segment Anodes
);

    // ========================================================================
    // 1. Signal Definitions
    // ========================================================================
    
    // UART Signals
    wire [7:0] uart_data;
    wire uart_valid;
    
    // Image Loading Logic
    reg [9:0] load_addr_counter;
    reg image_loaded;
    
    // Compute Engine Signals
    wire ce_start;
    wire ce_done;
    wire [3:0] prediction;
    
    // RAM Interface Wires
    wire [9:0] ce_img_addr;
    wire [7:0] ce_img_data;
    wire [6:0] ce_hid_addr;
    wire ce_hid_we;
    wire [31:0] ce_hid_wdata;
    wire [31:0] ce_hid_rdata;

    // ========================================================================
    // 2. Control Logic (Image Loading & Trigger)
    // ========================================================================
    
    always @(posedge clk) begin
        if (reset) begin
            load_addr_counter <= 0;
            image_loaded <= 0;
        end else begin
            if (uart_valid) begin
                // Count up to 783 (784 bytes)
                if (load_addr_counter < 783) begin
                    load_addr_counter <= load_addr_counter + 1;
                    image_loaded <= 0;
                end else begin
                    load_addr_counter <= 0; // Wrap around for next image
                    image_loaded <= 1;      // Pulse start
                end
            end else begin
                image_loaded <= 0;
            end
        end
    end
    
    assign ce_start = image_loaded;

    // ========================================================================
    // 3. Module Instantiations
    // ========================================================================

    UartRx uart_inst (
        .clk(clk),
        .reset(reset),
        .rx(RsRx),
        .data(uart_data),
        .valid(uart_valid)
    );

    ImageRam img_ram_inst (
        .clk(clk),
        .we_a(uart_valid),
        .addr_a(load_addr_counter),
        .data_in_a(uart_data),
        .addr_b(ce_img_addr),
        .data_out_b(ce_img_data)
    );

    HiddenRam hid_ram_inst (
        .clk(clk),
        .we(ce_hid_we),
        .addr_wr(ce_hid_addr),
        .data_in(ce_hid_wdata),
        .addr_rd(ce_hid_addr),
        .data_out(ce_hid_rdata)
    );

    ComputeEngine ml_core (
        .clk(clk),
        .reset(reset),
        .start(ce_start),
        .done(ce_done),
        .predicted_digit(prediction),
        .img_addr(ce_img_addr),
        .img_data(ce_img_data),
        .hid_addr(ce_hid_addr),
        .hid_we(ce_hid_we),
        .hid_wdata(ce_hid_wdata),
        .hid_rdata(ce_hid_rdata)
    );

    SegmentDisplayDriver disp_driver (
        .num(prediction),
        .seg(seg),
        .an(an)
    );

    // ========================================================================
    // 4. Debug Visualization Logic (The Fix)
    // ========================================================================
    
    // LED 14: Toggle State (Flips every time inference finishes)
    reg led_done_toggle = 0;
    always @(posedge clk) begin
        if (reset) led_done_toggle <= 0;
        else if (ce_done) led_done_toggle <= ~led_done_toggle;
    end

    // LED 15: Toggle State (Flips every time a byte is received)
    reg led_uart_toggle = 0;
    always @(posedge clk) begin
        if (reset) led_uart_toggle <= 0;
        else if (uart_valid) led_uart_toggle <= ~led_uart_toggle;
    end

    // Assignments
    assign led[15] = led_uart_toggle;      // Will flicker/glow during transfer
    assign led[14] = led_done_toggle;      // Will flip ON/OFF after each prediction
    assign led[13:4] = load_addr_counter;  // PROGRESS BAR! Watch these bits count up.
    assign led[3:0] = prediction;          // Prediction in binary

endmodule
