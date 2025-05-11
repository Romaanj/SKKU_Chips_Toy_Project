module SCALE_2 #(
    parameter Q_INT_OPERAND = 28,     
    parameter Q_FRAC_OPERAND = 29,
    parameter Q_INT_SCALE = 1,
    parameter Q_FRAC_SCALE = 14,
    parameter Q_INT_OUTPUT = 29,
    parameter Q_FRAC_OUTPUT = 43
)(
    input                    clk,
    input                    rst_n,
    input                    scale_2_enable,

    input  [3:0]             layer_bits,
    input signed [Q_INT_OPERAND + Q_FRAC_OPERAND - 1:0]  operand,

    output reg signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] result,
    output reg                                    scale_2_result_enable
);

    // === 내부 상수 테이블 선언 ===
    reg signed [Q_INT_SCALE + Q_FRAC_SCALE - 1:0] scale_table [0:11];

    // === 곱셈 입력 확장 ===
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_operand;
    wire signed [Q_INT_OPERAND + Q_FRAC_OPERAND + Q_INT_SCALE + Q_FRAC_SCALE - 1:0] internal_scale;

    assign internal_operand = operand;
    assign internal_scale   = scale_table[layer_bits];

    // === scale_table 초기화 (reset 시) ===

    always @(posedge clk) begin
        if (!rst_n) begin
            scale_table[0]  <= 15'b000000001010000; // 0.00490147 → conv_first.0 (Conv2d)
            scale_table[1]  <= 15'b000000011010101; // 0.01300729 → conv_first.1_alpha (PReLU)
            scale_table[2]  <= 15'b000000001010001; // 0.00494969 → conv_shrink.0 (Conv2d)
            scale_table[3]  <= 15'b000000001000100; // 0.00833962 → conv_shrink.1_alpha (PReLU)
            scale_table[4]  <= 15'b000000000011100; // 0.00340602 → conv_mapping.0 (Conv2d)
            scale_table[5]  <= 15'b000000000011100; // 0.00340601 → conv_mapping.1 (Conv2d)
            scale_table[6]  <= 15'b000000000100000; // 0.00391295 → conv_mapping.2 (Conv2d)
            scale_table[7]  <= 15'b000000000011001; // 0.00307888 → conv_mapping.3 (Conv2d)
            scale_table[8]  <= 15'b000000000111101; // 0.00747632 → conv_mapping.4 (PReLU)
            scale_table[9]  <= 15'b000000001001111; // 0.00970481 → conv_expanding.0 (Conv2d)
            scale_table[10] <= 15'b000000001000011; // 0.00816691 → conv_expanding.1_alpha (PReLU)
            scale_table[11] <= 15'b000000000000110; // 0.00076693 → conv_last (Conv2d)
        end
    end




    always @(posedge clk) begin
        if (!rst_n)
            result <= 'b0;
        else if (scale_2_enable)
            result <= internal_operand * internal_scale;
    end
    
     always @(posedge clk) begin
        if(!rst_n) begin
            scale_2_result_enable       <= 1'b0;
        end
        else if(scale_2_enable) begin
            scale_2_result_enable       <= 1'b1;
        end
        else if(scale_2_result_enable) begin
            scale_2_result_enable      <= 1'b0;
        end
    end

endmodule