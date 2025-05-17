module SCALE_2
#(
    // Assumption: Default input fixed point format = signed Q28.27
    parameter                                                                       Q_INT_OPERAND               = 28    ,
    parameter                                                                       Q_FRAC_OPERAND              = 27    ,

    // Assumption: Default scale (PReLU) fixed point format = signed Q1.9
    parameter                                                                       Q_INT_SCALE                 = 1     ,
    parameter                                                                       Q_FRAC_SCALE                = 9     ,

    // Assumption: Default output fixed point format = signed Q4.15
    parameter                                                                       Q_INT_OUTPUT                = 4     ,
    parameter                                                                       Q_FRAC_OUTPUT               = 15
)
(
    input                                                                           clk                                 ,
    input                                                                           rst_n                               ,
    input                                                                           scale_2_enable                      ,
    input                                                                           PReLU_operand_sign                  ,                                                                       

    input  [2:0]                                                                    layer_bits                          ,
    input signed [Q_INT_OPERAND + Q_FRAC_OPERAND - 1:0]                             operand                             ,

    output reg signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]                          result                              ,
    output reg                                                                      scale_2_result_enable
);

    // --------------------------------------------------------
    // internal look-up table for scale
    // initial values are stored during reset
    reg signed [Q_INT_SCALE + Q_FRAC_SCALE - 1:0]                                   scale_table [0:3]                   ;

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
            scale_table[0]  <= 10'b0_0000_0010_0; // 2^-7 = 0.0078125
            scale_table[1]  <= 10'b0_0000_0001_0; // 2^-8 = 0.00390625
            scale_table[2]  <= 10'b0_0000_0000_1; // 2^-9 = 0.001953125
            scale_table[3]  <= 10'b0_0000_0001_0; // 2^-8 = 0.00390625
        end
    end

    // --------------------------------------------------------
    // sign extension
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_operand                    ;
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_scale                      ;

    assign internal_operand = operand                                   ;
    assign internal_scale   = layer_bits == 3'd0    ?	scale_table[0]
                            : layer_bits == 3'd1    ?	scale_table[1]
                            : layer_bits == 3'd5    ?	scale_table[2]
                            : layer_bits == 3'd6    ?	scale_table[3]
                            :							'b0             ;

    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_result = internal_operand * internal_scale;

    // --------------------------------------------------------
    always @(posedge clk) begin
        if(!rst_n) begin
            scale_2_result_enable       <= 1'b0;
        end
        else if(scale_2_enable) begin
            scale_2_result_enable       <= 1'b1;
        end
        else if(scale_2_result_enable) begin
            scale_2_result_enable       <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            result                      <= 'b0;
        end
        else if (scale_2_enable & PReLU_operand_sign) begin
            result                      <= internal_operand * internal_scale >> (Q_FRAC_OPERAND + Q_FRAC_SCALE - Q_FRAC_OUTPUT);
        end
        else if (scale_2_enable) begin
            result                      <= internal_operand >> (Q_FRAC_OPERAND - Q_FRAC_OUTPUT);
        end
    end

endmodule