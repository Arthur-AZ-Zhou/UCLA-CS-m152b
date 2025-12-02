`timescale 1ns / 1ps

module tb_ComputeEngine;

    // ========================================================================
    // 1. Signals & Modules
    // ========================================================================
    reg clk;
    reg reset;
    reg start;
    wire done;
    wire [3:0] predicted_digit;

    // Interconnects between Engine and RAMs
    wire [9:0] ce_img_addr;
    wire [7:0] ce_img_data;
    
    wire [6:0] ce_hid_addr;
    wire ce_hid_we;
    wire [31:0] ce_hid_wdata;
    wire [31:0] ce_hid_rdata;

    // Testbench Variables for loading Image RAM
    reg tb_ram_we;
    reg [9:0] tb_ram_addr;
    reg [7:0] tb_ram_data;

    // ------------------------------------------------------------------------
    // Instantiate the Unit Under Test (UUT)
    // ------------------------------------------------------------------------
    ComputeEngine uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .done(done),
        .predicted_digit(predicted_digit),
        
        // Image RAM Interface
        .img_addr(ce_img_addr),
        .img_data(ce_img_data),
        
        // Hidden RAM Interface
        .hid_addr(ce_hid_addr),
        .hid_we(ce_hid_we),
        .hid_wdata(ce_hid_wdata),
        .hid_rdata(ce_hid_rdata)
    );

    // ------------------------------------------------------------------------
    // Instantiate Memories
    // ------------------------------------------------------------------------
    
    ImageRam img_ram (
        .clk(clk),
        .we_a(tb_ram_we),
        .addr_a(tb_ram_addr),
        .data_in_a(tb_ram_data),
        .addr_b(ce_img_addr),
        .data_out_b(ce_img_data)
    );

    HiddenRam hid_ram (
        .clk(clk),
        .we(ce_hid_we),
        .addr_wr(ce_hid_addr),
        .data_in(ce_hid_wdata),
        .addr_rd(ce_hid_addr),
        .data_out(ce_hid_rdata)
    );

    // ========================================================================
    // 2. Clock Generation
    // ========================================================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100 MHz
    end

    // ========================================================================
    // 3. Test Sequence
    // ========================================================================
    integer i;
    integer row, col;
    
    initial begin
        $display("---------------------------------------------------------------");
        $display("STARTING COMPUTE ENGINE TESTBENCH (VERBOSE DEBUG)");
        $display("---------------------------------------------------------------");

        // 1. Initialization
        reset = 1;
        start = 0;
        tb_ram_we = 0;
        tb_ram_addr = 0;
        tb_ram_data = 0;
        
        #100;

        // --------------------------------------------------------------------
        // LOAD MEMORIES
        // --------------------------------------------------------------------
        $display("[%0t] Loading Memory Files...", $time);
        
        $readmemh("shifts.mem", uut.rom_s.rom);
        $readmemh("weights_l1.mem", uut.rom_w1.rom);
        $readmemh("weights_l2.mem", uut.rom_w2.rom);

        // Sanity Check
        #10;
        if (uut.rom_w2.rom[0] === 80'bx) begin
             $display("CRITICAL: Weight Memory L2 is X! Loading failed.");
        end else begin
             $display("Memory Loaded. L2[0] sample: %h", uut.rom_w2.rom[0]);
        end

        reset = 0;
        #20;

        // --------------------------------------------------------------------
        // 2. Load "Digit 1" into RAM
        // --------------------------------------------------------------------
        $display("[%0t] Loading Image RAM with 'Wide 1' Pattern...", $time);
        
        for (i = 0; i < 784; i = i + 1) begin
            @(posedge clk);
            tb_ram_we = 1;
            tb_ram_addr = i;
            
            row = i / 28;
            col = i % 28;

            // Draw a vertical bar (Digit 1)
            // Center columns (13, 14, 15) and rows 5 to 22
            if ((col >= 13 && col <= 15) && (row >= 5 && row <= 22)) 
                tb_ram_data = 8'd255;
            else 
                tb_ram_data = 8'd0;
        end
        
        @(posedge clk);
        tb_ram_we = 0;
        $display("[%0t] Image Loaded.", $time);
        
        #100;

        // 3. Start Inference
        $display("[%0t] Asserting START...", $time);
        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        // 4. Wait for Done
        wait(done == 1);
        
        $display("---------------------------------------------------------------");
        $display("[%0t] INFERENCE COMPLETE!", $time);
        $display("Predicted Digit: %d", predicted_digit);
        $display("---------------------------------------------------------------");
        
        #100;
        $finish;
    end

    // ========================================================================
    // 4. Timeout Watchdog
    // ========================================================================
    initial begin
        #100000;
        $display("ERROR: Simulation timed out! 'done' signal never went high.");
        $finish;
    end

    // ========================================================================
    // 5. EXTENDED DEBUG MONITOR
    // ========================================================================
    // Track previous state to detect transitions
    reg [3:0] prev_state = 0;

    always @(posedge clk) begin
        #1; // Wait for logic updates to settle
        
        // -------------------------------------------------------
        // State Transition Logger
        // -------------------------------------------------------
        if (uut.state != prev_state) begin
            $display("[%0t] State Transition: %d -> %d", $time, prev_state, uut.state);
            prev_state <= uut.state;
        end

        // -------------------------------------------------------
        // Layer 2 Data Path Tracer
        // -------------------------------------------------------
        if (uut.state == 4 || uut.state == 5) begin // S_L2_LOAD_PARAM or S_L2_COMPUTE
            // Only print first 5 iterations to avoid spamming
            if (uut.pixel_iter < 5) begin
                $display("[%0t] State: %d | Iter: %d", $time, uut.state, uut.pixel_iter);
                $display("    -> L2 Addr (w2_addr): %d", uut.w2_addr);
                
                if (uut.w2_data_wide === 80'bx)
                    $display("    -> L2 ROM Data (w2_data_wide): XXXXXX (INVALID!)");
                else
                    $display("    -> L2 ROM Data (w2_data_wide): %h", uut.w2_data_wide);

                if (uut.dsp_weight_in[0] === 8'bx)
                    $display("    -> DSP Weight In [0]: XX (INVALID!)");
                else
                    $display("    -> DSP Weight In [0]: %h", uut.dsp_weight_in[0]);
                    
                $display("    -> DSP Pixel In: %h", uut.dsp_pixel_in);
                $display("------------------------------------------------");
            end
        end

        // -------------------------------------------------------
        // Score Monitor
        // -------------------------------------------------------
        if (uut.state == 6) begin // S_L2_RESOLVE
            if (uut.output_iter > 0 && uut.output_iter <= 10) begin
                $display("DEBUG: Digit %0d | Raw Acc: %d | Shifted: %d", 
                         uut.output_iter - 1, 
                         uut.tmp_raw_acc, 
                         uut.tmp_final_val);
            end
        end
    end
    
    // ========================================================================
    // 6. DEEP INSPECTION DEBUGGER
    // ========================================================================
    // This block monitors internal signals to trace the math step-by-step.
    
    always @(posedge clk) begin
        #1; // Wait for signals to settle after clock edge
        
        // --------------------------------------------------------------------
        // TRACE LAYER 1: ACCUMULATION (Neuron 0)
        // --------------------------------------------------------------------
        // Trace first 5 pixels AND pixels where we expect data (cols 13-15)
        if (uut.state == 2) begin // S_L1_COMPUTE
            // Print start, and around the area where we drew the '1'
            if (uut.pixel_iter < 5 || (uut.pixel_iter >= 153 && uut.pixel_iter <= 156)) begin
                $display("[L1 STEP %0d] PixelAddr: %d | PixelVal: %d | W1[0]: %d | Acc[0]: %d", 
                    uut.pixel_iter, 
                    uut.img_addr, 
                    $signed(uut.dsp_pixel_in), 
                    $signed(uut.dsp_weight_in[0]), 
                    $signed(uut.dsp_acc_out[0]) 
                );
            end
        end

        // --------------------------------------------------------------------
        // TRACE LAYER 1: OUTPUTS (Hidden RAM Writes)
        // --------------------------------------------------------------------
        if (uut.hid_we) begin
            $display("[L1 WRITE] Neuron %2d Saved Value: %d (Hex: %h)", 
                uut.hid_addr, 
                $signed(uut.hid_wdata), 
                uut.hid_wdata
            );
        end

        // --------------------------------------------------------------------
        // TRACE LAYER 2: INPUTS & ACCUMULATION
        // --------------------------------------------------------------------
        if (uut.state == 5) begin // S_L2_COMPUTE
            if (uut.pixel_iter < 5) begin
                $display("[L2 STEP %0d] HiddenVal: %d | W2[0]: %d | Acc[0]: %d || W2[2]: %d | Acc[2]: %d", 
                    uut.pixel_iter,
                    $signed(uut.dsp_pixel_in),      
                    $signed(uut.dsp_weight_in[0]),
                    $signed(uut.dsp_acc_out[0]),
                    $signed(uut.dsp_weight_in[2]),
                    $signed(uut.dsp_acc_out[2])
                );
            end
        end
    end

endmodule