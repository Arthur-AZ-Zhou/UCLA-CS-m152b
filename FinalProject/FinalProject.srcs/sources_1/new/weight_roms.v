`timescale 1ns / 1ps

// ============================================================================
// Layer 1 Weight ROM
// Configuration: 64-way SIMD (512-bit wide read)
// Capacity: 784 inputs * 2 batches = 1568 lines
// ============================================================================
module WeightRamWideL1(
    input wire clk,
    input wire [10:0] addr, // Address range: 0 to 1567
    output reg [511:0] data // 64 bytes packed (64 * 8 bits)
);
    // 2048 is the nearest power-of-2 depth to hold 1568 lines
    reg [511:0] rom [0:2047];

    initial begin
        // Load the 64-way interleaved weights
        $readmemh("weights_l1.mem", rom);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule

// ============================================================================
// Layer 2 Weight ROM
// Configuration: 10-way SIMD (80-bit wide read)
// Capacity: 128 hidden neurons = 128 lines
// ============================================================================
module WeightRamWideL2(
    input wire clk,
    input wire [6:0] addr, // Address range: 0 to 127
    output reg [79:0] data // 10 bytes packed (10 * 8 bits)
);
    // Depth covers exactly the 128 hidden layer inputs
    reg [79:0] rom [0:127];

    initial begin
        // Load the 10-way weights for the final layer
        $readmemh("weights_l2.mem", rom);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule

// ============================================================================
// Quantization Shift Parameter ROM
// Purpose: Stores the bit-shift values calculated in Python
// Addr 0: Layer 1 Shift
// Addr 1: Layer 2 Shift
// ============================================================================
module ShiftRam(
    input wire clk,
    input wire addr,       // 0 for Layer 1, 1 for Layer 2
    output reg [7:0] data  // The shift amount (e.g., 8, 11)
);
    reg [7:0] rom [0:1];

    initial begin
        $readmemh("shifts.mem", rom);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule