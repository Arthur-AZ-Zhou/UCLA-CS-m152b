`timescale 1ns / 1ps

module ComputeUnit(
    input wire clk,
    input wire reset,
    input wire enable, // Only accumulate when enabled
    input wire signed [8:0] pixel,  // 9-bit SIGNED (0 to 255, bit 8 is always 0)
    input wire signed [7:0] weight, // 8-bit SIGNED (-128 to 127)
    output reg signed [31:0] accumulator
);
    
    // DSP Slice inference: Signed * Signed
    always @(posedge clk) begin
        if (reset) begin
            accumulator <= 0;
        end else if (enable) begin
            accumulator <= accumulator + (pixel * weight);
        end
    end

endmodule
