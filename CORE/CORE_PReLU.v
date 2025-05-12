module PReLU
#(
    // Assumption: Default input fixed point format = signed Q20.29
    parameter                                                   Q_INT_data      = 20                ,
    parameter                                                   Q_FRAC_data     = 29                ,

    // Assumption: Default slope fixed point format = signed Q8.0
    parameter                                                   Q_INT_slope     = 8                 ,
    parameter                                                   Q_FRAC_slope    = 0                 ,

    // Assumption: Default result fixed point format = signed Q4.15
    parameter                                                   Q_INT_result    = 28                ,
    parameter                                                   Q_FRAC_result   = 29
)
(
    input                                                       clk                                 ,
    input                                                       rst_n                               ,

    input                                                       PReLU_enable                        ,

    input signed        [Q_INT_data + Q_FRAC_data -1:0]         data                                ,
    input signed        [Q_INT_slope + Q_FRAC_slope -1:0]       slope                               ,

    output reg signed   [Q_INT_result + Q_FRAC_result -1:0]     result                              ,
    output reg                                                  PReLU_result_enable
);

    // signed Qa.b * signed Qc.d = signed Q(a+b).(c+d)
    wire signed [Q_INT_data + Q_FRAC_data + Q_INT_slope + Q_FRAC_slope - 1:0] internal_data         ;
    wire signed [Q_INT_data + Q_FRAC_data + Q_INT_slope + Q_FRAC_slope - 1:0] internal_slope        ;
    wire signed [Q_INT_data + Q_FRAC_data + Q_INT_slope + Q_FRAC_slope - 1:0] internal_result       ;

    assign data_sign            = data[Q_INT_data + Q_FRAC_data -1]                                 ;
    assign internal_data        = data                                                              ;
    assign internal_slope       = slope                                                             ;

    // signed Q(a+b).(c+d) -> signed Qe.f
    // assume c,d >= f
    always @(posedge clk) begin
        if(!rst_n) begin
            result              <= 'b0                                                              ;
        end
        else if(PReLU_result_enable & data_sign) begin
            result              <= (internal_data * internal_slope)
                                    >> (Q_FRAC_data + Q_FRAC_slope - Q_FRAC_result)                 ;
        end
        else if (PReLU_result_enable) begin
            result              <= data >> (Q_FRAC_data - Q_FRAC_result);
        end
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            PReLU_result_enable <= 1'b0                                                             ;
        end
        else if(PReLU_enable) begin
            PReLU_result_enable <= 1'b1                                                             ;
        end
        else if(PReLU_result_enable) begin
            PReLU_result_enable <= 1'b0                                                             ;
        end
    end

endmodule