`ifndef DEF_TASKS_CONV_LAST_H
`define DEF_TASKS_CONV_LAST_H

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

    // -------------------------------------------------------------------------------

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_conv_last_weight       [0:input_size-1]     ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_conv_last_bias         [0:0]                ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_conv_last_slope        [0:0]                ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_last_golden       [0:9*mem_size-1]     ;

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_last_output_0     [0:9*mem_size-1]     ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_last_output_1     [0:9*mem_size-1]     ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_last_output_2     [0:9*mem_size-1]     ;

    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    function is_upsampled
    (
        input integer row,
        input integer col
    );
        begin
            if (row % 3 == 0 || col % 3 == 0) begin
                is_upsampled = 1'b0;
            end
            else begin
                is_upsampled = 1'b1;
            end
        end
    endfunction

    // -------------------------------------------------------------------------------
    // function definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task automatic CONV_LAST_READ_WEIGHT
    (
        input integer output_channel_idx,
        input integer startpos,
        input integer endpos
    );
        reg [8*10-1:0]  _prefix;
        reg [8*6-1:0]   _weight;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix         = "conv_last_";
            _weight         = "weight";
            _underbar       = "_";
            _filetype       = ".txt";

            _idx_down   = output_channel_idx + 48;
            $readmemh({_prefix, _weight  , _underbar, _idx_down, _filetype}, mem_conv_last_weight, startpos, endpos);
        end
    endtask

    task automatic CONV_LAST_READ_BIAS_SLOPE_GOLDEN
    (
        input integer output_channel_idx
    );
        reg [8*10-1:0]  _prefix;
        reg [8*6-1:0]   _weight;
        reg [8*4-1:0]   _bias;
        reg [8*5-1:0]   _slope;
        reg [8*6-1:0]   _output;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix         = "conv_last_";
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            _idx_down   = output_channel_idx + 48;
            $readmemh({_prefix, _bias    , _underbar, _idx_down, _filetype}, mem_conv_last_bias   );
            $readmemh({_prefix, _slope   , _underbar, _idx_down, _filetype}, mem_conv_last_slope  );
            $readmemh({_prefix, _output  , _underbar, _idx_down, _filetype}, mem_conv_last_golden );
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_0
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_0[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_1
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_1[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_2
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_2[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_3
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_3[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_4
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_4[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_5
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_5[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_6
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_6[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_7
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_7[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_8
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_8[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_9
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_9[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_10
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_10[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_11
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_11[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_12
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_12[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_13
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_13[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_14
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_14[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_15
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_15[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_16
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_16[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_17
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_17[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_18
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_18[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_19
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_19[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_20
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_20[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_21
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_21[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_22
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_22[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_23
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_23[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_24
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_24[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_25
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_25[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_26
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_26[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_27
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_27[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_28
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_28[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_29
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_29[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_30
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_30[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_31
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_31[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_32
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_32[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_33
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_33[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_34
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_34[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_35
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_35[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_36
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_36[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_37
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_37[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_38
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_38[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_39
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_39[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_40
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_40[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_41
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_41[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_42
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_42[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_43
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_43[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_44
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_44[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_45
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_45[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_46
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_46[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_47
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_47[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_48
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_48[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_49
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_49[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_50
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_50[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_51
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_51[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_52
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_52[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_53
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_53[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_54
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_54[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL_55
    (
        input integer input_channel_idx,
        input integer row,
        input integer col
    );
        integer i;
        integer j;
        begin
            for (i = row - 4; i <= row + 4; i = i + 1) begin
                for (j = col - 4; j <= col + 4; j = j + 1) begin
                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(ii, jj)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        data_in[((i - row) * 5 + (j - col)) + 40] <= mem_conv_expand_output_55[i * HSIZE + j];
                    end
                end
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT;
        integer i;
        integer row;
        integer col;
        integer channel_idx;
        begin
            fork
                begin
                    for (row = 0; row < VSIZE; row = row + 1) begin
                        for (col = 0; col < HSIZE; col = col + 1) begin
                            for (channel_idx = 0; channel_idx < 56; channel_idx = channel_idx + 1) begin
                                CONV_LAST_DRIVE_INPUT_INTERNAL_0    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_1    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_2    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_3    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_4    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_5    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_6    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_7    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_8    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_9    (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_10   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_11   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_12   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_13   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_14   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_15   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_16   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_17   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_18   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_19   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_20   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_21   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_22   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_23   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_24   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_25   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_26   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_27   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_28   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_29   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_30   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_31   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_32   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_33   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_34   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_35   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_36   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_37   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_38   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_39   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_40   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_41   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_42   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_43   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_44   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_45   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_46   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_47   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_48   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_49   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_50   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_51   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_52   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_53   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_54   (channel_idx, row, col);
                                CONV_LAST_DRIVE_INPUT_INTERNAL_55   (channel_idx, row, col);
                            end
                        end
                    end
                end
                begin
                    layer_bits      <= 3'd7;
                    for (i = 81; i < 108; i = i + 1) begin
                        data_in[i]  <= 'b0;
                    end
                    @(posedge clk);
                end
            join
        end
    endtask

    task automatic CONV_LAST_DRIVE_WEIGHT_INTERNAL;
        integer i;
        integer j;
        begin
            for (i = 0; i < 81; i = i + 1) begin
                weight_in[i] <= mem_conv_last_weight[i];
            end
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_WEIGHT
    (
        input integer channel_idx
    );
        begin
            fork
                begin
                    for (start = 0; start < 81 * 56; start = start + 81) begin
                        CONV_LAST_READ_WEIGHT(channel_idx, start, start + 81);
                        CONV_LAST_DRIVE_WEIGHT_INTERNAL;
                    end
                end
                begin
                    for (j = 81; j < 108; j = j + 1) begin
                        weight_in[j] <= 'b0;
                    end
                end
            join
        end
    endtask

    task CONV_LAST_DRIVE_BIAS;
        begin
            bias_in <= mem_conv_last_bias[0];
            @(posedge clk);
        end
    endtask

    task CONV_LAST_DRIVE_SLOPE;
        begin
            slope_in <= mem_conv_last_slope[0];
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE;
        integer i;
        begin
            fork
                CONV_LAST_DRIVE_INPUT;
                begin
                    for (i = 0; i < 56; i = i + 1) begin
                        CONV_LAST_DRIVE_WEIGHT(i);
                    end
                end
                CONV_LAST_DRIVE_BIAS;
                CONV_LAST_DRIVE_SLOPE;
                begin
                    convolution_enable  <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

	reg signed [Q_INT_INPUT+Q_FRAC_INPUT-1:0] conv_last_output_temp;
    task automatic CONV_LAST_EVAL_ERROR
    (
        input [31:0]    output_channel_idx,
        input [31:0]	num_output,
        input real		display_error_threshold
    );
        integer i;
        real error;
        real mean_error;
        begin
            mean_error = 0;
            for (i = 0; i < num_output; i = i + 1) begin
                case (output_channel_idx)
                    'd0     : conv_last_output_temp =   mem_conv_last_output_0[i]   ;
                    'd1     : conv_last_output_temp =   mem_conv_last_output_1[i]   ;
                    'd2     : conv_last_output_temp =   mem_conv_last_output_2[i]   ;
                endcase
                if (mem_conv_last_golden[i]) begin
                	error = $signed(mem_conv_last_golden[i]) >= $signed(conv_last_output_temp) ?
                                                                    $signed(mem_conv_last_golden[i]) - $signed(conv_last_output_temp) :
                                                                    $signed(conv_last_output_temp) - $signed(mem_conv_last_golden[i]);
                	error = error / mem_conv_last_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                if (error < 0 || error > display_error_threshold) begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_conv_last_golden[i],
                    conv_last_output_temp,
                    $signed(mem_conv_last_golden[i]) - $signed(conv_last_output_temp),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Number of Output: %d, Mean Error: %f %%", num_output, mean_error);
        end
    endtask

	task TEST_CONV_LAST_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            RESET_CNT_OUTPUT;
            CONV_LAST_READ_BIAS_SLOPE_GOLDEN(channel);
            channel_idx <= channel;
            CONV_LAST_DRIVE;
            convolution_enable <= 1'b0;
            repeat (10) @(posedge clk);
            $display("[%m] Channel %0d finished!", channel);
            $display("[%m] Evaluating error in processing channel %0d...", channel);
            CONV_LAST_EVAL_ERROR(channel, cnt_output, 1.0);
            repeat (5) @(posedge clk);
        end
	endtask

    task automatic TEST_CONV_LAST_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            for (i = 0; i < 56; i = i + 1) begin
                TEST_CONV_LAST_SINGLE_IMAGE_SINGLE_CHANNEL(i);
            end
            repeat (20) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif