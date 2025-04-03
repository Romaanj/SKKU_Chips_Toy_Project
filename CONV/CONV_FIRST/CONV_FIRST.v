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
            row                     <=  {width_row{1'b0}}                               ;
            col                     <=  {width_col{1'b0}}                               ;
            current_output_channel  <=  {width_channel{1'b0}}                           ;
        end
        else if (data_in_valid & MAX_COL & MAX_ROW & MAX_OUT_CHANNEL) begin
            row                     <=  {width_row{1'b0}}                               ;
            col                     <=  {width_col{1'b0}}                               ;
            current_output_channel  <=  {width_channel{1'b0}}                           ;
        end
        else if (data_in_valid & MAX_COL & MAX_ROW) begin
            row                     <=  {width_row{1'b0}}                               ;
            col                     <=  {width_col{1'b0}}                               ;
            current_output_channel  <=  current_output_channel + 1'b1                   ;
        end
        else if (data_in_valid & MAX_COL) begin
            row                     <=  row + 1'b1                                      ;
            col                     <=  {width_col{1'b0}}                               ;
        end
        else if (data_in_valid) begin
            col                     <=  col + 1'b1                                      ;
        end
    end

    assign MAX_ROW                  = (row == VSIZE - 1)                                ;
    assign MAX_COL                  = (col == HSIZE - 1)                                ;
    assign MAX_OUT_CHANNEL          = (current_output_channel == MAX_OUT_CHANNEL - 1)   ;

    // -------------------------------------------------------------------------------
    // count positon and index finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // enable control start
    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    // enable control finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // data to process is determined by zero-padding and kernel size of 5x5
    // -------------------------------------------------------------------------------

    reg signed      [width_data-1:0]        current_data_to_process   [0:74]            ;
    reg signed      [width_weight-1:0]      current_weight_to_process [0:74]            ;
    reg signed      [width_bias-1:0]        current_bias_to_process                     ;

    reg signed      [width_data-1:0]        next_data_to_process   [0:74]               ;
    reg signed      [width_weight-1:0]      next_weight_to_process [0:74]               ;
    reg signed      [width_bias-1:0]        next_bias_to_process                        ;

    genvar i;
    always @(posedge clk) begin
        if (!rst_n) begin
            for (i = 0; i < 75; i = i + 1) begin
                current_data_to_process[i]      <= 1'b0                                 ;
                current_weight_to_process[i]    <= 1'b0                                 ;
                current_bias_to_process[i]      <= 1'b0                                 ;
            end
        end
        else if (convolution_enable) begin
            for (i = 0; i < 75; i = i + 1) begin
                current_data_to_process[i]      <= next_data_to_process[i]              ;
                current_weight_to_process[i]    <= next_weight_to_process[i]            ;
                current_bias_to_process[i]      <= next_bias_to_process[i]              ;
            end
        end
    end

    always @(*) begin
        if (row == 2 && col == 2) begin
        end
        else if (row == 2 && col == 1) begin
        end
        else if (row == 2) begin
        end
        else begin
            for (i = 0; i < 75; i = i + 3) begin
                if (i == 12 || i == 27 || i == 42 || i == 57 || i == 72) begin
                    next_data_to_process[i]     = /* TODO */;
                    next_data_to_process[i+1]   = /* TODO */;
                    next_data_to_process[i+2]   = /* TODO */;
                end
                else begin
                    next_data_to_process[i]     = current_data_to_process[i+3];
                    next_data_to_process[i+1]   = current_data_to_process[i+4];
                    next_data_to_process[i+2]   = current_data_to_process[i+5];
                end
            end
        end
    end

    // -------------------------------------------------------------------------------
    // determine data to process finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule