`timescale 1ns / 1ps

module ComputeEngine(
    input wire clk,
    input wire reset,
    input wire start,
    output reg done,
    output reg [3:0] predicted_digit, // 0-9
    
    // Interface to Image RAM (Read Only)
    output reg [9:0] img_addr,
    input wire [7:0] img_data,
    
    // Interface to Hidden RAM (Read/Write)
    output reg [6:0] hidden_addr,
    output reg hidden_we,
    output reg [31:0] hidden_wdata,
    input wire [31:0] hidden_rdata
);

    // --- State Machine Definitions ---
    localparam S_IDLE        = 0;
    localparam S_L1_COMPUTE  = 1; // Computing a batch of 64 neurons
    localparam S_L1_SAVE     = 2; // Saving results to Hidden RAM
    localparam S_L2_COMPUTE  = 3; // Computing Final Layer
    localparam S_DONE        = 4;

    reg [3:0] state = S_IDLE;
    reg [1:0] batch_counter = 0; // 0 or 1 (for 2 passes of 64 neurons)
    reg [9:0] pixel_counter = 0; // 0 to 783

    // --- Memory Interfaces for Weights (Internal Instantiation) ---
    reg [10:0] w1_addr;
    wire [511:0] w1_data; // 64 bytes
    
    reg [6:0] w2_addr;
    wire [79:0] w2_data;  // 10 bytes
    
    // Instantiate ROMs
    WeightRamWideL1 rom_w1 (.clk(clk), .addr(w1_addr), .data(w1_data));
    WeightRamWideL2 rom_w2 (.clk(clk), .addr(w2_addr), .data(w2_data));

    // --- Compute Units (64 instances) ---
    reg cu_reset;
    reg cu_enable;
    reg signed [8:0] cu_pixel_in; // 9-bit signed for uint8 support
    wire signed [31:0] cu_acc [0:63]; // 64 outputs
    
    // We need to unpack the 512-bit wide weight bus into 64 bytes
    reg [7:0] w1_bytes [0:63];
    integer j;
    always @(*) begin
        for (j=0; j<64; j=j+1) begin
            w1_bytes[j] = w1_data[ (j*8) +: 8 ];
        end
    end

    // Muxing logic for weights: Layer 1 uses w1_data, Layer 2 uses w2_data
    // Note: Layer 2 only uses first 10 DSPs
    reg [7:0] cu_weight_in [0:63];
    always @(*) begin
        if (state == S_L2_COMPUTE) begin
            for (j=0; j<64; j=j+1) begin
                if (j < 10) cu_weight_in[j] = w2_data[ (j*8) +: 8 ];
                else cu_weight_in[j] = 0;
            end
        end else begin
            // Layer 1
            for (j=0; j<64; j=j+1) begin
                cu_weight_in[j] = w1_bytes[j];
            end
        end
    end

    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : dsp_gen
            ComputeUnit cu (
                .clk(clk),
                .reset(cu_reset),
                .enable(cu_enable),
                .pixel(cu_pixel_in),
                .weight(cu_weight_in[i]),
                .accumulator(cu_acc[i])
            );
        end
    endgenerate

    // --- Internal Registers for Pipeline ---
    reg [6:0] save_counter = 0; // Index for saving 64 results
    
    // Shift constants
    localparam SHIFT_L1 = 11;
    localparam SHIFT_L2 = 8;

    // --- Temporary Variables for Logic ---
    reg signed [31:0] temp_val;
    reg signed [31:0] max_val;
    reg [3:0] best_digit;
    reg signed [31:0] final_val;
    integer k;

    // --- Main State Machine ---
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done <= 0;
            cu_reset <= 1;
            cu_enable <= 0;
            img_addr <= 0;
            pixel_counter <= 0;
            batch_counter <= 0;
            save_counter <= 0;
            hidden_we <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (start) begin
                        state <= S_L1_COMPUTE;
                        batch_counter <= 0;
                        pixel_counter <= 0;
                        cu_reset <= 1; // Clear accumulators
                        cu_enable <= 0;
                        
                        // Setup addresses for first pixel
                        img_addr <= 0; 
                        w1_addr <= 0; // Batch 0, Pixel 0
                    end
                end

                S_L1_COMPUTE: begin
                    // Pipeline delay:
                    // Cycle 0: Addr ready
                    // Cycle 1: RAM data ready -> DSP enable
                    
                    cu_reset <= 0;
                    
                    // We run for 784 cycles (feed data) + 1 cycle (flush pipeline)
                    if (pixel_counter < 784) begin
                        // Feed Data - Zero Extend to 9 bits
                        cu_enable <= 1;
                        cu_pixel_in <= {1'b0, img_data};
                        
                        // Advance addresses for NEXT cycle
                        img_addr <= pixel_counter + 1;
                        
                        // w1_addr layout: 
                        if (batch_counter == 0) w1_addr <= pixel_counter + 1;
                        else w1_addr <= 784 + pixel_counter + 1;
                        
                        pixel_counter <= pixel_counter + 1;
                    end else if (pixel_counter == 784) begin
                        // FLUSH CYCLE: Allow the DSP to finish the last multiply-add
                        cu_enable <= 1;
                        cu_pixel_in <= 0; // Feed zero
                        pixel_counter <= pixel_counter + 1;
                    end else begin
                        // Done
                        cu_enable <= 0; // Stop accumulating
                        state <= S_L1_SAVE;
                        save_counter <= 0;
                    end
                end

                S_L1_SAVE: begin
                    if (save_counter < 64) begin
                        temp_val = cu_acc[save_counter]; 
                        
                        // ReLU
                        if (temp_val < 0) temp_val = 0;
                        
                        // Shift
                        temp_val = temp_val >>> SHIFT_L1;
                        
                        // Clamp to uint8 (0-255)
                        if (temp_val > 255) temp_val = 255;
                        
                        hidden_we <= 1;
                        hidden_addr <= (batch_counter * 64) + save_counter;
                        hidden_wdata <= temp_val;
                        
                        save_counter <= save_counter + 1;
                    end else begin
                        hidden_we <= 0;
                        // Batch done.
                        if (batch_counter == 0) begin
                            batch_counter <= 1;
                            state <= S_L1_COMPUTE;
                            pixel_counter <= 0;
                            cu_reset <= 1;
                            
                            img_addr <= 0;
                            w1_addr <= 784; // Start of batch 1
                        end else begin
                            // Layer 1 Done!
                            state <= S_L2_COMPUTE;
                            pixel_counter <= 0;
                            cu_reset <= 1;
                            
                            hidden_addr <= 0; // Start reading hidden RAM
                            w2_addr <= 0;
                        end
                    end
                end

                S_L2_COMPUTE: begin
                    // Input: Hidden RAM data (128 values)
                    // Weights: w2_data (10 values packed)
                    // DSPs: Only 0-9 are used.
                    
                    cu_reset <= 0;
                    
                    if (pixel_counter < 128) begin
                        cu_enable <= 1;
                        
                        // Input to all DSPs is the same hidden neuron activation
                        // Zero extend the uint8 hidden data
                        cu_pixel_in <= {1'b0, hidden_rdata[7:0]};
                        
                        // Advance for next
                        hidden_addr <= pixel_counter + 1;
                        w2_addr <= pixel_counter + 1;
                        pixel_counter <= pixel_counter + 1;
                    end else if (pixel_counter == 128) begin
                        // FLUSH CYCLE
                        cu_enable <= 1;
                        cu_pixel_in <= 0;
                        pixel_counter <= pixel_counter + 1;
                    end else begin
                        cu_enable <= 0;
                        // Finished 128 inputs.
                        state <= S_DONE; 
                    end
                end

                S_DONE: begin
                    // Find Max
                    max_val = -2147483648; // Min int
                    best_digit = 0;
                    
                    for (k=0; k<10; k=k+1) begin
                         // Shift L2
                         final_val = cu_acc[k] >>> SHIFT_L2;
                         
                         if (final_val > max_val) begin
                            max_val = final_val;
                            best_digit = k;
                         end
                    end
                    
                    predicted_digit <= best_digit;
                    done <= 1;
                    
                    // Stay here until reset
                end
            endcase
        end
    end

endmodule
