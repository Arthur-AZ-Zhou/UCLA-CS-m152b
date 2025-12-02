`timescale 1ns / 1ps

module tb_ComputeUnit_Verification;

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

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        $display("-------------------------------------------------------------");
        $display("COMPUTE UNIT VERIFICATION START");
        $display("-------------------------------------------------------------");
        
        // 1. Initialize Signals
        reset = 1;
        enable = 0; 
        pixel = 0;
        weight = 0;
        
        // ------------------------------------------------------------------
        // CRITICAL: Force simulator to wait past the 100ns Device Boot-Up
        // ------------------------------------------------------------------
        #200; 
        
        @(posedge clk); 
        #1; 
        reset = 0; 
        $display("[%0t] Reset released (Must be > 100,000).", $time);

        // ------------------------------------------------------------------
        // TEST CASE: (10 * 10) + (2 * 5)
        // ------------------------------------------------------------------
        
        // --- Cycle 1: Drive First Input (10 * 10) ---
        @(posedge clk); 
        enable <= 1;
        pixel <= 9'd10;
        weight <= 8'd10;
        $display("[%0t] SETUP INPUT: 10 * 10", $time);

        // --- Cycle 2: Drive Second Input (2 * 5) ---
        @(posedge clk); 
        #1; // Wait for update
        $display("[%0t] CHECK ITER 1: Expected 100. Got: %d", $time, accumulator);
        
        // Setup inputs for NEXT edge
        pixel <= 9'd2;
        weight <= 8'd5;
        $display("[%0t] SETUP INPUT:  2 * 5", $time);

        // --- Cycle 3: Stop Computation ---
        @(posedge clk); 
        #1; // Wait for update
        $display("[%0t] CHECK ITER 2: Expected 110. Got: %d", $time, accumulator);

        enable <= 0;
        pixel <= 0;
        weight <= 0;

        $display("-------------------------------------------------------------");
        $display("DIAGNOSIS:");
        
        if (accumulator === 110) begin
            $display("PASS: Result is 110. The Compute Unit is WORKING.");
        end
        else if (accumulator === 220) begin
            $display("FAIL: Result is 220 (Double Counting).");
            $display("      Your OPMODE is set to P+M+M.");
        end
        else begin
            $display("FAIL: Result is %d (Unknown Error).", accumulator);
        end
        $display("-------------------------------------------------------------");

        #20;
        $finish;
    end

endmodule