`timescale 1ns / 1ps

// Hidden Layer RAM: Stores the 128 activations from Layer 1
// Data: 32-bit signed (accumulated results)
// Address: 7 bits (covers 128)
module HiddenRam(
    input wire clk,
    
    // Write Port (from Compute Logic)
    input wire we,
    input wire [6:0] addr_wr,
    input wire [31:0] data_in,
    
    // Read Port (for Layer 2 Calculation)
    input wire [6:0] addr_rd,
    output reg [31:0] data_out
);
    reg [31:0] ram [0:127];

    integer i;
    initial begin
        for (i=0; i<128; i=i+1) ram[i] = 0;
    end

    // Synchronous Write
    always @(posedge clk) begin
        if (we) begin
            ram[addr_wr] <= data_in;
        end
    end

    // Synchronous Read
    always @(posedge clk) begin
        data_out <= ram[addr_rd];
    end
endmodule

