module SegmentDisplayDriver(
    input wire [3:0] num, // int4
    output wire [6:0] seg, // 7 segments
    output wire [3:0] an // digit anodes
);
    /*
    Display segments mapping (XDC: seg[0]=A ... seg[6]=G)
         a (seg[0])
        ---
     f |   | b
        ---  <- g (seg[6])
     e |   | c
        ---
         d
    
    Active Low: 0 = ON, 1 = OFF
    Order in constant: G F E D C B A (MSB=seg[6], LSB=seg[0])
    */
    
    localparam LIGHT_ZERO  = 7'b1000000; // g=1(OFF), others=0(ON)
    localparam LIGHT_ONE   = 7'b1111001; // b,c=0(ON)
    localparam LIGHT_TWO   = 7'b0100100; // a,b,d,e,g=0
    localparam LIGHT_THREE = 7'b0110000; // a,b,c,d,g=0
    localparam LIGHT_FOUR  = 7'b0011001; // b,c,f,g=0
    localparam LIGHT_FIVE  = 7'b0010010; // a,c,d,f,g=0
    localparam LIGHT_SIX   = 7'b0000010; // a,c,d,e,f,g=0
    localparam LIGHT_SEVEN = 7'b1111000; // a,b,c=0
    localparam LIGHT_EIGHT = 7'b0000000; // all 0
    localparam LIGHT_NINE  = 7'b0010000; // a,b,c,d,f,g=0 OR 0011000 for simple 9

    assign an = 4'b1110; // Digit 0 ON
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
            default: seg_reg = 7'b1111111; // All OFF
        endcase
    end

endmodule