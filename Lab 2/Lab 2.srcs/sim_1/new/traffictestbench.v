`timescale 1ns / 1ps

module traffictestbench();

    // Testbench signals
    reg clk;
    reg reset;
    reg walk_button;
    reg traffic_sensor;
    wire [2:0] main_light;
    wire [2:0] side_light;
    wire walk_light;
    
    // Light definitions
    localparam GRN = 3'b001;
    localparam YEL = 3'b010;
    localparam RED = 3'b100;
    
    // Instantiate the TrafficController module
    TrafficController uut (
        .clk(clk),
        .reset(reset),
        .walk_button(walk_button),
        .traffic_sensor(traffic_sensor),
        .main_light(main_light),
        .side_light(side_light),
        .walk_light(walk_light)
    );
    
    // ULTRA FAST clock divider: 2 cycles = 1 pulse (20ns per "second")
    defparam uut.clk_div.CLOCK_FREQ = 2;
    
    // Clock generation - 10ns period (100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Helper function to decode lights
    function [5*8:1] decode_light;
        input [2:0] light;
        begin
            case(light)
                GRN: decode_light = "GREEN";
                YEL: decode_light = "YELLO";
                RED: decode_light = "RED  ";
                default: decode_light = "UNDEF";
            endcase
        end
    endfunction
    
    // Helper function to decode state
    function [5*8:1] decode_state;
        input [2:0] state;
        begin
            case(state)
                3'd0: decode_state = "MG1  ";
                3'd1: decode_state = "MG2  ";
                3'd2: decode_state = "MG3  ";
                3'd3: decode_state = "MY   ";
                3'd4: decode_state = "WALK ";
                3'd5: decode_state = "SG1  ";
                3'd6: decode_state = "SG2  ";
                3'd7: decode_state = "SY   ";
                default: decode_state = "UNKNW";
            endcase
        end
    endfunction
    
    // Formatted display that updates every simulation second
    integer cycle_count;
    initial begin
        // Wait for reset to complete
        #50;
        
        cycle_count = 0;
        
        // Print header
        $display("\n================================================================================");
        $display("Traffic Light Controller Testbench - ALL THREE REQUIRED TESTS");
        $display("================================================================================");
        $display("Time(ns) | Cycle | State | Main  | Side  | Walk | Sensor | Button | Timer");
        $display("---------|-------|-------|-------|-------|------|--------|--------|------");
        
        // Display state on every 1Hz pulse
        forever begin
            @(posedge uut.pulse_1hz);
            $display("%8d | %5d | %s | %s | %s |  %b   |   %b    |   %b    | %4d",
                     $time, cycle_count, 
                     decode_state(uut.state),
                     decode_light(main_light),
                     decode_light(side_light),
                     walk_light, traffic_sensor, walk_button, uut.timer);
            cycle_count = cycle_count + 1;
            
            // Add separators between test cases
            if (cycle_count == 22) begin
                $display("---------|-------|-------|-------|-------|------|--------|--------|------");
                $display(">>> END TEST 1 - Starting TEST 2 (Walk Button) <<<");
                $display("---------|-------|-------|-------|-------|------|--------|--------|------");
            end
            if (cycle_count == 47) begin
                $display("---------|-------|-------|-------|-------|------|--------|--------|------");
                $display(">>> END TEST 2 - Starting TEST 3 (Traffic Sensor) <<<");
                $display("---------|-------|-------|-------|-------|------|--------|--------|------");
            end
        end
    end
    
    // Test stimulus - ALL THREE REQUIRED TESTS
    initial begin
        // Initialize signals
        reset = 0;
        walk_button = 0;
        traffic_sensor = 0;
        
        // ========== TEST 1: No sensors on ==========
        $display("\n=== TEST 1: Normal Cycle (No Sensors On) ===");
        $display("Expected: MG1(6s) -> MG2(6s) -> MY(2s) -> SG1(6s) -> SY(2s) -> MG1");
        reset = 1;
        #30;
        reset = 0;
        
        // Wait for one complete cycle (22 seconds = 440ns)
        #450;
        
        // ========== TEST 2: Walk sensor on ==========
        $display("\n=== TEST 2: Walk Button Pressed ===");
        $display("Expected: Should include WALK state (3s) between MY and SG1");
        reset = 1;
        #30;
        reset = 0;
        
        // Press walk button early in the cycle
        #60;
        walk_button = 1;
        #40;
        walk_button = 0;
        
        // Wait for cycle with WALK (6+6+2+3+6+2 = 25 seconds = 500ns)
        #460;
        
        // ========== TEST 3: Vehicle sensor on ==========
        $display("\n=== TEST 3: Traffic Sensor Active ===");
        $display("Expected: MG1(6s) -> MG3(3s) -> MY(2s) -> SG1(6s) -> SG2(3s) -> SY(2s)");
        reset = 1;
        #30;
        reset = 0;
        
        // Activate traffic sensor continuously
        traffic_sensor = 1;
        
        // Wait for cycle with sensor (6+3+2+6+3+2 = 22 seconds = 440ns)
        // Simulation will end at 1000ns naturally
    end
    
    // Safety checks
    always @(posedge clk) begin
        if (!reset) begin
            if (main_light == GRN && side_light == GRN) begin
                $display("\n*** ERROR at %0t: Both lights are GREEN! ***", $time);
            end
        end
    end

endmodule
