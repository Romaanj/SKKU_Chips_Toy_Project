module PReLU
#(
    // Assumption: Default fixed point format = signed Q1.15
    parameter                                                   Q_INT_data      = 1                 ,
    parameter                                                   Q_FRAC_data     = 15                ,
    parameter                                                   Q_INT_slope     = 1                 ,
    parameter                                                   Q_FRAC_slope    = 15                ,
    parameter                                                   Q_INT_result    = 1                 ,
    parameter                                                   Q_FRAC_result   = 15
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

    assign internal_data        = data                                                              ;
    assign internal_slope       = slope                                                             ;
    assign internal_result      = internal_data[0] ? internal_data * internal_slope : internal_data ;

    // signed Q(a+b).(c+d) -> signed Qe.f
    // a+b >= e
    // c+d >= f
    always @(posedge clk) begin
        if(!rst_n) begin
            result              <= 'b0                                                              ;
        end
        else if(PReLU_enable) begin
            result              <= internal_result >> (Q_FRAC_data + Q_FRAC_slope - Q_FRAC_result)  ;
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