module CONV_FIRST
#(
    // Assumption: Maximum size of the image = 256x256
    parameter                               HSIZE           = 170                       ,
    parameter                               VSIZE           = 170                       ,

    // Assumption: Default fixed point format = signed Q1.15
    parameter                               Q_INT           = 1                         ,
    parameter                               Q_FRAC          = 15                        ,
)
(
    input                                   clk                                         ,
    input                                   rst_n                                       ,

    input signed    [width_data-1:0]        data_in                                     ,
    input                                   data_in_enable                              ,

    input signed    [width_weight-1:0]      weight_in                                   ,
    input                                   weight_in_enable                            ,

    input signed    [width_weight-1:0]      bias_in                                     ,
    input                                   bias_in_enable                              ,

    output signed   [width_data-1:0]        data_out                                    ,
    output reg                              data_out_enable
);

    localparam                              width_data      = Q_INT + Q_FRAC            ;
    localparam                              width_weight    = Q_INT + Q_FRAC            ;
    localparam                              width_bias      = Q_INT + Q_FRAC            ;

    reg signed      [width_data-1:0]        internal_data   [0:74]  ;
    reg signed      [width_weight-1:0]      internal_weight [0:74]  ;
    reg signed      [width_bias-1:0]        internal_bias           ;

    // -------------------------------------------------------------------------------
    //
    // count the position(row, col) of current data
    // maximal size of the image is assumed to be 256x256
    //
    // if the positon has reached (max_row, max_col),
    // request the weights and bias of the next output channel
    // don't request the pixel data until this
    //
    // -------------------------------------------------------------------------------

    reg             [7:0]                   row, col                ;

    // -------------------------------------------------------------------------------
    // count finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // store input start
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            internal_data                   <= 'd0;
            internal_weight                 <= 'd0;
            internal_bias                   <= 'd0;
        end
        else if (data_in_enable) begin
            internal_data[count_data]       <= data_in;
        end
        else if (weight_in_enable) begin
            internal_weight[count_weight]   <= weight_in;
        end
        else if (bias_in_enable) begin
            internal_bias                   <= bias_in;
        end
    end

    // -------------------------------------------------------------------------------
    // store input finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // enable control start
    // -------------------------------------------------------------------------------

    /* TODO */

    // -------------------------------------------------------------------------------
    // enable control finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule