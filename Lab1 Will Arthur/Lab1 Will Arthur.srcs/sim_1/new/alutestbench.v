`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/20/2025 10:50:44 AM
// Design Name: 
// Module Name: alutestbench
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


module alutestbench();
    reg [15:0] a;
    reg [15:0] b;
    reg [3:0] ctrl;
    wire [15:0] s;
    wire zero;
    wire overflow;
    alu dut(
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .s(s),
        .zero(zero),
        .overflow(overflow)
    );
    initial begin;
        // test subtraction
        ctrl = 4'b0000;
        a = 16'sd1025;
        b = 16'sd125; 
        // a - b should be 900
        #10;
        $display("Sub_out", dut.sub_out);
        $display("Inv a", dut.sub_unit.a);
        $display("Inv b", dut.sub_unit.b);
        $display("Inv out", dut.sub_unit.out);
        $display("Add_out", dut.add_out);
        $display("or_out", dut.or_out);
        // check that zero is false
        
        a = 16'sd367;
        b = 16'sd367;
        // check that zero is true
        #10;
        
        a = 16'sd15;
        b = 16'sd25;
        // should be negative 10
        // check that zero is false
        #10; 

        // Overflow case (positive - negative = overflow)
        a = 16'h7FFF; b = 16'hFFFF; // 32767 - (-1)
        #10;
        $display("%0t\tSUB\t%d\t\t%d\t\t%d\t\t%b\t%b", $time, $signed(a), $signed(b), $signed(s), zero, overflow);
        $display(dut.sub_cout, dut.add_cout, dut.ovf_ashiftl, dut.ovf_ashiftr);
        #100;
        // ===== TEST ADDITION (0001) =====
        $display("\n----- ADDITION (ctrl=0001) -----");
        ctrl = 4'b0001;
        
        // Basic addition
        a = 16'd500; b = 16'd250;
        #10;
        $display("%0t\tADD\t%d\t\t%d\t\t%d\t\t%b\t%b", $time, a, b, s, zero, overflow);
        
        // Addition to zero
        a = 16'hFFFF; b = 16'd1;
        #10;
        $display("%0t\tADD\t%d\t\t%d\t\t%d\t\t%b\t%b", $time, $signed(a), b, s, zero, overflow);
        
        // Overflow case (positive + positive = negative)
        a = 16'h7FFF; b = 16'd1; // 32767 + 1
        #10;
        $display("%0t\tADD\t%d\t\t%d\t\t%d\t\t%b\t%b", $time, $signed(a), b, $signed(s), zero, overflow);
        
        // Large addition
        a = 16'd30000; b = 16'd20000;
        #10;
        $display("%0t\tADD\t%d\t\t%d\t\t%d\t\t%b\t%b", $time, a, b, s, zero, overflow);
        
        #100;
        // ===== TEST OR (0010) =====
        $display("\n----- BITWISE OR (ctrl=0010) -----");
        ctrl = 4'b0010;
        
        a = 16'hAAAA; b = 16'h5555;
        #10;
        $display("%0t\tOR\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'hF0F0; b = 16'h0F0F;
        #10;
        $display("%0t\tOR\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        // OR with zero
        a = 16'h0000; b = 16'h0000;
        #10;
        $display("%0t\tOR\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        #100;
        // ===== TEST AND (0011) =====
        $display("\n----- BITWISE AND (ctrl=0011) -----");
        ctrl = 4'b0011;
        
        a = 16'hAAAA; b = 16'h5555;
        #10;
        $display("%0t\tAND\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'hFFFF; b = 16'h00FF;
        #10;
        $display("%0t\tAND\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
                
        a = 16'hF0F0; b = 16'h0F0F;
        #10;
        $display("%0t\tAND\t%h\t%h\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        

        #100;
        // ===== TEST DECREMENT (0100) =====
        $display("\n----- DECREMENT (ctrl=0100) -----");
        ctrl = 4'b0100;
        
        a = 16'd100; b = 16'd0; // b is ignored
        #10;
        $display("%0t\tDEC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, s, zero, overflow);
        
        a = 16'd1;
        #10;
        $display("%0t\tDEC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, s, zero, overflow);
        
        a = 16'd0;
        #10;
        $display("%0t\tDEC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, $signed(s), zero, overflow);
        
        #100;
        // ===== TEST INCREMENT (0101) =====
        $display("\n----- INCREMENT (ctrl=0101) -----");
        ctrl = 4'b0101;
        
        a = 16'd100; b = 16'd0;
        #10;
        $display("%0t\tINC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, s, zero, overflow);
        
        a = 16'hFFFF;
        #10;
        $display("%0t\tINC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, $signed(a), s, zero, overflow);
        
        a = 16'd0;
        #10;
        $display("%0t\tINC\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, s, zero, overflow);
        
        #100;
        // ===== TEST INVERT (0110) =====
        $display("\n----- INVERT/NEGATE (ctrl=0110) -----");
        ctrl = 4'b0110;
        
        a = 16'd100; b = 16'd0;
        #10;
        $display("%0t\tINV\t%d\t\t-\t\t%d\t\t%b\t%b", $time, $signed(a), $signed(s), zero, overflow);
        
        a = 16'd0;
        #10;
        $display("%0t\tINV\t%d\t\t-\t\t%d\t\t%b\t%b", $time, a, s, zero, overflow);
        
        a = 16'hFFFF; // -1
        #10;
        $display("%0t\tINV\t%d\t\t-\t\t%d\t\t%b\t%b", $time, $signed(a), $signed(s), zero, overflow);
        
        #100;
        // ===== TEST LOGICAL LEFT SHIFT (1000) =====
        $display("\n----- LOGICAL LEFT SHIFT (ctrl=1000) -----");
        ctrl = 4'b1000;
        
        a = 16'h0001; b = 16'd1;
        #10;
        $display("%0t\tLSL\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'h0001; b = 16'd4;
        #10;
        $display("%0t\tLSL\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'h00FF; b = 16'd8;
        #10;
        $display("%0t\tLSL\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'h1234; b = 16'd0;
        #10;
        $display("%0t\tLSL\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        #100;
        // ===== TEST SLE (1001) =====
        $display("\n----- SET IF LESS OR EQUAL (ctrl=1001) -----");
        ctrl = 4'b1001;
        
        a = 16'd5; b = 16'd10;
        #10;
        $display("%0t\tSLE\t%d\t\t%d\t\t%d\t\t%b\t%b (a<=b: expect 1)", $time, $signed(a), $signed(b), s, zero, overflow);
        
        a = 16'd10; b = 16'd5;
        #10;
        $display("%0t\tSLE\t%d\t\t%d\t\t%d\t\t%b\t%b (a>b: expect 0)", $time, $signed(a), $signed(b), s, zero, overflow);
        
         a = 16'd10; b = 16'd10;
        #10;
        $display("%0t\tSLE\t%d\t\t%d\t\t%d\t\t%b\t%b (a==b: expect 1)", $time, $signed(a), $signed(b), s, zero, overflow);
        
        // Negative numbers
        a = 16'hFFFF; b = 16'd5; // -1 <= 5
        #10;
        $display("%0t\tSLE\t%d\t\t%d\t\t%d\t\t%b\t%b (neg<=pos: expect 1)", $time, $signed(a), $signed(b), s, zero, overflow);
        
        #100;
        // ===== TEST LOGICAL RIGHT SHIFT (1010) =====
        $display("\n----- LOGICAL RIGHT SHIFT (ctrl=1010) -----");
        ctrl = 4'b1010;
        
        a = 16'h8000; b = 16'd1;
        #10;
        $display("%0t\tLSR\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'hFF00; b = 16'd4;
        #10;
        $display("%0t\tLSR\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'hFF00; b = 16'd8;
        #10;
        $display("%0t\tLSR\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        a = 16'h1234; b = 16'd0;
        #10;
        $display("%0t\tLSR\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        #100;
        // ===== TEST ARITHMETIC LEFT SHIFT (1100) =====
        $display("\n----- ARITHMETIC LEFT SHIFT (ctrl=1100) -----");
        ctrl = 4'b1100;
        
        // Positive number, no overflow
        a = 16'h0001; b = 16'd1;
        #10;
        $display("%0t\tASL\t%h\t%d\t\t%h\t%b\t%b (no ovf)", $time, a, b, s, zero, overflow);
        
        // Positive to negative (overflow)
        a = 16'h4000; b = 16'd1;
        #10;
        $display("%0t\tASL\t%h\t%d\t\t%h\t%b\t%b (expect ovf)", $time, a, b, s, zero, overflow);
        
        // Shift by 4
        a = 16'h0100; b = 16'd4;
        #10;
        $display("%0t\tASL\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        #100;
        // ===== TEST ARITHMETIC RIGHT SHIFT (1110) =====
        $display("\n----- ARITHMETIC RIGHT SHIFT (ctrl=1110) -----");
        ctrl = 4'b1110;

        // Positive number
        a = 16'h1000; b = 16'd1;
        #10;
        $display("%0t\tASR\t%h\t%d\t\t%h\t%b\t%b (pos)", $time, a, b, s, zero, overflow);
        
        // Negative number (sign extend)
        a = 16'hF000; b = 16'd1;
        #10;
        $display("%0t\tASR\t%h\t%d\t\t%h\t%b\t%b (neg, sign ext)", $time, a, b, s, zero, overflow);
        
        a = 16'hF000; b = 16'd4;
        #10;
        $display("%0t\tASR\t%h\t%d\t\t%h\t%b\t%b (neg, sign ext)", $time, a, b, s, zero, overflow);
        
        // Negative to positive (overflow)
        a = 16'h8000; b = 16'd1;
        #10;
        $display("%0t\tASR\t%h\t%d\t\t%h\t%b\t%b", $time, a, b, s, zero, overflow);
        
        $display("\n===== Test Complete =====");

        $finish;
    end
    
endmodule