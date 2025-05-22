`ifndef DEF_TASKS_CONV_MAP3_H
`define DEF_TASKS_CONV_MAP3_H

    // layer bits:
    // 0 ?? conv_first.0 (Conv2d)
    // 0 ?? conv_first.1_alpha (PReLU)
    // 1 ?? conv_shrink.0 (Conv2d)
    // 1 ?? conv_shrink.1_alpha (PReLU)
    // 2 ?? conv_mapping.0 (Conv2d)
    // 3 ?? conv_mapping.1 (Conv2d)
    // 4 ?? conv_mapping.2 (Conv2d)
    // 5 ?? conv_mapping.3 (Conv2d)
    // 5 ?? conv_mapping.4 (PReLU)
    // 6 ?? conv_expanding.0 (Conv2d)
    // 6 ?? conv_expanding.1_alpha (PReLU)
    // 7 ?? conv_last (Conv2d)

    // -------------------------------------------------------------------------------

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_conv_map3_weight      [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_conv_map3_bias        [0:0]               ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_conv_map4_slope       [0:0]               ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_map4_golden      [0:mem_size-1]      ;

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_0    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_1    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_2    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_3    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_4    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_5    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_6    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_7    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_8    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_9    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_10   [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_map4_output_11   [0:mem_size-1]      ;

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task automatic CONV_MAP3_READ_INPUT
    (
        input integer output_channel_idx
    );
        reg [8*15-1:0]  _prefix_1;
        reg [8*15-1:0]  _prefix_2;
        reg [8*6-1:0]   _weight;
        reg [8*4-1:0]   _bias;
        reg [8*5-1:0]   _slope;
        reg [8*6-1:0]   _output;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_up;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix_1       = "conv_mapping.3_";
            _prefix_2       = "conv_mapping.4_";
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            if (output_channel_idx > 9) begin
                _idx_up     = output_channel_idx / 10 + 48;
                _idx_down   = output_channel_idx % 10 + 48;
                $readmemh({_prefix_1, _weight  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_map3_weight );
                $readmemh({_prefix_1, _bias    , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_map3_bias   );
                $readmemh({_prefix_2, _slope   , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_map4_slope  );
                $readmemh({_prefix_2, _output  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_map4_golden );
            end
            else begin
                _idx_down   = output_channel_idx + 48;
                $readmemh({_prefix_1, _weight  , _underbar, _idx_down, _filetype}, mem_conv_map3_weight );
                $readmemh({_prefix_1, _bias    , _underbar, _idx_down, _filetype}, mem_conv_map3_bias   );
                $readmemh({_prefix_2, _slope   , _underbar, _idx_down, _filetype}, mem_conv_map4_slope  );
                $readmemh({_prefix_2, _output  , _underbar, _idx_down, _filetype}, mem_conv_map4_golden );
            end
        end
    endtask

    task automatic CONV_MAP3_DRIVE_INPUT_0_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 4] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 4] <= mem_conv_map2_output_0[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_1_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 13] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 13] <= mem_conv_map2_output_1[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_2_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 22] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 22] <= mem_conv_map2_output_2[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_3_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 31] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 31] <= mem_conv_map2_output_3[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_4_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 40] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 40] <= mem_conv_map2_output_4[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_5_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 49] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 49] <= mem_conv_map2_output_5[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_6_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 58] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 58] <= mem_conv_map2_output_6[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_7_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 67] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 67] <= mem_conv_map2_output_7[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_8_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 76] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 76] <= mem_conv_map2_output_8[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
    task automatic CONV_MAP3_DRIVE_INPUT_9_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 85] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 85] <= mem_conv_map2_output_9[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
        task automatic CONV_MAP3_DRIVE_INPUT_10_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 94] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 94] <= mem_conv_map2_output_10[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask
        task automatic CONV_MAP3_DRIVE_INPUT_11_INTERNAL;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 1; ii <= i + 1; ii = ii + 1) begin
                                for (jj = j - 1; jj <= j + 1; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 103] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 3 + (jj - j)) + 103] <= mem_conv_map2_output_11[ii * HSIZE + jj];
                                    end
                                end
                            end
                            @(posedge clk);
                        end
                    end
                end
            join
        end
    endtask

   
    task automatic CONV_MAP3_DRIVE_INPUT;
        integer i;
        begin
            fork
                CONV_MAP3_DRIVE_INPUT_0_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_1_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_2_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_3_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_4_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_5_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_6_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_7_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_8_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_9_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_10_INTERNAL;
                CONV_MAP3_DRIVE_INPUT_11_INTERNAL;
                begin
                  layer_bits      <= 3'd5;
                end
                @(posedge clk);
            join
        end
    endtask

    task automatic CONV_MAP3_DRIVE_WEIGHT;
        integer i;
        begin
            for (i = 0; i < 108; i = i + 1) begin
                weight_in[i] <= mem_conv_map3_weight[i];
            end
            @(posedge clk);
        end
    endtask

    task CONV_MAP3_DRIVE_BIAS;
        begin
            bias_in <= mem_conv_map3_bias[0];
            @(posedge clk);
        end
    endtask

    task CONV_MAP3_DRIVE_SLOPE;
        begin
            slope_in <= mem_conv_map4_slope[0];
            @(posedge clk);
        end
    endtask

    task CONV_MAP3_DRIVE;
        begin
            fork
                CONV_MAP3_DRIVE_INPUT;
                CONV_MAP3_DRIVE_WEIGHT;
                CONV_MAP3_DRIVE_BIAS;
                CONV_MAP3_DRIVE_SLOPE;
                begin
                    convolution_enable  <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

	reg signed [Q_INT_INPUT+Q_FRAC_INPUT-1:0] conv_map4_output_temp;
    task automatic CONV_MAP4_EVAL_ERROR
    (
        input [31:0]  output_channel_idx,
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
                    'd0     : conv_map4_output_temp = mem_conv_map4_output_0[i]     ;
                    'd1     : conv_map4_output_temp = mem_conv_map4_output_1[i]     ;
                    'd2     : conv_map4_output_temp = mem_conv_map4_output_2[i]     ;
                    'd3     : conv_map4_output_temp = mem_conv_map4_output_3[i]     ;
                    'd4     : conv_map4_output_temp = mem_conv_map4_output_4[i]     ;
                    'd5     : conv_map4_output_temp = mem_conv_map4_output_5[i]     ;
                    'd6     : conv_map4_output_temp = mem_conv_map4_output_6[i]     ;
                    'd7     : conv_map4_output_temp = mem_conv_map4_output_7[i]     ;
                    'd8     : conv_map4_output_temp = mem_conv_map4_output_8[i]     ;
                    'd9     : conv_map4_output_temp = mem_conv_map4_output_9[i]     ;
                    'd10    : conv_map4_output_temp = mem_conv_map4_output_10[i]    ;
                    'd11    : conv_map4_output_temp = mem_conv_map4_output_11[i]    ;
                endcase
                if (mem_conv_map4_golden[i]) begin
                	error = $signed(mem_conv_map4_golden[i]) >= $signed(conv_map4_output_temp) ?
                                                                    $signed(mem_conv_map4_golden[i]) - $signed(conv_map4_output_temp) :
                                                                    $signed(conv_map4_output_temp) - $signed(mem_conv_map4_golden[i]);
                	error = error / mem_conv_map4_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                 if (error < 0 || error > display_error_threshold) begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_conv_map4_golden[i],
                    conv_map4_output_temp,
                    $signed(mem_conv_map4_golden[i]) - $signed(conv_map4_output_temp),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Number of Output: %d, Mean Error: %f %%", num_output, mean_error);
        end
    endtask

	task TEST_CONV_MAP3_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            RESET_CNT_OUTPUT;
            CONV_MAP3_READ_INPUT(channel);
            channel_idx <= channel;
            CONV_MAP3_DRIVE;
            convolution_enable <= 1'b0;
            repeat (10) @(posedge clk);
            $display("[%m] Channel %0d finished!", channel);
            $display("[%m] Evaluating error in processing channel %0d...", channel);
            CONV_MAP4_EVAL_ERROR(channel, cnt_output, 1);
            repeat (5) @(posedge clk);
        end
	endtask

    task automatic TEST_CONV_MAP3_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            for (i = 0; i < 12; i = i + 1) begin
                TEST_CONV_MAP3_SINGLE_IMAGE_SINGLE_CHANNEL(i);
            end
            repeat (20) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif


