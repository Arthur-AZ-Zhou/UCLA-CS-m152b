`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2025 11:42:26 AM
// Design Name: 
// Module Name: test_bench
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

module test_bench;
    reg clk;
    reg reset;
    reg enable;
    wire [3:0] out;
    my_counter dut (
        .clock(clk),
        .reset(reset),
        .enable(enable),
        .counter_output(out)
    );
    integer i = 0;
    initial begin
        // Reset to set initial vlaue
        reset = 1;
        clk = 0;
        enable = 0;
        #10;
        clk = 1;
        #10;
        reset = 0;
        
        // Check overflow
        enable = 1;
        for (i=0; i<20; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
        
        reset = 1;
        clk = 0;
        #10
        clk = 1;
        #10
        reset = 0;
        
        #100
        
        // Check enable
        enable = 1;
        for (i=0; i<10; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
        enable = 0;
        // At this point, we should expect the counter to no longer increment.
        for (i=0; i<10; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
        
        reset = 1;
        clk = 0;
        enable = 1;
        #10
        clk = 1;
        reset = 0;
        #10
        
        #100
        
        // Check reset
        for (i=0; i<10; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
        reset = 1;
        for (i=0; i<10; i=i+1) begin
            clk = 0;
            #10;
            clk = 1;
            #10;
        end
        $finish;
    end
    
    
endmodule
