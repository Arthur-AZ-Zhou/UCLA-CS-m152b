module UartRx(
    input wire clk,       // System Clock (100MHz)
    input wire reset,     // Global Reset
    input wire rx,        // UART RX Line
    output reg [7:0] data,// Received Byte
    output reg valid      // Flag: High for 1 cycle when data is valid
);

    // 100MHz / 115200 baud = 868 clocks per bit
    // We oversample by 16x -> 868 / 16 = ~54 clocks per "tick"
    // Counter counts 0 to 53 (54 cycles)
    localparam OVERSAMPLE_TIMER_MAX = 53;
    
    // States
    localparam IDLE  = 0;
    localparam START = 1;
    localparam DATA  = 2;
    localparam STOP  = 3;
    
    reg [2:0] state = IDLE;
    reg [12:0] clock_counter = 0; // Counts to OVERSAMPLE_TIMER_MAX
    reg [3:0] bit_tick_counter = 0; // Counts 0-15 (16 ticks per bit)
    reg [2:0] bit_index = 0;        // Counts 0-7 (8 data bits)
    reg [7:0] shift_reg = 0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            valid <= 0;
            data <= 0;
        end else begin
            valid <= 0; // Default low

            // 1. Oversampling Timer
            if (clock_counter < OVERSAMPLE_TIMER_MAX) begin
                clock_counter <= clock_counter + 1;
            end else begin
                clock_counter <= 0;
                
                // This logic runs 16 times per bit duration (every "tick")
                case (state)
                    IDLE: begin
                        bit_tick_counter <= 0;
                        bit_index <= 0;
                        if (rx == 0) begin // Start bit detected (falling edge)
                            state <= START;
                        end
                    end

                    START: begin
                        // Wait for middle of start bit (7 ticks)
                        if (bit_tick_counter == 7) begin
                            if (rx == 0) begin // Confirm it's still low
                                bit_tick_counter <= 0;
                                state <= DATA;
                            end else begin
                                state <= IDLE; // False alarm (noise)
                            end
                        end else begin
                            bit_tick_counter <= bit_tick_counter + 1;
                        end
                    end
                    DATA: begin
                        // Wait for middle of data bit (15 ticks = 1 full bit width)
                        if (bit_tick_counter == 15) begin
                            bit_tick_counter <= 0;
                            shift_reg[bit_index] <= rx; // Sample the bit
                            
                            if (bit_index < 7) begin
                                bit_index <= bit_index + 1;
                            end else begin
                                state <= STOP;
                            end
                        end else begin
                            bit_tick_counter <= bit_tick_counter + 1;
                        end
                    end

                    STOP: begin
                         // Wait for middle of stop bit
                        if (bit_tick_counter == 15) begin
                            state <= IDLE;
                            valid <= 1;       // Signal data ready
                            data <= shift_reg;// Output the full byte
                        end else begin
                            bit_tick_counter <= bit_tick_counter + 1;
                        end
                    end
                endcase
            end
        end
    end
endmodule