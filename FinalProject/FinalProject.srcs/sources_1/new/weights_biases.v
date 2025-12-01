`timescale 1ns / 1ps

// Layer 1 Weights: Organized for 64-way parallelism
// Total Weights: 100,352
// Access Pattern: We read 64 weights at once (one for each active neuron).
// Width: 64 * 8 bits = 512 bits.
// Depth: 100,352 / 64 = 1,568 lines.
// Address: 11 bits (covers 1568)
module WeightRamWideL1(
    input wire clk,
    input wire [10:0] addr,
    output reg [511:0] data // 64 bytes packed
);
    // 2048 is next power of 2 for 1568
    reg [511:0] rom [0:2047];

    initial begin
        // This file must be generated with 64 hex bytes per line
        $readmemh("weights_l1_wide.mem", rom);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule

// Layer 2 Weights: 128 inputs * 10 outputs = 1,280 bytes
// For Layer 2, we only have 10 outputs.
// We can just use 10 of our 64 DSPs.
// We can store weights simply packed 10-wide or just separate.
// Let's pack them 10-wide (80 bits) to be efficient.
// Width: 10 * 8 = 80 bits.
// Depth: 128 inputs.
module WeightRamWideL2(
    input wire clk,
    input wire [6:0] addr, // 0 to 127
    output reg [79:0] data // 10 bytes packed
);
    reg [79:0] rom [0:127];

    initial begin
        $readmemh("weights_l2_wide.mem", rom);
    end

    always @(posedge clk) begin
        data <= rom[addr];
    end
endmodule
