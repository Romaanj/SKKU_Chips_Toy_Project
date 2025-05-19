`ifndef DEF_TASKS_CONV_SHRINK_H
`define DEF_TASKS_CONV_SHRINK_H

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

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_conv_shrink_weight      [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_conv_shrink_bias        [0:0]               ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_conv_shrink_slope       [0:0]               ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_shrink_golden      [0:mem_size-1]      ;

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_0    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_1    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_2    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_3    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_4    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_5    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_6    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_7    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_8    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_9    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_10   [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_shrink_output_11   [0:mem_size-1]      ;

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task automatic CONV_SHRINK_READ_INPUT
    (
        input integer output_channel_idx
    );
        reg [8*12-1:0]  _prefix;
        reg [8*6-1:0]   _weight;
        reg [8*4-1:0]   _bias;
        reg [8*5-1:0]   _slope;
        reg [8*6-1:0]   _output;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_up;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix         = "conv_shrink_";
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            if (output_channel_idx > 9) begin
                _idx_up     = output_channel_idx / 10 + 48;
                _idx_down   = output_channel_idx % 10 + 48;
                $readmemh({_prefix, _weight  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_shrink_weight );
                $readmemh({_prefix, _bias    , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_shrink_bias   );
                $readmemh({_prefix, _slope   , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_shrink_slope  );
                $readmemh({_prefix, _output  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_shrink_golden );
            end
            else begin
                _idx_down   = output_channel_idx + 48;
                $readmemh({_prefix, _weight  , _underbar, _idx_down, _filetype}, mem_conv_shrink_weight );
                $readmemh({_prefix, _bias    , _underbar, _idx_down, _filetype}, mem_conv_shrink_bias   );
                $readmemh({_prefix, _slope   , _underbar, _idx_down, _filetype}, mem_conv_shrink_slope  );
                $readmemh({_prefix, _output  , _underbar, _idx_down, _filetype}, mem_conv_shrink_golden );
            end
        end
    endtask

    task automatic CONV_SHRINK_DRIVE_INPUT_INTERNAL;
        integer i;
        integer j;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    data_in[0]      <= mem_conv_first_output_0[i * HSIZE + j]   ;
                    data_in[1]      <= mem_conv_first_output_1[i * HSIZE + j]   ;
                    data_in[2]      <= mem_conv_first_output_2[i * HSIZE + j]   ;
                    data_in[3]      <= mem_conv_first_output_3[i * HSIZE + j]   ;
                    data_in[4]      <= mem_conv_first_output_4[i * HSIZE + j]   ;
                    data_in[5]      <= mem_conv_first_output_5[i * HSIZE + j]   ;
                    data_in[6]      <= mem_conv_first_output_6[i * HSIZE + j]   ;
                    data_in[7]      <= mem_conv_first_output_7[i * HSIZE + j]   ;
                    data_in[8]      <= mem_conv_first_output_8[i * HSIZE + j]   ;
                    data_in[9]      <= mem_conv_first_output_9[i * HSIZE + j]   ;
                    data_in[10]     <= mem_conv_first_output_10[i * HSIZE + j]  ;
                    data_in[11]     <= mem_conv_first_output_11[i * HSIZE + j]  ;
                    data_in[12]     <= mem_conv_first_output_12[i * HSIZE + j]  ;
                    data_in[13]     <= mem_conv_first_output_13[i * HSIZE + j]  ;
                    data_in[14]     <= mem_conv_first_output_14[i * HSIZE + j]  ;
                    data_in[15]     <= mem_conv_first_output_15[i * HSIZE + j]  ;
                    data_in[16]     <= mem_conv_first_output_16[i * HSIZE + j]  ;
                    data_in[17]     <= mem_conv_first_output_17[i * HSIZE + j]  ;
                    data_in[18]     <= mem_conv_first_output_18[i * HSIZE + j]  ;
                    data_in[19]     <= mem_conv_first_output_19[i * HSIZE + j]  ;
                    data_in[20]     <= mem_conv_first_output_20[i * HSIZE + j]  ;
                    data_in[21]     <= mem_conv_first_output_21[i * HSIZE + j]  ;
                    data_in[22]     <= mem_conv_first_output_22[i * HSIZE + j]  ;
                    data_in[23]     <= mem_conv_first_output_23[i * HSIZE + j]  ;
                    data_in[24]     <= mem_conv_first_output_24[i * HSIZE + j]  ;
                    data_in[25]     <= mem_conv_first_output_25[i * HSIZE + j]  ;
                    data_in[26]     <= mem_conv_first_output_26[i * HSIZE + j]  ;
                    data_in[27]     <= mem_conv_first_output_27[i * HSIZE + j]  ;
                    data_in[28]     <= mem_conv_first_output_28[i * HSIZE + j]  ;
                    data_in[29]     <= mem_conv_first_output_29[i * HSIZE + j]  ;
                    data_in[30]     <= mem_conv_first_output_30[i * HSIZE + j]  ;
                    data_in[31]     <= mem_conv_first_output_31[i * HSIZE + j]  ;
                    data_in[32]     <= mem_conv_first_output_32[i * HSIZE + j]  ;
                    data_in[33]     <= mem_conv_first_output_33[i * HSIZE + j]  ;
                    data_in[34]     <= mem_conv_first_output_34[i * HSIZE + j]  ;
                    data_in[35]     <= mem_conv_first_output_35[i * HSIZE + j]  ;
                    data_in[36]     <= mem_conv_first_output_36[i * HSIZE + j]  ;
                    data_in[37]     <= mem_conv_first_output_37[i * HSIZE + j]  ;
                    data_in[38]     <= mem_conv_first_output_38[i * HSIZE + j]  ;
                    data_in[39]     <= mem_conv_first_output_39[i * HSIZE + j]  ;
                    data_in[40]     <= mem_conv_first_output_40[i * HSIZE + j]  ;
                    data_in[41]     <= mem_conv_first_output_41[i * HSIZE + j]  ;
                    data_in[42]     <= mem_conv_first_output_42[i * HSIZE + j]  ;
                    data_in[43]     <= mem_conv_first_output_43[i * HSIZE + j]  ;
                    data_in[44]     <= mem_conv_first_output_44[i * HSIZE + j]  ;
                    data_in[45]     <= mem_conv_first_output_45[i * HSIZE + j]  ;
                    data_in[46]     <= mem_conv_first_output_46[i * HSIZE + j]  ;
                    data_in[47]     <= mem_conv_first_output_47[i * HSIZE + j]  ;
                    data_in[48]     <= mem_conv_first_output_48[i * HSIZE + j]  ;
                    data_in[49]     <= mem_conv_first_output_49[i * HSIZE + j]  ;
                    data_in[50]     <= mem_conv_first_output_50[i * HSIZE + j]  ;
                    data_in[51]     <= mem_conv_first_output_51[i * HSIZE + j]  ;
                    data_in[52]     <= mem_conv_first_output_52[i * HSIZE + j]  ;
                    data_in[53]     <= mem_conv_first_output_53[i * HSIZE + j]  ;
                    data_in[54]     <= mem_conv_first_output_54[i * HSIZE + j]  ;
                    data_in[55]     <= mem_conv_first_output_55[i * HSIZE + j]  ;
                    @(posedge clk);
                end
            end
        end
    endtask
    
    task automatic CONV_SHRINK_DRIVE_INPUT;
        integer i;
        begin
            fork
                CONV_SHRINK_DRIVE_INPUT_INTERNAL;
                begin
                    layer_bits      <= 3'd1;
                    for (i = 56; i < 108; i = i + 1) begin
                        data_in[i]  <= 'b0;
                    end
                    @(posedge clk);
                end
            join
        end
    endtask

    task automatic CONV_SHRINK_DRIVE_WEIGHT;
        integer i;
        integer j;
        begin
            for (i = 0; i < 56; i = i + 1) begin
                weight_in[i] <= mem_conv_shrink_weight[i];
            end
            for (j = 56; j < 108; j = j + 1) begin
                weight_in[j] <= 'b0;
            end
            @(posedge clk);
        end
    endtask

    task CONV_SHRINK_DRIVE_BIAS;
        begin
            bias_in <= mem_conv_shrink_bias[0];
            @(posedge clk);
        end
    endtask

    task CONV_SHRINK_DRIVE_SLOPE;
        begin
            slope_in <= mem_conv_shrink_slope[0];
            @(posedge clk);
        end
    endtask

    task CONV_SHRINK_DRIVE;
        begin
            fork
                CONV_SHRINK_DRIVE_INPUT;
                CONV_SHRINK_DRIVE_WEIGHT;
                CONV_SHRINK_DRIVE_BIAS;
                CONV_SHRINK_DRIVE_SLOPE;
                begin
                    convolution_enable  <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

	reg signed [Q_INT_INPUT+Q_FRAC_INPUT-1:0] conv_shrink_output_temp;
    task automatic CONV_SHRINK_EVAL_ERROR
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
                    'd0     : conv_shrink_output_temp = mem_conv_shrink_output_0[i]     ;
                    'd1     : conv_shrink_output_temp = mem_conv_shrink_output_1[i]     ;
                    'd2     : conv_shrink_output_temp = mem_conv_shrink_output_2[i]     ;
                    'd3     : conv_shrink_output_temp = mem_conv_shrink_output_3[i]     ;
                    'd4     : conv_shrink_output_temp = mem_conv_shrink_output_4[i]     ;
                    'd5     : conv_shrink_output_temp = mem_conv_shrink_output_5[i]     ;
                    'd6     : conv_shrink_output_temp = mem_conv_shrink_output_6[i]     ;
                    'd7     : conv_shrink_output_temp = mem_conv_shrink_output_7[i]     ;
                    'd8     : conv_shrink_output_temp = mem_conv_shrink_output_8[i]     ;
                    'd9     : conv_shrink_output_temp = mem_conv_shrink_output_9[i]     ;
                    'd10    : conv_shrink_output_temp = mem_conv_shrink_output_10[i]    ;
                    'd11    : conv_shrink_output_temp = mem_conv_shrink_output_11[i]    ;
                endcase
                if (mem_conv_shrink_golden[i]) begin
                	error = $signed(mem_conv_shrink_golden[i]) >= $signed(conv_shrink_output_temp) ?
                                                                    $signed(mem_conv_shrink_golden[i]) - $signed(conv_shrink_output_temp) :
                                                                    $signed(conv_shrink_output_temp) - $signed(mem_conv_shrink_golden[i]);
                	error = error / mem_conv_shrink_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                if (error < 0 || error > display_error_threshold) begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_conv_shrink_golden[i],
                    conv_shrink_output_temp,
                    $signed(mem_conv_shrink_golden[i]) - $signed(conv_shrink_output_temp),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Number of Output: %d, Mean Error: %f %%", num_output, mean_error);
        end
    endtask

	task TEST_CONV_SHRINK_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            RESET_CNT_OUTPUT;
            CONV_SHRINK_READ_INPUT(channel);
            channel_idx <= channel;
            CONV_SHRINK_DRIVE;
            convolution_enable <= 1'b0;
            repeat (10) @(posedge clk);
            $display("[%m] Channel %0d finished!", channel);
            $display("[%m] Evaluating error in processing channel %0d...", channel);
            CONV_SHRINK_EVAL_ERROR(channel, cnt_output, 0.000001);
            repeat (5) @(posedge clk);
        end
	endtask

    task automatic TEST_CONV_SHRINK_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            for (i = 0; i < 12; i = i + 1) begin
                TEST_CONV_SHRINK_SINGLE_IMAGE_SINGLE_CHANNEL(i);
            end
            repeat (20) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif