module mem_eq_check (
    input wire inval,
    input wire clk,
    output wire outval
    );

    reg prev;
    reg curr;

    always @(posedge clk) begin
        prev <= inval;
        curr <= prev;
    end

    assign outval = ~{curr ^ inval};
endmodule

module tb;
    reg clk;
    reg inval;
    wire outval;

    mem_eq_check uut(
        .inval(inval),
        .clk(clk),
        .outval(outval)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb);

        inval = 0;
        clk = 0;
        #10 clk = 1;
        #10 clk = 0;
        #10 inval = 1; clk = 1;
        #10 clk = 0;
        #10 clk = 1;
        #10 clk = 0;
        #10 inval = 0; clk = 1;
        #10 clk = 0;
        #10 clk = 1;
        #10 $finish;
    end
endmodule