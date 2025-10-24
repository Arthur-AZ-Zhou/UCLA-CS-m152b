`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 11:13:45 AM
// Design Name: 
// Module Name: addbit
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


module alu(
    input [15:0] a,
    input [15:0] b,
    input [3:0] ctrl,
    output [15:0] s,
    output zero,
    output overflow
);

    wire [15:0] add_out, sub_out, or_out, and_out, dec_out, inc_out, inv_out;
    wire [15:0] ashiftl_out, ashiftr_out, lshift_out, rshift_out;
    wire sle_bit;

    wire add_cout, sub_cout;
    adder16 add_unit (.a(a), .b(b), .cin(0), .sum(add_out), .cout(add_cout));
    subtract16 sub_unit (.a(a), .b(b), .out(sub_out), .cout(sub_cout));

    or16 or_unit (.a(a), .b(b), .out(or_out));
    and16 and_unit (.a(a), .b(b), .out(and_out));

    increment inc_unit (.a(a), .out(inc_out));
    decrement dec_unit (.a(a), .out(dec_out));
    invert16 inv_unit (.a(a), .out(inv_out));

    lshiftby lshift_unit (.a(a), .b(b), .out(lshift_out));
    rshiftby rshift_unit (.a(a), .b(b), .arithmetic(1'b0), .out(rshift_out));

    lshiftby ashiftl_unit (.a(a), .b(b), .out(ashiftl_out));
    rshiftby ashiftr_unit (.a(a), .b(b), .arithmetic(1'b1), .out(ashiftr_out));

    sle16 sle_unit (.a(a), .b(b), .out(sle_bit));
    wire [15:0] sle_out = {15'b0, sle_bit};

    mux16to1_16bit result_mux (
        .in0 (sub_out), // 0000
        .in1 (add_out), // 0001
        .in2 (or_out), // 0010
        .in3 (and_out), // 0011
        .in4 (dec_out), // 0100
        .in5 (inc_out), // 0101
        .in6 (inv_out), // 0110
        .in7 (16'b0),
        .in8 (lshift_out), // 1000
        .in9 (sle_out), // 1001
        .in10 (rshift_out), // 1010
        .in11 (16'b0),
        .in12 (ashiftl_out), // 1100
        .in13 (16'b0),
        .in14 (ashiftr_out), // 1110
        .in15 (16'b0),
        .sel(ctrl),
        .out(s)
    );
    // zero flag
    assign zero = (s == 16'b0) ? 1'b1 : 1'b0;
    
    wire ovf_add, ovf_sub, ovf_inv;
    // Intermediate wires for ovf_add
    wire a15_xor_b15_add, s15_xor_a15_add;
    wire not_a15_xor_b15_add;
    
    // a[15] XOR b[15]
    custom_xor xor1 (a15_xor_b15_add, a[15], b[15]);
    
    // NOT (a[15] XOR b[15])
    not (not_a15_xor_b15_add, a15_xor_b15_add);
    
    // add_out[15] XOR a[15]
    custom_xor xor2 (s15_xor_a15_add, add_out[15], a[15]);
    
    // ovf_add = ~a15^b15 & (add_out[15] ^ a[15])
    and (ovf_add, not_a15_xor_b15_add, s15_xor_a15_add);
    
    
    // Intermediate wires for ovf_sub
    wire a15_xor_b15_sub, s15_xor_a15_sub;
    
    // a[15] XOR b[15]
    custom_xor xor3 (a15_xor_b15_sub, a[15], b[15]);
    
    // sub_out[15] XOR a[15]
    custom_xor xor4 (s15_xor_a15_sub, sub_out[15], a[15]);
    
    // ovf_sub = a[15] ^ b[15] & (sub_out[15] ^ a[15])
    and (ovf_sub, a15_xor_b15_sub, s15_xor_a15_sub);

    equal_16bit(ovf_inv, a, 16'h8000);


    // overflow flag for arithmetic shifts when sign bit changed
    wire a_sign = a[15];
    wire ashiftl_sign = ashiftl_out[15];
    wire ashiftr_sign = ashiftr_out[15];

   
    wire ovf_ashiftl;
    wire ovf_ashiftr;
    
    wire cond1;
    wire cond2;
    equal_4bit f1(.Y(cond1), .A(ctrl), .B(4'b1100));
    custom_xor f2(cond2, a_sign, ashiftl_sign);
    and (ovf_ashiftl, cond1, cond2);
    
    wire condr_1;
    wire condr_2;
    equal_4bit f3(.Y(condr_1), .A(ctrl), .B(4'b1110));
    custom_xor f4(condr_2, a_sign, ashiftr_sign);
    and (ovf_ashiftr, condr_1, condr_2);

    m16_1 overflow_mux ({1'b0, ovf_ashiftr, 1'b0, ovf_ashiftl, 1'b0, 1'b0, ovf_inv, 1'b0, 
    1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, ovf_add, ovf_sub}, ctrl, overflow);
//        .in0 (sub_cout), // 0000
//        .in1 (add_cout), // 0001
//        .in2 (or_out), // 0010
//        .in3 (and_out), // 0011
//        .in4 (dec_out), // 0100
//        .in5 (inc_out), // 0101
//        .in6 (inv_out), // 0110
//        .in7 (16'b0),
//        .in8 (lshift_out), // 1000
//        .in9 (sle_out), // 1001
//        .in10 (rshift_out), // 1010
//        .in11 (16'b0),
//        .in12 (ashiftl_out), // 1100
//        .in13 (16'b0),
//        .in14 (ashiftr_out), // 1110
//        .in15 (16'b0),
//        .sel(ctrl),
//        .out(s)
//    );
//    or(overflow, ovf_ashiftl, ovf_ashiftr, add_cout, sub_cout);

endmodule

module custom_xnor(
    output y,
    input a,
    input b
    );
    wire xor_a_b;
    custom_xor joe(xor_a_b, a, b);
    not (y, xor_a_b);
endmodule
    
module equal_4bit(
    output Y,
    input [3:0] A,
    input [3:0] B
    );
    wire equals[3:0];
    genvar i;
    generate
        for (i=0; i<4; i=i+1) begin
            custom_xnor xnor_bit(equals[i], A[i], B[i]);
        end
    endgenerate
    and final(Y, equals[0], equals[1], equals[2], equals[3]); 
endmodule

module equal_16bit(
    output Y,
    input [15:0] A,
    input [15:0] B
    );
    wire equals[15:0];
    genvar i;
    generate
        for (i=0; i<16; i=i+1) begin
            custom_xnor xnor_bit(equals[i], A[i], B[i]);
        end
    endgenerate
    wire and_chain[15:0];
    assign and_chain[0] = equals[0];
    genvar j;
    generate
        for (j=1; j<16; j=j+1) begin
            and (and_chain[j], and_chain[j-1], equals[j]);
        end
    endgenerate
    assign Y = and_chain[15];
endmodule

module m2_1(
    input D0,
    input D1,
    input S,
    output Y
);
    wire T1, T2, Sbar;
    and (T1, D1, S);
    not (Sbar, S);
    and (T2, D0, Sbar);
    or  (Y, T1, T2);
endmodule

module m4_1(
    input [3:0] D,
    input [1:0] S,
    output Y
);
    wire T1, T2;
    m2_1 u1 (.D0(D[0]), .D1(D[1]), .S(S[0]), .Y(T1));
    m2_1 u2 (.D0(D[2]), .D1(D[3]), .S(S[0]), .Y(T2));
    m2_1 u3 (.D0(T1), .D1(T2), .S(S[1]), .Y(Y));
endmodule

module m8_1(
    input [7:0] D,
    input [2:0] S,
    output Y
);
    wire T1, T2;
    m4_1 u1 (.D(D[3:0]), .S(S[1:0]), .Y(T1));
    m4_1 u2 (.D(D[7:4]), .S(S[1:0]), .Y(T2));
    m2_1 u3 (.D0(T1), .D1(T2), .S(S[2]), .Y(Y));
endmodule

module m16_1(
    input [15:0] D,
    input [3:0] S,
    output Y
);
    wire T1, T2;
    m8_1 u1 (.D(D[7:0]), .S(S[2:0]), .Y(T1));
    m8_1 u2 (.D(D[15:8]), .S(S[2:0]), .Y(T2));
    m2_1 u3 (.D0(T1), .D1(T2), .S(S[3]), .Y(Y));
endmodule


module mux16to1_16bit (
    input  [15:0] in0,
    input  [15:0] in1,
    input  [15:0] in2,
    input  [15:0] in3,
    input  [15:0] in4,
    input  [15:0] in5,
    input  [15:0] in6,
    input  [15:0] in7,
    input  [15:0] in8,
    input  [15:0] in9,
    input  [15:0] in10,
    input  [15:0] in11,
    input  [15:0] in12,
    input  [15:0] in13,
    input  [15:0] in14,
    input  [15:0] in15,
    input  [3:0] sel,
    output [15:0] out
);
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : mux_bitwise
            wire [15:0] bit_slice;
            assign bit_slice = {
                in15[i], in14[i], in13[i], in12[i],
                in11[i], in10[i], in9[i], in8[i],
                in7[i], in6[i], in5[i], in4[i],
                in3[i], in2[i], in1[i], in0[i]
            };

            m16_1 u_mux (
                .D(bit_slice),
                .S(sel),
                .Y(out[i])
            );
        end
    endgenerate
endmodule



// not allowed to use builtin XOR
module custom_xor( 
    output y,
    input a,
    input b
    );
    
    wire notA, notB, AAndNotB, NotAAndB;
    not (notA, a);
    not (notB, b);
    and (AAndNotB, a, notB);
    and (NotAAndB, notA, b);
    or (y, AAndNotB, NotAAndB);
endmodule    
    
module adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
    );
    
    wire AXorB, AAndB, AXorB_And_Cin;
    
    custom_xor x1 (.y(AXorB), .a(a), .b(b));
    custom_xor x2 (.y(sum), .a(AXorB), .b(cin));
    and (AAndB, a, b);
    and (AXorB_And_Cin, AXorB, cin);
    or (cout, AAndB, AXorB_And_Cin);
endmodule


module adder16(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
    );
    
    wire [15:0] c;
    
    adder adder_0 (.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .cout(c[0]));
    
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin
            adder adder_i (.a(a[i]), .b(b[i]), .cin(c[i-1]), .sum(sum[i]), .cout(c[i]));
        end
    endgenerate
    
    assign cout = c[15];
 
endmodule

module increment(
    input [15:0] a,
    output [15:0] out
    );
    wire co;
    adder16 inc (.a(a), .b(16'b1), .cin(0), .sum(out), .cout(co));
endmodule

module decrement(
    input [15:0] a,
    output [15:0] out
    );
    wire co;
    adder16 dec (.a(a), .b(-1), .cin(0), .sum(out), .cout(co));
endmodule
    
module invert16(
    input [15:0] a,
    output [15:0] out
    );
    
    wire [15:0] notA;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            not (notA[i], a[i]);
        end
    endgenerate
    
    increment inc (.a(notA), .out(out));
    
endmodule

module subtract16(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out,
    output cout
    );
    
    wire [15:0] negB;
    
    invert16 inv (.a(b), .out(negB));
    adder16 sub (.a(a), .b(negB), .cin(0), .sum(out), .cout(cout));
    
endmodule

    
module or16(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
    );
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            or (out[i], a[i], b[i]);
        end
    endgenerate
    
endmodule

module and16(
    input [15:0] a,
    input [15:0] b,
    output [15:0] out
    );
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin
            and (out[i], a[i], b[i]);
        end
    endgenerate
    
endmodule

module sle16(
    input [15:0] a,
    input [15:0] b,
    output out
    );
    
    wire [15:0] sum;
    wire garbage;

    subtract16 sub (.a(a), .b(b), .out(sum), .cout(garbage));
    
    assign out = sum[15];
    
endmodule

module lshift_stage_1 (
    input [15:0] in,
    input enable,
    output [15:0] out
);
    assign out = enable ? {in[14:0], 1'b0} : in;
endmodule

module lshift_stage_2 (
    input [15:0] in,
    input enable,
    output [15:0] out
);
    assign out = enable ? {in[13:0], 2'b0} : in;
endmodule


module lshift_stage_4 (
    input [15:0] in,
    input enable,
    output [15:0] out
);
    assign out = enable ? {in[11:0], 4'b0} : in;
endmodule

module lshift_stage_8 (
    input [15:0] in,
    input enable,
    output [15:0] out
);
    assign out = enable ? {in[7:0], 8'b0} : in;
endmodule


module lshiftby(
    input  [15:0] a,
    input  [15:0]  b,
    output [15:0] out
);

    wire [15:0] stage1_out;
    wire [15:0] stage2_out;
    wire [15:0] stage3_out;
    wire [15:0] stage4_out;

    lshift_stage_1 s1 (
        .in(a),
        .enable(b[0]),
        .out(stage1_out)
    );

    lshift_stage_2 s2 (
        .in(stage1_out),
        .enable(b[1]),
        .out(stage2_out)
    );

    lshift_stage_4 s4 (
        .in(stage2_out),
        .enable(b[2]),
        .out(stage3_out)
    );

    lshift_stage_8 s8 (
        .in(stage3_out),
        .enable(b[3]),
        .out(stage4_out)
    );

    assign out = stage4_out;

endmodule


module rshift_stage_1 (
    input [15:0] in,
    input enable,
    input arithmetic,
    output [15:0] out
);
    assign out = enable ? {arithmetic ? in[15] : 1'b0, in[15:1]} : in;
endmodule

module rshift_stage_2 (
    input [15:0] in,
    input enable,
    input arithmetic,
    output [15:0] out
);
    assign out = enable ? { {2{arithmetic ? in[15] : 1'b0}}, in[15:2]} : in;
endmodule


module rshift_stage_4 (
    input [15:0] in,
    input enable,
    input arithmetic,
    output [15:0] out
);
    assign out = enable ? { {4{arithmetic ? in[15] : 1'b0}}, in[15:4]} : in;
endmodule

module rshift_stage_8 (
    input [15:0] in,
    input enable,
    input arithmetic,
    output [15:0] out
);
    assign out = enable ? { {8{arithmetic ? in[15] : 1'b0}}, in[15:8]} : in;
endmodule


module rshiftby(
    input  [15:0] a,
    input  [15:0]  b,
    input arithmetic,
    output [15:0] out
);

    wire [15:0] stage1_out;
    wire [15:0] stage2_out;
    wire [15:0] stage3_out;
    wire [15:0] stage4_out;

    rshift_stage_1 s1 (
        .in(a),
        .enable(b[0]),
        .arithmetic(arithmetic),
        .out(stage1_out)
    );

    rshift_stage_2 s2 (
        .in(stage1_out),
        .enable(b[1]),
        .arithmetic(arithmetic),
        .out(stage2_out)
    );

    rshift_stage_4 s4 (
        .in(stage2_out),
        .enable(b[2]),
        .arithmetic(arithmetic),
        .out(stage3_out)
    );

    rshift_stage_8 s8 (
        .in(stage3_out),
        .enable(b[3]),
        .arithmetic(arithmetic),
        .out(stage4_out)
    );

    assign out = stage4_out;

endmodule
