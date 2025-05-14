`ifndef DEF_TASKS_CONV_FIRST_H
`define DEF_TASKS_CONV_FIRST_H

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

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_0 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_1 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_2 [0:mem_size-1]      ;

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_0 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_1 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_2 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_3 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_4 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_5 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_6 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_7 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_8 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_9 [0:mem_size-1]  ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_10 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_11 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_12 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_13 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_14 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_15 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_16 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_17 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_18 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_19 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_20 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_21 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_22 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_23 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_24 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_25 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_26 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_27 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_28 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_29 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_30 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_31 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_32 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_33 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_34 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_35 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_36 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_37 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_38 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_39 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_40 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_41 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_42 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_43 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_44 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_45 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_46 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_47 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_48 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_49 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_50 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_51 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_52 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_53 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_54 [0:mem_size-1] ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_conv_first_output_55 [0:mem_size-1] ;

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task automatic READ_INPUT
    (
        input integer output_channel_idx
    );
        reg [8*6-1:0] _weight;
        reg [8*4-1:0] _bias;
        reg [8*5-1:0] _slope;
        reg [8*6-1:0] _output;
        reg [8*1-1:0] _underbar;
        reg [8*4-1:0] _filetype;
        reg [8*1-1:0] _idx_up;
        reg [8*1-1:0] _idx_down;
        begin
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            if (output_channel_idx > 9) begin
                _idx_up     = output_channel_idx / 10 + 48;
                _idx_down   = output_channel_idx % 10 + 48;
                $readmemh({_weight  , _underbar, _idx_up, _idx_down, _filetype}, mem_weight );
                $readmemh({_bias    , _underbar, _idx_up, _idx_down, _filetype}, mem_bias   );
                $readmemh({_slope   , _underbar, _idx_up, _idx_down, _filetype}, mem_slope  );
                $readmemh({_output  , _underbar, _idx_up, _idx_down, _filetype}, mem_golden );
            end
            else begin
                _idx_down   = output_channel_idx + 48;
                $readmemh({_weight  , _underbar, _idx_down, _filetype}, mem_weight );
                $readmemh({_bias    , _underbar, _idx_down, _filetype}, mem_bias   );
                $readmemh({_slope   , _underbar, _idx_down, _filetype}, mem_slope  );
                $readmemh({_output  , _underbar, _idx_down, _filetype}, mem_golden );
            end

            $readmemh("input_0.txt", mem_input_0);
            $readmemh("input_1.txt", mem_input_1);
            $readmemh("input_2.txt", mem_input_2);
        end
    endtask

    task automatic CONV_FIRST_DRIVE_INPUT_0;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            fork
                begin
                    for (i = 0; i < VSIZE; i = i + 1) begin
                        for (j = 0; j < HSIZE; j  = j + 1) begin
                            for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                                for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                                    if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                        data_in[((ii - i) * 5 + (jj - j)) + 12] <= 'b0;
                                    end
                                    else begin
                                        data_in[((ii - i) * 5 + (jj - j)) + 12] <= mem_input_0[ii * HSIZE + jj];
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
    
    task automatic CONV_FIRST_DRIVE_INPUT_1;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                        for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                            if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                data_in[((ii - i) * 5 + (jj - j)) + 37] <= 1'b0;
                            end
                            else begin
                                data_in[((ii - i) * 5 + (jj - j)) + 37] <= mem_input_1[ii * HSIZE + jj];
                            end
                        end
                    end
                    @(posedge clk);
                end
            end
        end
    endtask

    task automatic CONV_FIRST_DRIVE_INPUT_2;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                        for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                            if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                data_in[((ii - i) * 5 + (jj - j)) + 62] <= 1'b0;
                            end
                            else begin
                                data_in[((ii - i) * 5 + (jj - j)) + 62] <= mem_input_2[ii * HSIZE + jj];
                            end
                        end
                    end
                    @(posedge clk);
                end
            end
        end
    endtask

    task automatic CONV_FIRST_DRIVE_INPUT;
        integer i;
        begin
            fork
                CONV_FIRST_DRIVE_INPUT_0;
                CONV_FIRST_DRIVE_INPUT_1;
                CONV_FIRST_DRIVE_INPUT_2;
                begin
                    layer_bits      <= 3'd0;
                    for (i = 75; i < 108; i = i + 1) begin
                        data_in[i]  <= 'b0;
                    end
                    @(posedge clk);
                end
            join
        end
    endtask

    task automatic CONV_FIRST_DRIVE_WEIGHT;
        integer i;
        integer j;
        begin
            for (i = 0; i < 75; i = i + 1) begin
                weight_in[i] <= mem_weight[i];
            end
            for (j = 75; j < 108; j = j + 1) begin
                weight_in[j] <= 'b0;
            end
            @(posedge clk);
        end
    endtask

    task CONV_FIRST_DRIVE;
        begin
            fork
                CONV_FIRST_DRIVE_INPUT;
                CONV_FIRST_DRIVE_WEIGHT;
                DRIVE_BIAS;
                DRIVE_SLOPE;
                begin
                    convolution_enable  <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

	reg signed [Q_INT_INPUT+Q_FRAC_INPUT-1:0] temp;
    task automatic CONV_FIRST_EVAL_ERROR
    (
        input [31:0]    output_channel_idx,
        input [31:0]	num_output,
        input real		display_error_threshold
    );
        integer i;
        //integer signed temp;
        real error;
        real mean_error;
        begin
            mean_error = 0;
            for (i = 0; i < num_output; i = i + 1) begin
                case (output_channel_idx)
                    'd0     : temp = mem_conv_first_output_0[i]     ;
                    'd1     : temp = mem_conv_first_output_1[i]     ;
                    'd2     : temp = mem_conv_first_output_2[i]     ;
                    'd3     : temp = mem_conv_first_output_3[i]     ;
                    'd4     : temp = mem_conv_first_output_4[i]     ;
                    'd5     : temp = mem_conv_first_output_5[i]     ;
                    'd6     : temp = mem_conv_first_output_6[i]     ;
                    'd7     : temp = mem_conv_first_output_7[i]     ;
                    'd8     : temp = mem_conv_first_output_8[i]     ;
                    'd9     : temp = mem_conv_first_output_9[i]     ;
                    'd10    : temp = mem_conv_first_output_10[i]    ;
                    'd11    : temp = mem_conv_first_output_11[i]    ;
                    'd12    : temp = mem_conv_first_output_12[i]    ;
                    'd13    : temp = mem_conv_first_output_13[i]    ;
                    'd14    : temp = mem_conv_first_output_14[i]    ;
                    'd15    : temp = mem_conv_first_output_15[i]    ;
                    'd16    : temp = mem_conv_first_output_16[i]    ;
                    'd17    : temp = mem_conv_first_output_17[i]    ;
                    'd18    : temp = mem_conv_first_output_18[i]    ;
                    'd19    : temp = mem_conv_first_output_19[i]    ;
                    'd20    : temp = mem_conv_first_output_20[i]    ;
                    'd21    : temp = mem_conv_first_output_21[i]    ;
                    'd22    : temp = mem_conv_first_output_22[i]    ;
                    'd23    : temp = mem_conv_first_output_23[i]    ;
                    'd24    : temp = mem_conv_first_output_24[i]    ;
                    'd25    : temp = mem_conv_first_output_25[i]    ;
                    'd26    : temp = mem_conv_first_output_26[i]    ;
                    'd27    : temp = mem_conv_first_output_27[i]    ;
                    'd28    : temp = mem_conv_first_output_28[i]    ;
                    'd29    : temp = mem_conv_first_output_29[i]    ;
                    'd30    : temp = mem_conv_first_output_30[i]    ;
                    'd31    : temp = mem_conv_first_output_31[i]    ;
                    'd32    : temp = mem_conv_first_output_32[i]    ;
                    'd33    : temp = mem_conv_first_output_33[i]    ;
                    'd34    : temp = mem_conv_first_output_34[i]    ;
                    'd35    : temp = mem_conv_first_output_35[i]    ;
                    'd36    : temp = mem_conv_first_output_36[i]    ;
                    'd37    : temp = mem_conv_first_output_37[i]    ;
                    'd38    : temp = mem_conv_first_output_38[i]    ;
                    'd39    : temp = mem_conv_first_output_39[i]    ;
                    'd40    : temp = mem_conv_first_output_40[i]    ;
                    'd41    : temp = mem_conv_first_output_41[i]    ;
                    'd42    : temp = mem_conv_first_output_42[i]    ;
                    'd43    : temp = mem_conv_first_output_43[i]    ;
                    'd44    : temp = mem_conv_first_output_44[i]    ;
                    'd45    : temp = mem_conv_first_output_45[i]    ;
                    'd46    : temp = mem_conv_first_output_46[i]    ;
                    'd47    : temp = mem_conv_first_output_47[i]    ;
                    'd48    : temp = mem_conv_first_output_48[i]    ;
                    'd49    : temp = mem_conv_first_output_49[i]    ;
                    'd50    : temp = mem_conv_first_output_50[i]    ;
                    'd51    : temp = mem_conv_first_output_51[i]    ;
                    'd52    : temp = mem_conv_first_output_52[i]    ;
                    'd53    : temp = mem_conv_first_output_53[i]    ;
                    'd54    : temp = mem_conv_first_output_54[i]    ;
                    'd55    : temp = mem_conv_first_output_55[i]    ;
                endcase
                if (mem_golden[i]) begin
                	error = $signed(mem_golden[i]) >= $signed(temp) ?
                                                                    $signed(mem_golden[i]) - $signed(temp) :
                                                                    $signed(temp) - $signed(mem_golden[i]);
                	error = error / mem_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                if (error < 0 || error > display_error_threshold) begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_golden[i],
                    temp,
                    $signed(mem_golden[i]) - $signed(temp),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Number of Output: %d, Mean Error: %f %%", num_output, mean_error);
        end
    endtask

	task TEST_CONV_FIRST_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            RESET;
            READ_INPUT(channel);
            DRIVE;
            convolution_enable <= 1'b0;
            repeat (20) @(posedge clk);
            $display("Channel %0d finished!", channel);
            $display("Evaluating error in processing channel %0d...", channel);
            EVAL_ERROR(channel, cnt_output, 1.0);
        end
	endtask

    task automatic TEST_CONV_FIRST_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            fork
                RESET_CNT_OUTPUT;
                RESET_CHANNEL_IDX;
            join
            for (i = 0; i < 56; i = i + 1) begin
                TEST_CONV_FIRST_SINGLE_IMAGE_SINGLE_CHANNEL(i);
                repeat (5) @(posedge clk);
                RESET_CNT_OUTPUT;
            end
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif