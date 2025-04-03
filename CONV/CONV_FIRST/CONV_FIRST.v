module CONV_FIRST
#(
    // Assumption: Number of input channels = 3
    parameter                               INPUT_CHANNELS  = 3                         ,

    // Assumption: Number of output channels = 56
    parameter                               OUTPUT_CHANNELS = 56                        ,

    // Assumption: Default size of input image = 170x170
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

    input signed    [width_bias-1:0]        bias_in                                     ,
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
    // count the 0-based position(row, col) of current data
    // and the 0-based index of current feature channel
    //
    // if the positon has reached at its limit,
    // request the weights and bias of the next output channel
    // don't request the pixel data until this
    //
    // -------------------------------------------------------------------------------

    localparam                              width_row       = $clog2(VSIZE)             ;
    localparam                              width_col       = $clog2(HSIZE)             ;
    localparam                              width_channel   = $clog2(OUTPUT_CHANNELS)   ;

    reg             [width_row-1:0]         row                                         ;
    reg             [width_col-1:0]         col                                         ;
    reg             [width_channel-1:0]     current_output_channel                      ;

    wire                                    MAX_ROW, MAX_COL, MAX_OUT_CHANNEL           ;

    always @(posedge clk) begin
        if (!rst_n) begin
            row                     <=  {width_row{1'b0}}                   ;
            col                     <=  {width_col{1'b0}}                   ;
            current_output_channel  <=  {width_channel{1'b0}}               ;
        end
        else if (data_in_valid & MAX_COL & MAX_ROW & MAX_OUT_CHANNEL) begin
            row                     <=  {width_row{1'b0}}                   ;
            col                     <=  {width_col{1'b0}}                   ;
            current_output_channel  <=  {width_channel{1'b0}}               ;
        end
        else if (data_in_valid & MAX_COL & MAX_ROW) begin
            row                     <=  {width_row{1'b0}}                   ;
            col                     <=  {width_col{1'b0}}                   ;
            current_output_channel  <=  current_output_channel + 1'b1       ;
        end
        else if (data_in_valid & MAX_COL) begin
            row                     <=  row + 1'b1                          ;
            col                     <=  {width_col{1'b0}}                   ;
        end
        else if (data_in_valid) begin
            col                     <=  col + 1'b1                          ;
        end
    end

    assign MAX_ROW          = (row == VSIZE - 1)                                        ;
    assign MAX_COL          = (col == HSIZE - 1)                                        ;
    assign MAX_OUT_CHANNEL  = (current_output_channel == MAX_OUT_CHANNEL - 1)           ;

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