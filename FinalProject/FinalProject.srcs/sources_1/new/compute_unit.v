`timescale 1ns / 1ps

module ComputeUnit(
    input wire clk,
    input wire reset,
    input wire enable, // Only accumulate when enabled
    input wire signed [7:0] pixel,
    input wire signed [7:0] weight,
    output reg signed [31:0] accumulator
);
    
    // DSP Slice inference usually happens automatically with this pattern
    always @(posedge clk) begin
        if (reset) begin
            accumulator <= 0;
        end else if (enable) begin
            accumulator <= accumulator + (pixel * weight);
        end
    end

endmodule

