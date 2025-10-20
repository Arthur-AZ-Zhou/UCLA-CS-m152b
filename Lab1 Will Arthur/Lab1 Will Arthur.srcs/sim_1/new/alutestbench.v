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
        $display("Sub_out: %h", dut.sub_out);
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
       
        
        $finish;
    end
endmodule
