`timescale 1ns / 1ps

module ComputeEngine(
    input wire clk,
    input wire reset,
    input wire start,
    output reg done,
    output reg [3:0] predicted_digit,

    // Interface to Image RAM
    output reg [9:0] img_addr,
    input wire [7:0] img_data,

    // Interface to Hidden RAM
    output reg [6:0] hid_addr,
    output reg hid_we,
    output reg [31:0] hid_wdata,
    input wire [31:0] hid_rdata
);

    // FSM States
    localparam S_IDLE = 0;
    localparam S_L1_LOAD_PARAM = 1;
    localparam S_L1_COMPUTE = 2;
    localparam S_L1_DRAIN = 3;
    localparam S_L2_LOAD_PARAM = 4;
    localparam S_L2_WAIT = 8;       // Wait for Block RAM Latency
    localparam S_L2_COMPUTE = 5;
    localparam S_L2_RESOLVE = 6;
    localparam S_DONE = 7;

    reg [3:0] state = S_IDLE;
    reg [9:0] pixel_iter;
    reg [6:0] neuron_iter;
    reg [3:0] output_iter;
    reg batch_sel;

    // Weight ROM interfaces
    reg [10:0] w1_addr;
    wire [511:0] w1_data_wide;
    reg [6:0] w2_addr;
    wire [79:0] w2_data_wide;

    reg shift_addr;
    wire [7:0] shift_val;
    reg [7:0] current_shift;

    // Instantiate Weight ROMs
    WeightRamWideL1 rom_w1 (.clk(clk), .addr(w1_addr), .data(w1_data_wide));
    WeightRamWideL2 rom_w2 (.clk(clk), .addr(w2_addr), .data(w2_data_wide));
    ShiftRam rom_s (.clk(clk), .addr(shift_addr), .data(shift_val));

    // Compute Unit signals
    reg cu_reset;
    reg cu_enable;
    reg signed [8:0] dsp_pixel_in;
    reg signed [7:0] dsp_weight_in [0:63];
    wire signed [31:0] dsp_acc_out [0:63];

    // Generate 64 Compute Units (DSP48E1 MAC units)
    genvar i;
    generate
        for (i=0; i<64; i=i+1) begin : gen_dsp
            ComputeUnit u_dsp (
                .clk(clk), 
                .reset(cu_reset), 
                .enable(cu_enable),
                .pixel(dsp_pixel_in), 
                .weight(dsp_weight_in[i]), 
                .accumulator(dsp_acc_out[i])
            );
        end
    endgenerate

    // Combinational logic to distribute weights to compute units
    integer k;
    always @(*) begin
        for (k=0; k<64; k=k+1) dsp_weight_in[k] = 0;
        
        if (state == S_L1_COMPUTE) begin
            for (k=0; k<64; k=k+1) dsp_weight_in[k] = w1_data_wide[k*8 +: 8];
        end
        else if (state == S_L2_COMPUTE) begin
            for (k=0; k<10; k=k+1) dsp_weight_in[k] = w2_data_wide[k*8 +: 8];
        end
    end

    // Helper variables
    reg signed [31:0] max_logit;
    reg [3:0] max_index;
    reg signed [31:0] tmp_raw_acc;
    reg signed [31:0] tmp_shifted;
    reg [7:0] tmp_clipped;
    reg signed [31:0] tmp_final_val;

    // Main FSM
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done <= 0;
            img_addr <= 0;
            hid_addr <= 0;
            hid_we <= 0;
            cu_reset <= 1;
            cu_enable <= 1; 
            batch_sel <= 0;
            predicted_digit <= 0;
            shift_addr <= 0;
            dsp_pixel_in <= 0;
            w1_addr <= 0;
            w2_addr <= 0;
            
        end else begin
            hid_we <= 0;

            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (start) begin
                        batch_sel <= 0;
                        cu_reset <= 1; 
                        cu_enable <= 1; 
                        state <= S_L1_LOAD_PARAM;
                    end
                end

                S_L1_LOAD_PARAM: begin
                    current_shift <= shift_val;
                    pixel_iter <= 0;
                    cu_reset <= 1;
                    cu_enable <= 1; 
                    img_addr <= 0;
                    w1_addr <= (batch_sel == 0) ? 0 : 784;
                    dsp_pixel_in <= 0;
                    state <= S_L1_COMPUTE;
                end

                S_L1_COMPUTE: begin
                    cu_reset <= 0;
                    
                    if (pixel_iter < 784) begin
                        cu_enable <= 1;
                        dsp_pixel_in <= {1'b0, img_data}; 
                        
                        // Prefetch Image Data (Keep +1)
                        if (pixel_iter < 783) begin
                            img_addr <= pixel_iter + 1;
                        end

                        // FIX: DELAY WEIGHT ADDRESS UPDATE
                        // Use 'pixel_iter' instead of 'pixel_iter + 1' to sync with delayed pixel data
                        if (batch_sel == 0) 
                            w1_addr <= pixel_iter; 
                        else 
                            w1_addr <= 784 + pixel_iter;

                        pixel_iter <= pixel_iter + 1;
                    end
                    else begin
                        cu_enable <= 0;
                    end

                    if (pixel_iter == 784) begin
                        state <= S_L1_DRAIN;
                        neuron_iter <= 0;
                    end
                end

                S_L1_DRAIN: begin
                    cu_enable <= 0;
                    if (neuron_iter < 64) begin
                        tmp_raw_acc = dsp_acc_out[neuron_iter];
                        if (tmp_raw_acc < 0) tmp_raw_acc = 0; // ReLU
                        tmp_shifted = tmp_raw_acc >>> current_shift; // Quantization
                        
                        if (tmp_shifted > 255) tmp_clipped = 255; // Clipping
                        else tmp_clipped = tmp_shifted[7:0];

                        hid_we <= 1;
                        hid_addr <= (batch_sel == 0) ? neuron_iter : (64 + neuron_iter);
                        hid_wdata <= {24'b0, tmp_clipped};

                        neuron_iter <= neuron_iter + 1;
                    end else begin
                        hid_we <= 0;
                        if (batch_sel == 0) begin
                            batch_sel <= 1;
                            cu_reset <= 1; 
                            cu_enable <= 1;
                            state <= S_L1_LOAD_PARAM;
                        end else begin
                            shift_addr <= 1; 
                            cu_reset <= 1; 
                            cu_enable <= 1;
                            state <= S_L2_LOAD_PARAM;
                        end
                    end
                end

                S_L2_LOAD_PARAM: begin
                    current_shift <= shift_val;
                    pixel_iter <= 0;
                    cu_reset <= 1; 
                    cu_enable <= 1; 
                    hid_addr <= 0;
                    w2_addr <= 0;
                    dsp_pixel_in <= 0;
                    state <= S_L2_WAIT;
                end

                S_L2_WAIT: begin
                   cu_reset <= 1; 
                   state <= S_L2_COMPUTE;
                end

                S_L2_COMPUTE: begin
                    cu_reset <= 0;
                    
                    if (pixel_iter < 128) begin
                        cu_enable <= 1;
                        dsp_pixel_in <= {1'b0, hid_rdata[7:0]};

                        // Prefetch Hidden Data (Keep +1)
                        if (pixel_iter < 127) begin
                            hid_addr <= pixel_iter + 1;
                        end
                        
                        // FIX: DELAY WEIGHT ADDRESS UPDATE
                        // Use 'pixel_iter' instead of 'pixel_iter + 1' to sync with delayed pixel data
                        if (pixel_iter < 128) begin
                            w2_addr <= pixel_iter;
                        end

                        pixel_iter <= pixel_iter + 1;
                    end
                    else begin
                        cu_enable <= 0;
                    end

                    if (pixel_iter == 128) begin
                        state <= S_L2_RESOLVE;
                        output_iter <= 0;
                        max_logit <= -2147483648; 
                        max_index <= 0;
                    end
                end

                S_L2_RESOLVE: begin
                    cu_enable <= 0;
                    if (output_iter < 10) begin
                        tmp_raw_acc = dsp_acc_out[output_iter];
                        tmp_final_val = tmp_raw_acc >>> current_shift;

                        if (tmp_final_val > max_logit) begin
                            max_logit <= tmp_final_val;
                            max_index <= output_iter;
                        end
                        output_iter <= output_iter + 1;
                    end else begin
                        predicted_digit <= max_index;
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done <= 1;
                    shift_addr <= 0; 
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule