`ifndef DEF_TASKS_CONV_EXPAND_H
`define DEF_TASKS_CONV_EXPAND_H

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

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_conv_expand_weight      [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_conv_expand_bias        [0:0]               ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_conv_expand_slope       [0:0]               ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_golden      [0:mem_size-1]      ;

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_0    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_1    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_2    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_3    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_4    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_5    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_6    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_7    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_8    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_9    [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_10   [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_expand_output_11   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_12   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_13   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_14   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_15   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_16   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_17   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_18   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_19   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_20   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_21   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_22   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_23   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_24   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_25   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_26   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_27   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_28   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_29   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_30   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_31   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_32   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_33   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_34   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_35   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_36   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_37   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_38   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_39   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_40   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_41   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_42   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_43   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_44   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_45   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_46   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_47   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_48   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_49   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_50   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_51   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_52   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_53   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_54   [0:mem_size-1]      ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_expand_output_55   [0:mem_size-1]      ;



    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task automatic CONV_EXPAND_READ_INPUT
    (
        input integer output_channel_idx
    );
        reg [8*15-1:0]  _prefix;
        reg [8*6-1:0]   _weight;
        reg [8*4-1:0]   _bias;
        reg [8*5-1:0]   _slope;
        reg [8*6-1:0]   _output;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_up;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix         = "conv_expanding_";
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            if (output_channel_idx > 9) begin
                _idx_up     = output_channel_idx / 10 + 48;
                _idx_down   = output_channel_idx % 10 + 48;
                $readmemh({_prefix, _weight  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_expand_weight );
                $readmemh({_prefix, _bias    , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_expand_bias   );
                $readmemh({_prefix, _slope   , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_expand_slope  );
                $readmemh({_prefix, _output  , _underbar, _idx_up, _idx_down, _filetype}, mem_conv_expand_golden );
            end
            else begin
                _idx_down   = output_channel_idx + 48;
                $readmemh({_prefix, _weight  , _underbar, _idx_down, _filetype}, mem_conv_expand_weight );
                $readmemh({_prefix, _bias    , _underbar, _idx_down, _filetype}, mem_conv_expand_bias   );
                $readmemh({_prefix, _slope   , _underbar, _idx_down, _filetype}, mem_conv_expand_slope  );
                $readmemh({_prefix, _output  , _underbar, _idx_down, _filetype}, mem_conv_expand_golden );
            end
        end
    endtask

    task automatic CONV_EXPAND_DRIVE_INPUT_INTERNAL;
        integer i;
        integer j;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    data_in[0]      <= mem_conv_map4_output_0[i * HSIZE + j]   ;
                    data_in[1]      <= mem_conv_map4_output_1[i * HSIZE + j]   ;
                    data_in[2]      <= mem_conv_map4_output_2[i * HSIZE + j]   ;
                    data_in[3]      <= mem_conv_map4_output_3[i * HSIZE + j]   ;
                    data_in[4]      <= mem_conv_map4_output_4[i * HSIZE + j]   ;
                    data_in[5]      <= mem_conv_map4_output_5[i * HSIZE + j]   ;
                    data_in[6]      <= mem_conv_map4_output_6[i * HSIZE + j]   ;
                    data_in[7]      <= mem_conv_map4_output_7[i * HSIZE + j]   ;
                    data_in[8]      <= mem_conv_map4_output_8[i * HSIZE + j]   ;
                    data_in[9]      <= mem_conv_map4_output_9[i * HSIZE + j]   ;
                    data_in[10]     <= mem_conv_map4_output_10[i * HSIZE + j]  ;
                    data_in[11]     <= mem_conv_map4_output_11[i * HSIZE + j]  ;
                    @(posedge clk);
                end
            end
        end
    

    endtask
    
    task automatic CONV_EXPAND_DRIVE_INPUT;
        integer i;
        begin
            fork
                CONV_EXPAND_DRIVE_INPUT_INTERNAL;
                begin
                    layer_bits      <= 3'd6;
                    for (i = 12; i < 108; i = i + 1) begin
                        data_in[i]  <= 'b0;
                    end
                    @(posedge clk);
                end
            join
        end
    endtask

    task automatic CONV_EXPAND_DRIVE_WEIGHT;
        integer i;
        integer j;
        begin
            for (i = 0; i < 12; i = i + 1) begin
                weight_in[i] <= mem_conv_expand_weight[i];
            end
            for (j = 12; j < 108; j = j + 1) begin
                weight_in[j] <= 'b0;
            end
            @(posedge clk);
        end
    endtask

    task CONV_EXPAND_DRIVE_BIAS;
        begin
            bias_in <= mem_conv_expand_bias[0];
            @(posedge clk);
        end
    endtask

    task CONV_EXPAND_DRIVE_SLOPE;
        begin
            slope_in <= mem_conv_expand_slope[0];
            @(posedge clk);
        end
    endtask

    task CONV_EXPAND_DRIVE;
        begin
            fork
                CONV_EXPAND_DRIVE_INPUT;
                CONV_EXPAND_DRIVE_WEIGHT;
                CONV_EXPAND_DRIVE_BIAS;
                CONV_EXPAND_DRIVE_SLOPE;
                begin
                    convolution_enable  <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

	reg signed [Q_INT_INPUT+Q_FRAC_INPUT-1:0] conv_expand_output_temp;
    task automatic CONV_EXPAND_EVAL_ERROR
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
                    'd0     : conv_expand_output_temp = mem_conv_expand_output_0[i]     ;
                    'd1     : conv_expand_output_temp = mem_conv_expand_output_1[i]     ;
                    'd2     : conv_expand_output_temp = mem_conv_expand_output_2[i]     ;
                    'd3     : conv_expand_output_temp = mem_conv_expand_output_3[i]     ;
                    'd4     : conv_expand_output_temp = mem_conv_expand_output_4[i]     ;
                    'd5     : conv_expand_output_temp = mem_conv_expand_output_5[i]     ;
                    'd6     : conv_expand_output_temp = mem_conv_expand_output_6[i]     ;
                    'd7     : conv_expand_output_temp = mem_conv_expand_output_7[i]     ;
                    'd8     : conv_expand_output_temp = mem_conv_expand_output_8[i]     ;
                    'd9     : conv_expand_output_temp = mem_conv_expand_output_9[i]     ;
                    'd10    : conv_expand_output_temp = mem_conv_expand_output_10[i]    ;
                    'd11    : conv_expand_output_temp = mem_conv_expand_output_11[i]    ;
                    'd10    : conv_expand_output_temp = mem_conv_expand_output_10[i]    ;
                    'd11    : conv_expand_output_temp = mem_conv_expand_output_11[i]    ;
                    'd12    : conv_expand_output_temp = mem_conv_expand_output_12[i]    ;
                    'd13    : conv_expand_output_temp = mem_conv_expand_output_13[i]    ;
                    'd14    : conv_expand_output_temp = mem_conv_expand_output_14[i]    ;
                    'd15    : conv_expand_output_temp = mem_conv_expand_output_15[i]    ;
                    'd16    : conv_expand_output_temp = mem_conv_expand_output_16[i]    ;
                    'd17    : conv_expand_output_temp = mem_conv_expand_output_17[i]    ;
                    'd18    : conv_expand_output_temp = mem_conv_expand_output_18[i]    ;
                    'd19    : conv_expand_output_temp = mem_conv_expand_output_19[i]    ;
                    'd20    : conv_expand_output_temp = mem_conv_expand_output_20[i]    ;
                    'd21    : conv_expand_output_temp = mem_conv_expand_output_21[i]    ;
                    'd22    : conv_expand_output_temp = mem_conv_expand_output_22[i]    ;
                    'd23    : conv_expand_output_temp = mem_conv_expand_output_23[i]    ;
                    'd24    : conv_expand_output_temp = mem_conv_expand_output_24[i]    ;
                    'd25    : conv_expand_output_temp = mem_conv_expand_output_25[i]    ;
                    'd26    : conv_expand_output_temp = mem_conv_expand_output_26[i]    ;
                    'd27    : conv_expand_output_temp = mem_conv_expand_output_27[i]    ;
                    'd28    : conv_expand_output_temp = mem_conv_expand_output_28[i]    ;
                    'd29    : conv_expand_output_temp = mem_conv_expand_output_29[i]    ;
                    'd30    : conv_expand_output_temp = mem_conv_expand_output_30[i]    ;
                    'd31    : conv_expand_output_temp = mem_conv_expand_output_31[i]    ;
                    'd32    : conv_expand_output_temp = mem_conv_expand_output_32[i]    ;
                    'd33    : conv_expand_output_temp = mem_conv_expand_output_33[i]    ;
                    'd34    : conv_expand_output_temp = mem_conv_expand_output_34[i]    ;
                    'd35    : conv_expand_output_temp = mem_conv_expand_output_35[i]    ;
                    'd36    : conv_expand_output_temp = mem_conv_expand_output_36[i]    ;
                    'd37    : conv_expand_output_temp = mem_conv_expand_output_37[i]    ;
                    'd38    : conv_expand_output_temp = mem_conv_expand_output_38[i]    ;
                    'd39    : conv_expand_output_temp = mem_conv_expand_output_39[i]    ;
                    'd40    : conv_expand_output_temp = mem_conv_expand_output_40[i]    ;
                    'd41    : conv_expand_output_temp = mem_conv_expand_output_41[i]    ;
                    'd42    : conv_expand_output_temp = mem_conv_expand_output_42[i]    ;
                    'd43    : conv_expand_output_temp = mem_conv_expand_output_43[i]    ;
                    'd44    : conv_expand_output_temp = mem_conv_expand_output_44[i]    ;
                    'd45    : conv_expand_output_temp = mem_conv_expand_output_45[i]    ;
                    'd46    : conv_expand_output_temp = mem_conv_expand_output_46[i]    ;
                    'd47    : conv_expand_output_temp = mem_conv_expand_output_47[i]    ;
                    'd48    : conv_expand_output_temp = mem_conv_expand_output_48[i]    ;
                    'd49    : conv_expand_output_temp = mem_conv_expand_output_49[i]    ;
                    'd50    : conv_expand_output_temp = mem_conv_expand_output_50[i]    ;
                    'd51    : conv_expand_output_temp = mem_conv_expand_output_51[i]    ;
                    'd52    : conv_expand_output_temp = mem_conv_expand_output_52[i]    ;
                    'd53    : conv_expand_output_temp = mem_conv_expand_output_53[i]    ;
                    'd54    : conv_expand_output_temp = mem_conv_expand_output_54[i]    ;
                    'd55    : conv_expand_output_temp = mem_conv_expand_output_55[i]    ;
                endcase
                if (mem_conv_expand_golden[i]) begin
                	error = $signed(mem_conv_expand_golden[i]) >= $signed(conv_expand_output_temp) ?
                                                                    $signed(mem_conv_expand_golden[i]) - $signed(conv_expand_output_temp) :
                                                                    $signed(conv_expand_output_temp) - $signed(mem_conv_expand_golden[i]);
                	error = error / mem_conv_expand_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                if (error < 0 || error > display_error_threshold)  begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_conv_expand_golden[i],
                    conv_expand_output_temp,
                    $signed(mem_conv_expand_golden[i]) - $signed(conv_expand_output_temp),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Number of Output: %d, Mean Error: %f %%", num_output, mean_error);
        end
    endtask

    task automatic TEST_CONV_EXPAND_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            RESET_CNT_OUTPUT;
            CONV_EXPAND_READ_INPUT(channel);
            channel_idx <= channel;
            CONV_EXPAND_DRIVE;
            convolution_enable <= 1'b0;
            repeat (10) @(posedge clk);
            $display("[%m] Channel %0d finished!", channel);
            $display("[%m] Evaluating error in processing channel %0d...", channel);
            CONV_EXPAND_EVAL_ERROR(channel, cnt_output, 1.0);
            repeat (5) @(posedge clk);
        end
    endtask

    task automatic TEST_CONV_EXPAND_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            for (i = 0; i < 56; i = i + 1) begin
                TEST_CONV_EXPAND_SINGLE_IMAGE_SINGLE_CHANNEL(i);
            end
            repeat (20) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif