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

module m2_1(
    input D0,
    input D1,
    input S,
    output Y
    );
    wire T1, T2, Sbar;
    and (T1, D1, S); // T1 = D1 && S
    and (T2, D0, Sbar); // T2 = D0 && Sbar
    not (Sbar, S); // Sbar = ~S
    or (Y, T1, T2); // Y = T1 | T2
    // Note that the sequence of instructions are not synchronous.
endmodule

module m3_1(
        input D0,
        input D1,
        input D2,
        input [0:1]S,
        output Y
        );
        wire T1;
        m2_1(T1, D0, D1, S[0]);
        m2_1(Y, T1, D2, S[1]);    
endmodule

module m4_1(
        input [0:3]D,
        input [0:1]S,
        output Y
        );
        wire T1;
        wire T2;
        m2_1(T1, D[0], D[1], S[0]);
        m2_1(T2, D[2], D[3], S[0]);
        m2_1(Y, T1, T2, S[1]);
endmodule

module m8_1(
        input wire [0:7]D,
        input wire [0:2]S,
        output Y
        );
        wire T1;
        wire T2;
        m4_1(T1, D[0:3], S[0:1]);
        m4_1(T2, D[4:7], S[0:1]);
        m2_1(Y, T1, T2, S[2]);
endmodule

module m16_1(
        input [0:15]D,
        input [0:3]S,
        output Y
        );
        wire T1;
        wire T2;
        m8_1(T1, D[0:7], S[0:2]);
        m8_1(T2, D[8:15], S[0:2]);
        m2_1(Y, T1, T2, S[3]);
endmodule

module alu_1bit(
        input [0:5]S,
        input D
        );
        
endmodule; 

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