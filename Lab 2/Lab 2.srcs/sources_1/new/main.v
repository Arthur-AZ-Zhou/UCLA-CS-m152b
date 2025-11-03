`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/27/2025 10:40:35 AM
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

module ClockDivider #(
    parameter CLOCK_FREQ = 100_000_000 // 100 MHz
)(
    input wire clk,
    input wire reset,
    output reg pulse_1hz
);
    // Counter to divide clock frequency
    localparam COUNT_MAX = CLOCK_FREQ - 1;
    reg [31:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            pulse_1hz <= 0;
        end else begin
            if (counter >= COUNT_MAX) begin
                counter <= 0;
                pulse_1hz <= 1;
            end else begin
                counter <= counter + 1;
                pulse_1hz <= 0;
            end
        end
    end
endmodule


module Timer #(
    parameter TIMEOUT_SECONDS = 12
)(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire pulse_1hz,
    output reg timeout
);
    // Count seconds using the 1Hz pulse (divided clock)
    localparam COUNT_MAX = TIMEOUT_SECONDS - 1;
    
    reg [31:0] counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            timeout <= 0;
        end else if (enable) begin
            if (pulse_1hz) begin
                if (counter >= COUNT_MAX) begin
                    counter <= 0;
                    timeout <= 1;
                end else begin
                    counter <= counter + 1;
                    timeout <= 0;
                end
            end else begin
                timeout <= 0;
            end
        end else begin
            counter <= 0;
            timeout <= 0;
        end
    end
endmodule

module TrafficController(
    input wire clk,
    input wire reset,
    input wire walk_button,
    input wire traffic_sensor,
    output reg [2:0] main_light, // Main light with 3 states
    output reg [2:0] side_light,
    output reg walk_light // two states
);
    /*
    States:
    1. MG1 (before traffic sensor)
    2. MG2 (no traffic)
    3. MG3 (traffic)
    4. MY
    5. WALK
    6. SG1
    7. SY (no traffic)
    8. SG2 (traffic)

    8 states -> 3 bit encoding
    */
    localparam [2:0] MG1 = 3'd0,
                     MG2 = 3'd1,
                     MG3 = 3'd2,
                     MY = 3'd3,
                     WALK = 4'd4,
                     SG1 = 4'd5,
                     SG2 = 4'd6,
                     SY = 4'd7;

    // Light (3 states -> 2 bits)
    localparam GRN = 3'b001,
               YEL = 3'b010,
               RED = 3'b100;

    reg [2:0] state, next_state;
    reg walk_req;

    reg [3:0] timer; // maximum count < 16 seconds (timer counts in seconds!)
    wire one_sec_pulse;
    
    // Clock divider instance
    ClockDivider #(.CLOCK_FREQ(100_000_000)) clk_div (
        .clk(clk),
        .reset(reset),
        .pulse_1hz(pulse_1hz)
    );

    // State register (sequential logic)
    always @(posedge clk or posedge reset) begin
        // Walk button register
        if (walk_button) begin
            walk_req <= 1;
        end
        if (reset) begin
            state <= MG1; // reset leads to MSG
            timer <= 0;
            walk_req <= 0;
        end else if (pulse_1hz) begin
            state <= next_state;
            
            // Timer counts how long we've stayed in the current state
            if (state != next_state) begin
                timer <= 0;
            end else begin
                timer <= timer + 1;
            end

            
            // Clear walk_req after walk cycle (-> back to SG1)
            if (state == WALK && next_state == SG1) begin
                walk_req <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        // If we don't hit any of the below: stay in current state
        next_state = state;
        
        case (state)
            MG1: begin
                if (timer >= 5) begin  // After 6 seconds (0-5)
                    next_state = traffic_sensor ? MG3 : MG2;
                end
            end
            
            MG2: begin
                if (timer >= 5) begin  // After 6 more seconds
                    next_state = MY;
                end
            end
            
            MG3: begin
                if (timer >= 2) begin  // After 3 seconds (0-2)
                    next_state = MY;
                end
            end
            
            MY: begin
                if (timer >= 1) begin  // After 2 seconds (0-1)
                    next_state = walk_req ? WALK : SG1;
                end
            end
            WALK: begin
                if (timer >= 2) begin  // After 3 seconds (0-2)
                    next_state = SG1;
                end
            end
            
            SG1: begin
                if (timer >= 5) begin  // After 6 seconds (0-5)
                    next_state = traffic_sensor ? SG2 : SY;
                end
            end
            
            SG2: begin
                if (timer >= 2) begin  // After 3 seconds (0-2)
                    next_state = SY;
                end
            end
            
            SY: begin
                if (timer >= 1) begin  // After 2 seconds (0-1)
                    next_state = MG1;
                end
            end
            
            default: next_state = MG1;
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values
        main_light = RED;
        side_light = RED;
        walk_light = 0;
        
        case (state)
            MG1, MG2, MG3: begin
                main_light = GRN;
                side_light = RED;
                walk_light = 0;
            end
            
            MY: begin
                main_light = YEL;
                side_light = RED;
                walk_light = 0;
            end
            WALK: begin
                main_light = RED;
                side_light = RED;
                walk_light = 1;
            end
            
            SG1, SG2: begin
                main_light = RED;
                side_light = GRN;
                walk_light = 0;
            end
            
            SY: begin
                main_light = RED;
                side_light = YEL;
                walk_light = 0;
            end
            
            default: begin
                main_light = RED;
                side_light = RED;
                walk_light = 0;
            end
        endcase
    end

endmodule
