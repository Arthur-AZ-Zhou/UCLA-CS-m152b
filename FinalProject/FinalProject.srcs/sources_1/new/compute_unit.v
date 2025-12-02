//`timescale 1ns / 1ps

//module ComputeUnit(
//    input wire clk,
//    input wire reset,               // Active high reset (clears accumulator)
//    input wire enable,              // Active high enable (accumulate P = P + A*B)
//    input wire signed [8:0] pixel,  // 9-bit signed input (from Image RAM)
//    input wire signed [7:0] weight, // 8-bit signed input (from Weight ROM)
//    output wire signed [31:0] accumulator // Output bits [31:0] of the 48-bit accumulator
//);

//    // -------------------------------------------------------------------------
//    // DSP48E1 Configuration
//    // -------------------------------------------------------------------------

//    wire [47:0] p_out;
    
//    // Assign the lower 32 bits to our output
//    assign accumulator = p_out[31:0];

//    DSP48E1 #(
//        // Feature Control Attributes
//        .ALUMODEREG(0),                 
//        .AREG(0),                       // Direct connection (No pipeline reg on A)
//        .BREG(0),                       // Direct connection (No pipeline reg on B)
//        .CREG(0),                       
//        .CARRYINREG(0),                 
//        .CARRYINSELREG(0),              
//        .MREG(0),                       // Combinatorial Multiplier
//        .OPMODEREG(0),                  
//        .PREG(1),                       // Accumulator Register Enabled
        
//        // --- CASCADE REGISTERS MUST MATCH INPUT REGISTERS ---
//        .ACASCREG(0),                   // Must be 0 because AREG is 0
//        .BCASCREG(0),                   // Must be 0 because BREG is 0
//        // ---------------------------------------------------------

//        .USE_DPORT("FALSE"),            
//        .USE_MULT("MULTIPLY"),          
//        .USE_SIMD("ONE48"),             
        
//        .AUTORESET_PATDET("NO_RESET"), 
//        .MASK(48'h3fffffffffff), 
//        .PATTERN(48'h000000000000), 
//        .SEL_MASK("MASK"), 
//        .SEL_PATTERN("PATTERN"), 
//        .USE_PATTERN_DETECT("NO_PATDET")
//    ) 
//    dsp_macro (
//        // Clock and Reset
//        .CLK(clk),
//        .RSTA(1'b0), 
//        .RSTB(1'b0), 
//        .RSTC(1'b0), 
//        .RSTD(1'b0), 
//        .RSTM(1'b0), 
//        .RSTP(reset),           
//        .RSTCTRL(1'b0), 
//        .RSTALLCARRYIN(1'b0), 
//        .RSTALUMODE(1'b0), 
//        .RSTINMODE(1'b0), 

//        // Clock Enables
//        .CEA1(1'b0), .CEA2(1'b0), 
//        .CEB1(1'b0), .CEB2(1'b0), 
//        .CEC(1'b0), 
//        .CED(1'b0), 
//        .CEM(1'b1),             // FIX: Enable Multiplier Clock for simulation safety
//        .CEP(enable),           
//        .CEAD(1'b0), 
//        .CECTRL(1'b0), 
//        .CEALUMODE(1'b0), 
//        .CEINMODE(1'b0), 
//        .CECARRYIN(1'b0), 

//        // Data Inputs
//        // A: 30-bit input. We feed pixel (9-bit) into A[8:0]
//        .A({{21{pixel[8]}}, pixel}), 
        
//        // B: 18-bit input. We feed weight (8-bit) into B[7:0]
//        .B({{10{weight[7]}}, weight}), 
        
//        .C(48'd0),              
//        .D(25'd0),              
//        .BCIN(18'd0),           
//        .ACIN(30'd0),           
//        .PCIN(48'd0),           
        
//        // --- FIX 1: Explicitly drive CARRYIN signals ---
//        .CARRYIN(1'b0),         
//        .CARRYINSEL(3'b000),    // Fixes the "CARRYINSEL zzz" warning
//        .CARRYCASCIN(1'b0),     
//        .MULTSIGNIN(1'b0),      

