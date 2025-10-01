`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2025 11:08:00 AM
// Design Name: 
// Module Name: my_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module my_counter(
    input clock,
    input reset,
    input enable,
    output reg [3:0] counter_output
    );
    
    // Main logic
    always @(posedge clock or posedge reset)
        if (reset) begin
            counter_output = 0;
        end else if (enable)
            begin
            counter_output <= counter_output + 1;
        end
    
endmodule
