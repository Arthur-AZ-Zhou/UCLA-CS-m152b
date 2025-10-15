`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/15/2025 10:49:02 AM
// Design Name: 
// Module Name: registertestbench
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


module registertestbench;
    reg clk;
    reg rst;
    reg [4:0] Ra;
    reg [4:0] Rb;
    reg [4:0] Rw;
    reg WrEn;
    reg [15:0] busW;
    wire [15:0] busA;
    wire [15:0] busB;
    reg16 dut(
        .clk(clk),
        .rst(rst),
        .Ra(Ra),
        .Rb(Rb),
        .Rw(Rw),
        .WrEn(WrEn),
        .busW(busW),
        .busA(busA),
        .busB(busB)
    );
    
    initial begin;
        // Test 1: Write to a register and then read it
        rst = 0;
        clk = 0;
        WrEn = 1;
        busW = 16'h5A8B;
        Rw = 5'b00001;
        #10;
        clk = 1;
        #10;
        clk = 0;
        Ra = 5'b00001;
        #10; // busA here should be 5A8B
        clk = 1;
        
        // Reset
        rst = 1;
        clk = 0;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        #100; // clock break
        
        // Test 2: Write to two registers and read from them simultaneously
        WrEn = 1;
        busW = 16'h5A8B;
        Rw = 5'b00001;
        #10;
        clk = 1;
        #10;
        clk = 0;
        busW = 16'h000C;
        Rw = 5'b00010;
        clk = 1;
        #10;
        clk = 0;
        #10;
        Ra = 5'b00001;
        Rb = 5'b00010;
        clk = 1;
        #10; // busA here should be 5A8B, busB here should be 000C

        // Reset
        rst = 1;
        clk = 0;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        #100; // clock break
        
        $finish;
    end
    
endmodule
