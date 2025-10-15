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
    
    integer i = 0;
    initial begin;
        // Test 1: Write to a register and then read it
        rst = 1;
        clk = 0;
        WrEn = 1;
        busW = 16'h5A8B;
        Rw = 5'b00000;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        Ra = 5'b00000;
        #10; // busA here should be 5A8B
        clk = 1;

        #50; // clock break        
        // Reset
        rst = 1;
        clk = 0;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        #50; // clock break        
        
        // Test 2: Write to two registers and read from them simultaneously
        WrEn = 1;
        busW = 16'h158B;
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
        clk = 0;

        #50; // clock break        
        // Reset
        rst = 1;
        clk = 0;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        #50; // clock break        

        // Test 3: Check reset priority
        rst = 1;
        clk = 0;
        WrEn = 1;
        busW = 16'h2A8B;
        Rw = 5'b00000;
        Ra = 5'b00000;
        // Wait for a few cycles
        for (i=0; i<10; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
         
        #50; // clock break        
        // Reset
        rst = 1;
        clk = 0;
        #10;
        clk = 1;
        rst = 0;
        #10;
        clk = 0;
        #50; // clock break  
        
        // Test 4: Check register persistence
        
        // Write into registers 0, 1, 2, 3
        Ra = 5'b11111;
        Rb = 5'b11111;
        Rw = 5'b00000;
        busW = 16'h10A0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        Rw = 5'b00001;
        busW = 16'h10B0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        Rw = 5'b00010;
        busW = 16'h10C0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        Rw = 5'b00011;
        busW = 16'h10D0;
        #10;
        clk = 1;
        #10;
        clk = 0;
 
        WrEn = 0;
        #10;
        clk = 1;
        #10;
        clk = 0;
        
        // Read from registers 0, 1
        Ra = 5'b00000;
        Rb = 5'b00001;
        clk = 1;
        #50; // clock break 
        clk = 0;
        #10;
        
        // Read from registers 2, 3
        Ra = 5'b00010;
        Rb = 5'b00011;
        clk = 1;
        #50; 
        clk = 0;
        #10;
            
        // Now reset - check that in both cases
        // registers contain 0
        rst = 1;
        clk = 1;
        #50;
        
        clk = 0;
        Ra = 5'b00000;
        Rb = 5'b00001;
        #10;
        clk = 1;
        #50;
        
        $finish;
    end
    
endmodule
