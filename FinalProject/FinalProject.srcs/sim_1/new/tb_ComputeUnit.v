`timescale 1ns / 1ps

module tb_ComputeUnit;

    // Inputs
    reg clk;
    reg reset;
    reg enable;
    reg signed [8:0] pixel;
    reg signed [7:0] weight;

    // Outputs
    wire signed [31:0] accumulator;

    // Instantiate the Unit Under Test (UUT)
    ComputeUnit uut (
        .clk(clk), 
        .reset(reset), 
        .enable(enable), 
        .pixel(pixel), 
        .weight(weight), 
        .accumulator(accumulator)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        // Initialize Inputs
        // CRITICAL: Set enable=1 during reset so the DSP model resets P properly
        reset = 1;
        enable = 1; 
        pixel = 0;
        weight = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // ------------------------------------------------------------
        // Test Case 1: Single Multiply Check
        // Input: 10 * 10
        // Expected Result: 100
        // ------------------------------------------------------------
        @(posedge clk);
        reset = 0;
        enable = 1;
        pixel = 9'sd10;
        weight = 8'sd10;
        $display("[%0t] Inputting: 10 * 10", $time);

        @(posedge clk);
        // Step forward 1 unit to allow reg update, but NOT a full clock cycle
        #1; 
        
        $display("[%0t] Output: %d", $time, accumulator);
        
        if (accumulator === 100) begin
            $display("SUCCESS: 10 * 10 = 100.");
        end else begin
            $display("FAILURE: Expected 100, Got %d", accumulator);
        end

        // ------------------------------------------------------------
        // Test Case 2: Accumulation Check
        // Previous Accumulator: 100
        // New Input: 2 * 5 = 10
        // Expected New Accumulator: 100 + 10 = 110
        // ------------------------------------------------------------
        // FIX: Change inputs IMMEDIATELY. Do not wait for @(posedge clk) here,
        // or the DSP will accumulate 10*10 again!
        pixel = 9'sd2;
        weight = 8'sd5;
        $display("[%0t] Inputting: 2 * 5 (Accumulating)", $time);

        @(posedge clk); // Wait for next edge to capture new accumulation
        #1;
        $display("[%0t] Output: %d", $time, accumulator);
        
        if (accumulator === 110) begin
            $display("SUCCESS: Accumulation 100 + 10 = 110.");
        end else begin
            $display("FAILURE: Accumulation wrong. Expected 110, Got %d", accumulator);
        end

        $finish;
    end
      
endmodule