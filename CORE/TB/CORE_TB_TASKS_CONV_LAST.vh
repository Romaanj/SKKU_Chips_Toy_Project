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

    parameter                                       conv_last_weight_size       = 81 * 56           ;

    // -------------------------------------------------------------------------------

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_conv_last_weight       [0:conv_last_weight_size-1];
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_conv_last_bias         [0:0]                ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_conv_last_slope        [0:0]                ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_last_golden       [0:9*mem_size-1]     ;

    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_last_output_0     [0:9*mem_size-1]     ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_last_output_1     [0:9*mem_size-1]     ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_conv_last_output_2     [0:9*mem_size-1]     ;

    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    function is_upsampled
    (
        input integer row,
        input integer col
    );
        begin
            if (row % 3 == 0 && col % 3 == 0) begin
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

    task automatic CONV_LAST_READ_EXPANDING_GOLDEN;
        begin
            $readmemh("conv_expanding_output_0.txt", mem_conv_expand_output_0);
            $readmemh("conv_expanding_output_1.txt", mem_conv_expand_output_1);
            $readmemh("conv_expanding_output_2.txt", mem_conv_expand_output_2);
            $readmemh("conv_expanding_output_3.txt", mem_conv_expand_output_3);
            $readmemh("conv_expanding_output_4.txt", mem_conv_expand_output_4);
            $readmemh("conv_expanding_output_5.txt", mem_conv_expand_output_5);
            $readmemh("conv_expanding_output_6.txt", mem_conv_expand_output_6);
            $readmemh("conv_expanding_output_7.txt", mem_conv_expand_output_7);
            $readmemh("conv_expanding_output_8.txt", mem_conv_expand_output_8);
            $readmemh("conv_expanding_output_9.txt", mem_conv_expand_output_9);
            $readmemh("conv_expanding_output_10.txt", mem_conv_expand_output_10);
            $readmemh("conv_expanding_output_11.txt", mem_conv_expand_output_11);
            $readmemh("conv_expanding_output_12.txt", mem_conv_expand_output_12);
            $readmemh("conv_expanding_output_13.txt", mem_conv_expand_output_13);
            $readmemh("conv_expanding_output_14.txt", mem_conv_expand_output_14);
            $readmemh("conv_expanding_output_15.txt", mem_conv_expand_output_15);
            $readmemh("conv_expanding_output_16.txt", mem_conv_expand_output_16);
            $readmemh("conv_expanding_output_17.txt", mem_conv_expand_output_17);
            $readmemh("conv_expanding_output_18.txt", mem_conv_expand_output_18);
            $readmemh("conv_expanding_output_19.txt", mem_conv_expand_output_19);
            $readmemh("conv_expanding_output_20.txt", mem_conv_expand_output_20);
            $readmemh("conv_expanding_output_21.txt", mem_conv_expand_output_21);
            $readmemh("conv_expanding_output_22.txt", mem_conv_expand_output_22);
            $readmemh("conv_expanding_output_23.txt", mem_conv_expand_output_23);
            $readmemh("conv_expanding_output_24.txt", mem_conv_expand_output_24);
            $readmemh("conv_expanding_output_25.txt", mem_conv_expand_output_25);
            $readmemh("conv_expanding_output_26.txt", mem_conv_expand_output_26);
            $readmemh("conv_expanding_output_27.txt", mem_conv_expand_output_27);
            $readmemh("conv_expanding_output_28.txt", mem_conv_expand_output_28);
            $readmemh("conv_expanding_output_29.txt", mem_conv_expand_output_29);
            $readmemh("conv_expanding_output_30.txt", mem_conv_expand_output_30);
            $readmemh("conv_expanding_output_31.txt", mem_conv_expand_output_31);
            $readmemh("conv_expanding_output_32.txt", mem_conv_expand_output_32);
            $readmemh("conv_expanding_output_33.txt", mem_conv_expand_output_33);
            $readmemh("conv_expanding_output_34.txt", mem_conv_expand_output_34);
            $readmemh("conv_expanding_output_35.txt", mem_conv_expand_output_35);
            $readmemh("conv_expanding_output_36.txt", mem_conv_expand_output_36);
            $readmemh("conv_expanding_output_37.txt", mem_conv_expand_output_37);
            $readmemh("conv_expanding_output_38.txt", mem_conv_expand_output_38);
            $readmemh("conv_expanding_output_39.txt", mem_conv_expand_output_39);
            $readmemh("conv_expanding_output_40.txt", mem_conv_expand_output_40);
            $readmemh("conv_expanding_output_41.txt", mem_conv_expand_output_41);
            $readmemh("conv_expanding_output_42.txt", mem_conv_expand_output_42);
            $readmemh("conv_expanding_output_43.txt", mem_conv_expand_output_43);
            $readmemh("conv_expanding_output_44.txt", mem_conv_expand_output_44);
            $readmemh("conv_expanding_output_45.txt", mem_conv_expand_output_45);
            $readmemh("conv_expanding_output_46.txt", mem_conv_expand_output_46);
            $readmemh("conv_expanding_output_47.txt", mem_conv_expand_output_47);
            $readmemh("conv_expanding_output_48.txt", mem_conv_expand_output_48);
            $readmemh("conv_expanding_output_49.txt", mem_conv_expand_output_49);
            $readmemh("conv_expanding_output_50.txt", mem_conv_expand_output_50);
            $readmemh("conv_expanding_output_51.txt", mem_conv_expand_output_51);
            $readmemh("conv_expanding_output_52.txt", mem_conv_expand_output_52);
            $readmemh("conv_expanding_output_53.txt", mem_conv_expand_output_53);
            $readmemh("conv_expanding_output_54.txt", mem_conv_expand_output_54);
            $readmemh("conv_expanding_output_55.txt", mem_conv_expand_output_55);
        end
    endtask

    task automatic CONV_LAST_READ_WEIGHT_BIAS_GOLDEN
    (
        input integer output_channel_idx
    );
        reg [8*10-1:0]  _prefix;
        reg [8*6-1:0]   _weight;
        reg [8*4-1:0]   _bias;
        reg [8*6-1:0]   _output;
        reg [8*1-1:0]   _underbar;
        reg [8*4-1:0]   _filetype;
        reg [8*1-1:0]   _idx_down;
        begin
            _prefix         = "conv_last_";
            _weight         = "weight";
            _bias           = "bias";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            _idx_down   = output_channel_idx + 48;
            $readmemh({_prefix, _weight  , _underbar, _idx_down, _filetype}, mem_conv_last_weight );
            $readmemh({_prefix, _bias    , _underbar, _idx_down, _filetype}, mem_conv_last_bias   );
            $readmemh({_prefix, _output  , _underbar, _idx_down, _filetype}, mem_conv_last_golden );
        end
    endtask

    task automatic CONV_LAST_DRIVE_INPUT_INTERNAL
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
                    if (is_padding(HSIZE * 3, VSIZE * 3, i, j)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else if (is_upsampled(i, j)) begin
                        data_in[((i - row) * 9 + (j - col)) + 40] <= 'b0;
                    end
                    else begin
                        case (input_channel_idx)
                            'd0 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_0[(i/3) * HSIZE + (j/3)];
                            'd1 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_1[(i/3) * HSIZE + (j/3)];
                            'd2 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_2[(i/3) * HSIZE + (j/3)];
                            'd3 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_3[(i/3) * HSIZE + (j/3)];
                            'd4 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_4[(i/3) * HSIZE + (j/3)];
                            'd5 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_5[(i/3) * HSIZE + (j/3)];
                            'd6 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_6[(i/3) * HSIZE + (j/3)];
                            'd7 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_7[(i/3) * HSIZE + (j/3)];
                            'd8 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_8[(i/3) * HSIZE + (j/3)];
                            'd9 :   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_9[(i/3) * HSIZE + (j/3)];
                            'd10:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_10[(i/3) * HSIZE + (j/3)];
                            'd11:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_11[(i/3) * HSIZE + (j/3)];
                            'd12:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_12[(i/3) * HSIZE + (j/3)];
                            'd13:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_13[(i/3) * HSIZE + (j/3)];
                            'd14:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_14[(i/3) * HSIZE + (j/3)];
                            'd15:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_15[(i/3) * HSIZE + (j/3)];
                            'd16:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_16[(i/3) * HSIZE + (j/3)];
                            'd17:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_17[(i/3) * HSIZE + (j/3)];
                            'd18:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_18[(i/3) * HSIZE + (j/3)];
                            'd19:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_19[(i/3) * HSIZE + (j/3)];
                            'd20:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_20[(i/3) * HSIZE + (j/3)];
                            'd21:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_21[(i/3) * HSIZE + (j/3)];
                            'd22:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_22[(i/3) * HSIZE + (j/3)];
                            'd23:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_23[(i/3) * HSIZE + (j/3)];
                            'd24:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_24[(i/3) * HSIZE + (j/3)];
                            'd25:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_25[(i/3) * HSIZE + (j/3)];
                            'd26:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_26[(i/3) * HSIZE + (j/3)];
                            'd27:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_27[(i/3) * HSIZE + (j/3)];
                            'd28:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_28[(i/3) * HSIZE + (j/3)];
                            'd29:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_29[(i/3) * HSIZE + (j/3)];
                            'd30:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_30[(i/3) * HSIZE + (j/3)];
                            'd31:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_31[(i/3) * HSIZE + (j/3)];
                            'd32:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_32[(i/3) * HSIZE + (j/3)];
                            'd33:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_33[(i/3) * HSIZE + (j/3)];
                            'd34:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_34[(i/3) * HSIZE + (j/3)];
                            'd35:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_35[(i/3) * HSIZE + (j/3)];
                            'd36:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_36[(i/3) * HSIZE + (j/3)];
                            'd37:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_37[(i/3) * HSIZE + (j/3)];
                            'd38:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_38[(i/3) * HSIZE + (j/3)];
                            'd39:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_39[(i/3) * HSIZE + (j/3)];
                            'd40:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_40[(i/3) * HSIZE + (j/3)];
                            'd41:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_41[(i/3) * HSIZE + (j/3)];
                            'd42:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_42[(i/3) * HSIZE + (j/3)];
                            'd43:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_43[(i/3) * HSIZE + (j/3)];
                            'd44:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_44[(i/3) * HSIZE + (j/3)];
                            'd45:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_45[(i/3) * HSIZE + (j/3)];
                            'd46:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_46[(i/3) * HSIZE + (j/3)];
                            'd47:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_47[(i/3) * HSIZE + (j/3)];
                            'd48:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_48[(i/3) * HSIZE + (j/3)];
                            'd49:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_49[(i/3) * HSIZE + (j/3)];
                            'd50:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_50[(i/3) * HSIZE + (j/3)];
                            'd51:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_51[(i/3) * HSIZE + (j/3)];
                            'd52:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_52[(i/3) * HSIZE + (j/3)];
                            'd53:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_53[(i/3) * HSIZE + (j/3)];
                            'd54:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_54[(i/3) * HSIZE + (j/3)];
                            'd55:   data_in[((i - row) * 9 + (j - col)) + 40] <= mem_conv_expand_output_55[(i/3) * HSIZE + (j/3)];
                        endcase
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
                    for (row = 0; row < VSIZE * 3; row = row + 1) begin
                        for (col = 0; col < HSIZE * 3; col = col + 1) begin
                            for (channel_idx = 0; channel_idx < 56; channel_idx = channel_idx + 1) begin
                                CONV_LAST_DRIVE_INPUT_INTERNAL(channel_idx, row, col);
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

    task automatic CONV_LAST_DRIVE_WEIGHT_INTERNAL
    (
        input integer start
    );
        begin
            weight_in[0]    <= mem_conv_last_weight[start + 0]  ;
            weight_in[1]    <= mem_conv_last_weight[start + 1]  ;
            weight_in[2]    <= mem_conv_last_weight[start + 2]  ;
            weight_in[3]    <= mem_conv_last_weight[start + 3]  ;
            weight_in[4]    <= mem_conv_last_weight[start + 4]  ;
            weight_in[5]    <= mem_conv_last_weight[start + 5]  ;
            weight_in[6]    <= mem_conv_last_weight[start + 6]  ;
            weight_in[7]    <= mem_conv_last_weight[start + 7]  ;
            weight_in[8]    <= mem_conv_last_weight[start + 8]  ;
            weight_in[9]    <= mem_conv_last_weight[start + 9]  ;
            weight_in[10]   <= mem_conv_last_weight[start + 10] ;
            weight_in[11]   <= mem_conv_last_weight[start + 11] ;
            weight_in[12]   <= mem_conv_last_weight[start + 12] ;
            weight_in[13]   <= mem_conv_last_weight[start + 13] ;
            weight_in[14]   <= mem_conv_last_weight[start + 14] ;
            weight_in[15]   <= mem_conv_last_weight[start + 15] ;
            weight_in[16]   <= mem_conv_last_weight[start + 16] ;
            weight_in[17]   <= mem_conv_last_weight[start + 17] ;
            weight_in[18]   <= mem_conv_last_weight[start + 18] ;
            weight_in[19]   <= mem_conv_last_weight[start + 19] ;
            weight_in[20]   <= mem_conv_last_weight[start + 20] ;
            weight_in[21]   <= mem_conv_last_weight[start + 21] ;
            weight_in[22]   <= mem_conv_last_weight[start + 22] ;
            weight_in[23]   <= mem_conv_last_weight[start + 23] ;
            weight_in[24]   <= mem_conv_last_weight[start + 24] ;
            weight_in[25]   <= mem_conv_last_weight[start + 25] ;
            weight_in[26]   <= mem_conv_last_weight[start + 26] ;
            weight_in[27]   <= mem_conv_last_weight[start + 27] ;
            weight_in[28]   <= mem_conv_last_weight[start + 28] ;
            weight_in[29]   <= mem_conv_last_weight[start + 29] ;
            weight_in[30]   <= mem_conv_last_weight[start + 30] ;
            weight_in[31]   <= mem_conv_last_weight[start + 31] ;
            weight_in[32]   <= mem_conv_last_weight[start + 32] ;
            weight_in[33]   <= mem_conv_last_weight[start + 33] ;
            weight_in[34]   <= mem_conv_last_weight[start + 34] ;
            weight_in[35]   <= mem_conv_last_weight[start + 35] ;
            weight_in[36]   <= mem_conv_last_weight[start + 36] ;
            weight_in[37]   <= mem_conv_last_weight[start + 37] ;
            weight_in[38]   <= mem_conv_last_weight[start + 38] ;
            weight_in[39]   <= mem_conv_last_weight[start + 39] ;
            weight_in[40]   <= mem_conv_last_weight[start + 40] ;
            weight_in[41]   <= mem_conv_last_weight[start + 41] ;
            weight_in[42]   <= mem_conv_last_weight[start + 42] ;
            weight_in[43]   <= mem_conv_last_weight[start + 43] ;
            weight_in[44]   <= mem_conv_last_weight[start + 44] ;
            weight_in[45]   <= mem_conv_last_weight[start + 45] ;
            weight_in[46]   <= mem_conv_last_weight[start + 46] ;
            weight_in[47]   <= mem_conv_last_weight[start + 47] ;
            weight_in[48]   <= mem_conv_last_weight[start + 48] ;
            weight_in[49]   <= mem_conv_last_weight[start + 49] ;
            weight_in[50]   <= mem_conv_last_weight[start + 50] ;
            weight_in[51]   <= mem_conv_last_weight[start + 51] ;
            weight_in[52]   <= mem_conv_last_weight[start + 52] ;
            weight_in[53]   <= mem_conv_last_weight[start + 53] ;
            weight_in[54]   <= mem_conv_last_weight[start + 54] ;
            weight_in[55]   <= mem_conv_last_weight[start + 55] ;
            weight_in[56]   <= mem_conv_last_weight[start + 56] ;
            weight_in[57]   <= mem_conv_last_weight[start + 57] ;
            weight_in[58]   <= mem_conv_last_weight[start + 58] ;
            weight_in[59]   <= mem_conv_last_weight[start + 59] ;
            weight_in[60]   <= mem_conv_last_weight[start + 60] ;
            weight_in[61]   <= mem_conv_last_weight[start + 61] ;
            weight_in[62]   <= mem_conv_last_weight[start + 62] ;
            weight_in[63]   <= mem_conv_last_weight[start + 63] ;
            weight_in[64]   <= mem_conv_last_weight[start + 64] ;
            weight_in[65]   <= mem_conv_last_weight[start + 65] ;
            weight_in[66]   <= mem_conv_last_weight[start + 66] ;
            weight_in[67]   <= mem_conv_last_weight[start + 67] ;
            weight_in[68]   <= mem_conv_last_weight[start + 68] ;
            weight_in[69]   <= mem_conv_last_weight[start + 69] ;
            weight_in[70]   <= mem_conv_last_weight[start + 70] ;
            weight_in[71]   <= mem_conv_last_weight[start + 71] ;
            weight_in[72]   <= mem_conv_last_weight[start + 72] ;
            weight_in[73]   <= mem_conv_last_weight[start + 73] ;
            weight_in[74]   <= mem_conv_last_weight[start + 74] ;
            weight_in[75]   <= mem_conv_last_weight[start + 75] ;
            weight_in[76]   <= mem_conv_last_weight[start + 76] ;
            weight_in[77]   <= mem_conv_last_weight[start + 77] ;
            weight_in[78]   <= mem_conv_last_weight[start + 78] ;
            weight_in[79]   <= mem_conv_last_weight[start + 79] ;
            weight_in[80]   <= mem_conv_last_weight[start + 80] ;
            @(posedge clk);
        end
    endtask

    task automatic CONV_LAST_DRIVE_WEIGHT;
        integer row;
        integer col;
        integer start;
        integer i;
        begin
            fork
                begin
                    for (row = 0; row < VSIZE * 3; row = row + 1) begin
                        for (col = 0; col < HSIZE * 3; col = col + 1) begin
                            for (start = 0; start < 56; start = start + 1) begin
                                CONV_LAST_DRIVE_WEIGHT_INTERNAL(start * 81);
                            end
                        end
                    end
                end
                begin
                    for (i = 81; i < 108; i = i + 1) begin
                        weight_in[i] <= 'b0;
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
        begin
            fork
                CONV_LAST_DRIVE_INPUT;
                CONV_LAST_DRIVE_WEIGHT;
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

    task automatic CONV_LAST_WRITE_RESULT
    (
        input [31:0]    output_channel_idx
    );
        integer i;
        begin
            case (output_channel_idx)
                'd0     : $writememh("core_output_0.txt", mem_conv_last_output_0);
                'd1     : $writememh("core_output_1.txt", mem_conv_last_output_1);
                'd2     : $writememh("core_output_2.txt", mem_conv_last_output_2);
            endcase
        end
    endtask

	task TEST_CONV_LAST_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
            //CONV_LAST_READ_EXPANDING_GOLDEN;
            RESET_CNT_OUTPUT;
            CONV_LAST_READ_WEIGHT_BIAS_GOLDEN(channel);
            channel_idx <= channel;
            CONV_LAST_DRIVE;
            convolution_enable <= 1'b0;
            repeat (10) @(posedge clk);
            $display("[%m] Channel %0d finished!", channel);
            $display("[%m] Evaluating error in processing channel %0d...", channel);
            CONV_LAST_EVAL_ERROR(channel, cnt_output, 1.0);
            CONV_LAST_WRITE_RESULT(channel);
            repeat (5) @(posedge clk);
        end
	endtask

    task automatic TEST_CONV_LAST_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            //CONV_LAST_READ_EXPANDING_GOLDEN;
            for (i = 0; i < 3; i = i + 1) begin
                TEST_CONV_LAST_SINGLE_IMAGE_SINGLE_CHANNEL(i);
            end
            repeat (20) @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

`endif