//        // --- FIX 2: Correct OPMODE for Accumulation ---
//        // Z=010 (Select P/Accumulator)
//        // Y=01  (Select M Partial Product)
//        // X=01  (Select M Partial Product)
//        // Result: P_next = P + (M_partial_1 + M_partial_2) = P + M
//        .OPMODE(7'b0100101),    
        
//        .ALUMODE(4'b0000),      
//        .INMODE(5'b00000),      

//        // Outputs
//        .P(p_out),              
        
//        // Unused Outputs
//        .OVERFLOW(), .UNDERFLOW(), .PATTERNDETECT(), .PATTERNBDETECT(),
//        .CARRYCASCOUT(), .CARRYOUT(), .MULTSIGNOUT(), 
//        .ACOUT(), .BCOUT(), .PCOUT()
//    );

//endmodule

`timescale 1ns / 1ps

module ComputeUnit(
    input wire clk,
    input wire reset,               // Active high reset
    input wire enable,              // Active high enable
    input wire signed [8:0] pixel,  // 9-bit signed input
    input wire signed [7:0] weight, // 8-bit signed input
    output wire signed [31:0] accumulator // Output
);

    wire [47:0] p_out;
    assign accumulator = p_out[31:0];

    DSP48E1 #(
        // Standard Configuration
        .ALUMODEREG(0), .AREG(0), .BREG(0), .CREG(0), 
        .CARRYINREG(0), .CARRYINSELREG(0), .MREG(0), 
        .OPMODEREG(0), .PREG(1), 
        .ACASCREG(0), .BCASCREG(0),
        .USE_DPORT("FALSE"), .USE_MULT("MULTIPLY"), .USE_SIMD("ONE48"),
        .AUTORESET_PATDET("NO_RESET"), .MASK(48'h3fffffffffff), 
        .PATTERN(48'h000000000000), .SEL_MASK("MASK"), 
        .SEL_PATTERN("PATTERN"), .USE_PATTERN_DETECT("NO_PATDET")
    ) 
    dsp_macro (
        .CLK(clk),
        .RSTA(1'b0), .RSTB(1'b0), .RSTC(1'b0), .RSTD(1'b0), .RSTM(1'b0), 
        .RSTP(reset), // Reset connected to P register reset
        .RSTCTRL(1'b0), .RSTALLCARRYIN(1'b0), .RSTALUMODE(1'b0), .RSTINMODE(1'b0), 
        .CEA1(1'b0), .CEA2(1'b0), .CEB1(1'b0), .CEB2(1'b0), .CEC(1'b0), .CED(1'b0), 
        .CEM(1'b1), // Multiplier clock enable must be high
        .CEP(enable), // Accumulator clock enable
        .CEAD(1'b0), .CECTRL(1'b0), .CEALUMODE(1'b0), .CEINMODE(1'b0), .CECARRYIN(1'b0), 

        // Inputs
        .A({{21{pixel[8]}}, pixel}), 
        .B({{10{weight[7]}}, weight}), 
        
        // Unused inputs driven to 0
        .C(48'd0), .D(25'd0), .BCIN(18'd0), .ACIN(30'd0), .PCIN(48'd0), 
        .CARRYIN(1'b0), .CARRYINSEL(3'b000), .CARRYCASCIN(1'b0), .MULTSIGNIN(1'b0),      

        .OPMODE(7'b0100101),
         
        .ALUMODE(4'b0000),      
        .INMODE(5'b00000),      

        // Outputs
        .P(p_out),              
        .OVERFLOW(), .UNDERFLOW(), .PATTERNDETECT(), .PATTERNBDETECT(),
        .CARRYCASCOUT(), .CARRYOUT(), .MULTSIGNOUT(), .ACOUT(), .BCOUT(), .PCOUT()
    );

endmodule