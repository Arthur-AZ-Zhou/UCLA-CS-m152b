`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2025 10:57:52 AM
// Design Name: 
// Module Name: 7_segment_test
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


module segment_display_test();
    reg [3:0] num;
    wire [6:0] seg;
    wire [3:0] an;
    SegmentDisplayDriver dut (
        .num(num),
        .seg(seg),
        .an(an)
    )
    integer i;
    initial begin
        num = 0;
        for (i = 0; i<10; i = i + 1) begin
            #10
            num = num + 1;
        end
    end

endmodule
