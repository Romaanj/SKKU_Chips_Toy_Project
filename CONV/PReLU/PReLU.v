// PReLU: Parametric Rectified Linear Unit
// Basically,
// PReLU(x) := x  (if x >= 0)
//             ax (otherwise)
// where a < 0 is given as 'neg_slope'
// Its name is due to learnable 'neg_slope', which is fixed in inference
// Thus, its behavior doesn't differ from 'leaky ReLU'

module PReLU
#(
    // Default fixed point format = signed Q1.15
    parameter                               Q_INT           = 1                         ,
    parameter                               Q_FRAC          = 15
)
(
    input                                   clk                                         ,
    input                                   rst_n                                       ,

    input                                   PReLU_enable                                ,
    input signed [width_data-1:0]           PReLU_input                                 ,
    input signed [width_slope-1:0]          PReLU_neg_slope                             ,

    output reg signed [width_output-1:0]    PReLU_result                                ,
    output reg                              PReLU_result_enable
);

    localparam                              width_data      = Q_INT + Q_FRAC            ;
    localparam                              width_slope     = Q_INT + Q_FRAC            ;
    localparam                              width_output    = Q_INT + Q_FRAC            ;

    wire signed [width_data+width_slope-1:0] PReLU_temp = PReLU_input * PReLU_neg_slope;

    // -------------------------------------------------------------------------------
    // enable control start
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            PReLU_result_enable <= 1'b0;
        end
        else if (PReLU_enable) begin
            PReLU_result_enable <= 1'b1;
        end
        else if (PReLU_result_enable) begin
            PReLU_result_enable <= 1'b0;
        end
    end

    // -------------------------------------------------------------------------------
    // enable control finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // output start
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            PReLU_result <= 1'b0;
        end
        else if (PReLU_enable) begin
            PReLU_result <= PReLU_temp >> (width_data + width_slope - width_output);
        end
    end

    // -------------------------------------------------------------------------------
    // output finish
    // -------------------------------------------------------------------------------

endmodule