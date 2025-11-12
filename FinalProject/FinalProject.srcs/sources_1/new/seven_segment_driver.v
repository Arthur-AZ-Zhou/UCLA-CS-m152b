module SegmentDisplayDriver(
    input wire [3:0] num, // int4
    output wire [6:0] seg, // 7 segments
    output wire [3:0] an // digit anodes
);
    /*
    Display segments:
         a
        ---
     f | g | b
        ---
     e |   | c
        ---
         d
    */
    localparam LIGHT_ZERO = 7'b0000001;
    localparam LIGHT_ONE = 7'b1001111;
    localparam LIGHT_TWO = 7'b0010010;
    localparam LIGHT_THREE = 7'b0000110;
    localparam LIGHT_FOUR = 7'b1001100;
    localparam LIGHT_FIVE = 7'b0100100;
    localparam LIGHT_SIX = 7'b0100000;
    localparam LIGHT_SEVEN = 7'b0001111;
    localparam LIGHT_EIGHT = 7'b0000000;
    localparam LIGHT_NINE = 7'b0000100;

    assign an = 4'b1110;
    reg [6:0] seg_reg;
    assign seg = seg_reg;

    always @(*) begin
        case(num)
            4'd0: seg_reg = LIGHT_ZERO;
            4'd1: seg_reg = LIGHT_ONE;
            4'd2: seg_reg = LIGHT_TWO;
            4'd3: seg_reg = LIGHT_THREE;
            4'd4: seg_reg = LIGHT_FOUR;
            4'd5: seg_reg = LIGHT_FIVE;
            4'd6: seg_reg = LIGHT_SIX;
            4'd7: seg_reg = LIGHT_SEVEN;
            4'd8: seg_reg = LIGHT_EIGHT;
            4'd9: seg_reg = LIGHT_NINE;
            default: seg_reg = 7'b1111111;
        endcase
    end

endmodule