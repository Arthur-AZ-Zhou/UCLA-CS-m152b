`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 10:33:46 AM
// Design Name: 
// Module Name: main
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

/*

+--------------------------------------------------------------------------+
| Top Level Module (on Basys 3)                                            |
|                                                                          |
|   +-----------------+        +------------------+        +-------------+ |
|   |                 |        |                  |        |             | |
|-->|  UART Receiver  |------->|  Input RAM       |------->|  ML Core    | |
|   |  (from PC)      |        |  (28x28 Image)   |        |  (CNN/NN)   | |
|   |                 |        |                  |        |             | |
|   +-----------------+        +------------------+        +------|------+ |
|          ^                            ^                         |        |
|          |                            |                         |        |
|   +------|----------------------------|-------------------------|------+ |
|   |      v                            v                         v      | |
|   |                          Control Unit (FSM)                        | |
|   |                                 |                                  | |
|   +---------------------------------|----------------------------------+ |
|                                     |                                    |
|                                     v                                    |
|                               +-----------+                              |
|                               |  Output   |---> (7-Segment Display, LEDs)|
|                               |  Logic    |                              |
|                               +-----------+                              |
|                                                                          |
+--------------------------------------------------------------------------+

*/

module main(

    );
endmodule

module ClockDivider #(
    parameter CLOCK_FREQ = 100_000_000
)(
    input wire clk,
    input wire reset,
    output reg pulse_1hz
);
    reg[31:0] counter;
    localparam COUNT_MAX = CLOCK_FREQ - 1;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pulse_1hz <= 0;
        end else begin
            if (counter >= COUNT_MAX) begin
                counter <= 0;
                pulse_1hz <= 1;
            end
            else begin
                counter <= counter + 1;
                pulse_1hz <= 0;
            end
        end
    end
endmodule

module SegmentDisplayDriver(
    input wire [3:0] num, // int4
    output wire [6:0] seg, // 7 segments
    output wire [3:0] an // digit anodes
);
    /*
    Display segments:
         a
        ---
     f | g | b
        ---
     e |   | c
        ---
         d
    */
    localparam LIGHT_ZERO = 7'b0000001;
    localparam LIGHT_ONE = 7'b1001111;
    localparam LIGHT_TWO = 7'b0010010;
    localparam LIGHT_THREE = 7'b0000110;
    localparam LIGHT_FOUR = 7'b1001100;
    localparam LIGHT_FIVE = 7'b0100100;
    localparam LIGHT_SIX = 7'b0100000;
    localparam LIGHT_SEVEN = 7'b0001111;
    localparam LIGHT_EIGHT = 7'b0000000;
    localparam LIGHT_NINE = 7'b0000100;

    assign an = 4'b1110;
    reg [6:0] seg_reg;
    assign seg = seg_reg;

    always @(*) begin
        case(num)
            4'd0: seg_reg = LIGHT_ZERO;
            4'd1: seg_reg = LIGHT_ONE;
            4'd2: seg_reg = LIGHT_TWO;
            4'd3: seg_reg = LIGHT_THREE;
            4'd4: seg_reg = LIGHT_FOUR;
            4'd5: seg_reg = LIGHT_FIVE;
            4'd6: seg_reg = LIGHT_SIX;
            4'd7: seg_reg = LIGHT_SEVEN;
            4'd8: seg_reg = LIGHT_EIGHT;
            4'd9: seg_reg = LIGHT_NINE;
            default: seg_reg = 7'b1111111;
        endcase
    end

endmodule