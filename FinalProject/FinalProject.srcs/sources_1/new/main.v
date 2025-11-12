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