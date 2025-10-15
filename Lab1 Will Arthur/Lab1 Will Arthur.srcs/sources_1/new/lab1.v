`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2025 11:12:24 AM
// Design Name: 
// Module Name: m21
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

module reg16(
        input clk,
        input rst,
        input [4:0] Ra,
        input [4:0] Rb,
        input [4:0] Rw,
        input WrEn,
        input [15:0] busW,
        output [15:0] busA,
        output [15:0] busB
        );
        
        //[0:31] array of 16 bit registers
        reg [15:0] myregs [0:31];
        
        integer i;
        
        always @(posedge clk or posedge rst) begin
            if (rst) begin
                for (i = 0; i < 32; i = i + 1) begin
                    myregs[i] <= 0; //set all to 0
                end
            end else begin
                if (WrEn) begin
                    myregs[Rw] <= busW; //write busW to Rw specified register
                end
            end
        end
        
        //assign to 2^5 = 32 specific register indicated by Ra/Rb (read reflects NEW VALUE IF r/w same time)
        assign busA = myregs[Ra];
        assign busB = myregs[Rb];
endmodule;