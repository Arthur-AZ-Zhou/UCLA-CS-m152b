module ImageRam(
    input wire clk,
    
    // Port A: Write Only (Connected to UART)
    input wire we_a,              // Write Enable
    input wire [9:0] addr_a,      // Address (0-1023)
    input wire [7:0] data_in_a,   // Data to write
    
    // Port B: Read Only (Connected to Neural Net)
    input wire [9:0] addr_b,      // Address to read
    output reg [7:0] data_out_b   // Data read
);

    // 28*28 = 784 bytes. We round up to 1024 depth for nice power of 2
    reg [7:0] ram [0:1023]; 

    // Initial block for simulation/synthesis
    integer i;
    initial begin
        for (i=0; i<1024; i=i+1) ram[i] = 0;
    end

    // Synchronous Write (Port A)
    always @(posedge clk) begin
        if (we_a) begin
            ram[addr_a] <= data_in_a;
        end
    end

    // Synchronous Read (Port B)
    always @(posedge clk) begin
        data_out_b <= ram[addr_b];
    end

endmodule