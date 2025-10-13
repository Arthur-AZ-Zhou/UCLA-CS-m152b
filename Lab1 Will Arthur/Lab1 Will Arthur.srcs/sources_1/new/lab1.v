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
        m81(T1, D[0:7], S[0:2]);
        m81(T2, D[8:15], S[0:2]);
        m21(Y, T1, T2, S[3]);
endmodule

module alu_1bit(
        input [0:5]S,
        input D
        );
        
endmodule; 