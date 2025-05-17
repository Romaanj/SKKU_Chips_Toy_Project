module SCALE_1
#(
    // Assumption: Default input fixed point format = signed Q19.15
    parameter                                                                       Q_INT_OPERAND       = 19    ,     
    parameter                                                                       Q_FRAC_OPERAND      = 15    ,

    // Assumption: Default scale (Conv2d) fixed point format = signed Q1.12
    parameter                                                                       Q_INT_SCALE         = 1     ,
    parameter                                                                       Q_FRAC_SCALE        = 12    ,

    // Assumption: Default output fixed point format = signed Q20.27
    parameter                                                                       Q_INT_OUTPUT        = 20    ,
    parameter                                                                       Q_FRAC_OUTPUT       = 27
)
(
    input                                                                           clk                         ,
    input                                                                           rst_n                       ,
    input  [2:0]                                                                    layer_bits                  ,

    input                                                                           scale_1_enable              ,
    input signed [Q_INT_OPERAND + Q_FRAC_OPERAND - 1:0]                             operand                     ,

    output reg                                                                      scale_1_result_enable		,
    output reg signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]                          result
);

    // --------------------------------------------------------
    // internal look-up table for scale
    // initial values are stored during reset
    reg signed [Q_INT_SCALE + Q_FRAC_SCALE - 1:0]                                   scale_table [0:7]   ;

    // layer bits:
    // 0 → conv_first.0 (Conv2d)
    // 0 → conv_first.1_alpha (PReLU)
    // 1 → conv_shrink.0 (Conv2d)
    // 1 → conv_shrink.1_alpha (PReLU)
    // 2 → conv_mapping.0 (Conv2d)
    // 3 → conv_mapping.1 (Conv2d)
    // 4 → conv_mapping.2 (Conv2d)
    // 5 → conv_mapping.3 (Conv2d)
    // 5 → conv_mapping.4 (PReLU)
    // 6 → conv_expanding.0 (Conv2d)
    // 6 → conv_expanding.1_alpha (PReLU)
    // 7 → conv_last (Conv2d)
    always @(posedge clk) begin
        if (!rst_n) begin
            scale_table[0]  <= 13'b0_0000_0001_0000; // 2^-8        = 0.00390625
            scale_table[1]  <= 13'b0_0000_0001_0000; // 2^-8        = 0.00390625
            scale_table[2]  <= 13'b0_0000_0000_0100; // 2^-10       = 0.000976625
            scale_table[3]  <= 13'b0_0000_0000_0100; // 2^-10       = 0.000976625
            scale_table[4]  <= 13'b0_0000_0000_1000; // 2^-9        = 0.001953125
            scale_table[5]  <= 13'b0_0000_0000_0100; // 2^-10       = 0.000976625
            scale_table[6]  <= 13'b0_0000_0001_0000; // 2^-8        = 0.00390625
            scale_table[7]  <= 13'b0_0000_0000_0001; // 2^-12       = 0.000244140625
        end
    end

    // --------------------------------------------------------
    // sign extension
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_operand    ;
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_scale      ;

    assign internal_operand = operand                   ;
    assign internal_scale   = scale_table[layer_bits]   ;

    // --------------------------------------------------------
    always @(posedge clk) begin
        if(!rst_n) begin
            scale_1_result_enable   <= 1'b0;
        end
        else if(scale_1_enable) begin
            scale_1_result_enable   <= 1'b1;
        end
        else if(scale_1_result_enable) begin
            scale_1_result_enable   <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            result                  <= 'b0;
        end
        else if (scale_1_enable) begin
            result                  <= internal_operand * internal_scale;
        end
    end

endmodule