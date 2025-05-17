module CORE_TB;

    // Assumption: Default input fixed point format = signed Q4.15
    parameter                                       Q_INT_INPUT         = 4         ;
    parameter                                       Q_FRAC_INPUT        = 15        ;

    // Assumption: Default weight fixed point format = signed Q8.0
    parameter                                       Q_INT_WEIGHT        = 8         ;
    parameter                                       Q_FRAC_WEIGHT       = 0         ;

    // Assumption: Default bias fixed point format = signed Q8.0
    parameter                                       Q_INT_BIAS          = 8         ;
    parameter                                       Q_FRAC_BIAS         = 0         ;

    // Assumption: Default slope fixed point format = signed Q8.0
    parameter                                       Q_INT_SLOPE         = 8         ;
    parameter                                       Q_FRAC_SLOPE        = 0         ;

    // Assumption: Default scale (after Conv2d) fixed point format = signed Q1.12
    parameter                                       Q_INT_SCALE_1       = 1       ;
    parameter                                       Q_FRAC_SCALE_1      = 12      ;

    // Assumption: Default scale (after PReLU) fixed point format = signed Q1.9
    parameter                                       Q_INT_SCALE_2       = 1       ;
    parameter                                       Q_FRAC_SCALE_2      = 9       ;

    // Assumption: Default dot prod result fixed point format = signed Q12.15
    parameter                                       Q_INT_INTERIM_1     = 12        ;
    parameter                                       Q_FRAC_INTERIM_1    = 15        ;

    // Assumption: Default adder tree result fixed point format = signed Q19.15
    parameter                                       Q_INT_INTERIM_2     = 19        ;
    parameter                                       Q_FRAC_INTERIM_2    = 15        ;

    // Assumption: Default conv2d result fixed point format = signed Q20.27
    parameter                                       Q_INT_INTERIM_3     = 20        ;
    parameter                                       Q_FRAC_INTERIM_3    = 27        ;

    // Assumption: Default PReLU result fixed point format = signed Q28.27
    parameter                                       Q_INT_INTERIM_4     = 28        ;
    parameter                                       Q_FRAC_INTERIM_4    = 27        ;

    // Assumption: Default output fixed point format = signed Q4.15
    parameter                                       Q_INT_OUTPUT        = 4         ;
    parameter                                       Q_FRAC_OUTPUT       = 15        ;

    parameter                                       HSIZE = 84                      ;
    parameter                                       VSIZE = 84                      ;

    parameter                                       mem_size = HSIZE * VSIZE        ;
    parameter                                       input_size = 108                ;

    `include "CORE_TB_TASKS_CONV_FIRST.vh"

    // -------------------------------------------------------------------------------

    reg                                             clk                             ;
    reg                                             rst_n                           ;
    reg                                             reset_cnt_output                ;
    reg                                             reset_channel_idx               ;

    // -------------------------------------------------------------------------------

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_weight  [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_bias    [0:0]               ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_slope   [0:0]               ;

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
    reg [2:0]                                       layer_bits                      ;
    reg                                             convolution_enable              ;

    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_golden  [0:mem_size-1]      ;

    // -------------------------------------------------------------------------------
    
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              data_in     [0:input_size-1]    ;
    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            weight_in   [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                bias_in                         ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              slope_in                        ;

    wire signed [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]    data_out                        ;
    wire                                            data_out_enable                 ;

    reg [31:0]                                      channel_idx                     ;
    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_output  [0:mem_size-1]      ;
    reg [31:0]                                      cnt_output                      ;

    // -------------------------------------------------------------------------------


    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    function is_padding
    (
        input integer HSIZE,
        input integer VSIZE,
        input integer row,
        input integer col
    );
        begin
            if (row < 0 || col < 0 || row >= VSIZE || col >= HSIZE) begin
                is_padding = 1'b1;
            end
            else begin
                is_padding = 1'b0;
            end
        end
    endfunction

    // -------------------------------------------------------------------------------
    // function definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task INIT;
        begin
            clk                 = 1'b0;
            rst_n               = 1'b1;
            reset_cnt_output    = 1'b0;
        end
    endtask

    task RESET;
        begin
            rst_n <= 1'b0;
            repeat (5) @(posedge clk);
            rst_n <= 1'b1;
            @(posedge clk);
        end
    endtask

    task RESET_CNT_OUTPUT;
        begin
            reset_cnt_output <= 1'b1;
            repeat (5) @(posedge clk);
            reset_cnt_output <= 1'b0;
            @(posedge clk);
        end
    endtask

    task DRIVE_BIAS;
        begin
            bias_in <= mem_bias[0];
            @(posedge clk);
        end
    endtask

    task DRIVE_SLOPE;
        begin
            slope_in <= mem_slope[0];
            @(posedge clk);
        end
    endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // test start
    // -------------------------------------------------------------------------------

    // clock generation
    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end

    // scenario of test
    initial begin
        INIT;
        repeat (5) @(posedge clk);
        RESET;
        RESET_CNT_OUTPUT;
        TEST_CONV_FIRST_SINGLE_IMAGE_SINGLE_CHANNEL(29);
        //TEST_CONV_FIRST_SINGLE_IMAGE_ALL_CHANNEL;
        $finish;
    end

    always @(posedge clk) begin
        if (reset_cnt_output) begin
            cnt_output <= 'b0;
        end
        else if (data_out_enable) begin
            cnt_output <= cnt_output + 1;
            mem_output[cnt_output] <= data_out;
        end
    end

    always @(posedge clk) begin
        if (layer_bits == 3'd0 && data_out_enable) begin
            case(channel_idx)
                'd0     : mem_conv_first_output_0[cnt_output]   <= data_out;
                'd1     : mem_conv_first_output_1[cnt_output]   <= data_out;
                'd2     : mem_conv_first_output_2[cnt_output]   <= data_out;
                'd3     : mem_conv_first_output_3[cnt_output]   <= data_out;
                'd4     : mem_conv_first_output_4[cnt_output]   <= data_out;
                'd5     : mem_conv_first_output_5[cnt_output]   <= data_out;
                'd6     : mem_conv_first_output_6[cnt_output]   <= data_out;
                'd7     : mem_conv_first_output_7[cnt_output]   <= data_out;
                'd8     : mem_conv_first_output_8[cnt_output]   <= data_out;
                'd9     : mem_conv_first_output_9[cnt_output]   <= data_out;
                'd10    : mem_conv_first_output_10[cnt_output]  <= data_out;
                'd11    : mem_conv_first_output_11[cnt_output]  <= data_out;
                'd12    : mem_conv_first_output_12[cnt_output]  <= data_out;
                'd13    : mem_conv_first_output_13[cnt_output]  <= data_out;
                'd14    : mem_conv_first_output_14[cnt_output]  <= data_out;
                'd15    : mem_conv_first_output_15[cnt_output]  <= data_out;
                'd16    : mem_conv_first_output_16[cnt_output]  <= data_out;
                'd17    : mem_conv_first_output_17[cnt_output]  <= data_out;
                'd18    : mem_conv_first_output_18[cnt_output]  <= data_out;
                'd19    : mem_conv_first_output_19[cnt_output]  <= data_out;
                'd20    : mem_conv_first_output_20[cnt_output]  <= data_out;
                'd21    : mem_conv_first_output_21[cnt_output]  <= data_out;
                'd22    : mem_conv_first_output_22[cnt_output]  <= data_out;
                'd23    : mem_conv_first_output_23[cnt_output]  <= data_out;
                'd24    : mem_conv_first_output_24[cnt_output]  <= data_out;
                'd25    : mem_conv_first_output_25[cnt_output]  <= data_out;
                'd26    : mem_conv_first_output_26[cnt_output]  <= data_out;
                'd27    : mem_conv_first_output_27[cnt_output]  <= data_out;
                'd28    : mem_conv_first_output_28[cnt_output]  <= data_out;
                'd29    : mem_conv_first_output_29[cnt_output]  <= data_out;
                'd30    : mem_conv_first_output_30[cnt_output]  <= data_out;
                'd31    : mem_conv_first_output_31[cnt_output]  <= data_out;
                'd32    : mem_conv_first_output_32[cnt_output]  <= data_out;
                'd33    : mem_conv_first_output_33[cnt_output]  <= data_out;
                'd34    : mem_conv_first_output_34[cnt_output]  <= data_out;
                'd35    : mem_conv_first_output_35[cnt_output]  <= data_out;
                'd36    : mem_conv_first_output_36[cnt_output]  <= data_out;
                'd37    : mem_conv_first_output_37[cnt_output]  <= data_out;
                'd38    : mem_conv_first_output_38[cnt_output]  <= data_out;
                'd39    : mem_conv_first_output_39[cnt_output]  <= data_out;
                'd40    : mem_conv_first_output_40[cnt_output]  <= data_out;
                'd41    : mem_conv_first_output_41[cnt_output]  <= data_out;
                'd42    : mem_conv_first_output_42[cnt_output]  <= data_out;
                'd43    : mem_conv_first_output_43[cnt_output]  <= data_out;
                'd44    : mem_conv_first_output_44[cnt_output]  <= data_out;
                'd45    : mem_conv_first_output_45[cnt_output]  <= data_out;
                'd46    : mem_conv_first_output_46[cnt_output]  <= data_out;
                'd47    : mem_conv_first_output_47[cnt_output]  <= data_out;
                'd48    : mem_conv_first_output_48[cnt_output]  <= data_out;
                'd49    : mem_conv_first_output_49[cnt_output]  <= data_out;
                'd50    : mem_conv_first_output_50[cnt_output]  <= data_out;
                'd51    : mem_conv_first_output_51[cnt_output]  <= data_out;
                'd52    : mem_conv_first_output_52[cnt_output]  <= data_out;
                'd53    : mem_conv_first_output_53[cnt_output]  <= data_out;
                'd54    : mem_conv_first_output_54[cnt_output]  <= data_out;
                'd55    : mem_conv_first_output_55[cnt_output]  <= data_out;
            endcase
        end
    end

    // -------------------------------------------------------------------------------
    // test finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    CORE
    #(
        .Q_INT_INPUT                            (Q_INT_INPUT                ),
        .Q_FRAC_INPUT                           (Q_FRAC_INPUT               ),
        .Q_INT_WEIGHT                           (Q_INT_WEIGHT               ),
        .Q_FRAC_WEIGHT                          (Q_FRAC_WEIGHT              ),
        .Q_INT_BIAS                             (Q_INT_BIAS                 ),
        .Q_FRAC_BIAS                            (Q_FRAC_BIAS                ),
        .Q_INT_SLOPE                            (Q_INT_SLOPE                ),
        .Q_FRAC_SLOPE                           (Q_FRAC_SLOPE               ),
        .Q_INT_SCALE_1                          (Q_INT_SCALE_1              ),
        .Q_FRAC_SCALE_1                         (Q_FRAC_SCALE_1             ),
        .Q_INT_SCALE_2                          (Q_INT_SCALE_2              ),
        .Q_FRAC_SCALE_2                         (Q_FRAC_SCALE_2             ),
        .Q_INT_INTERIM_1                        (Q_INT_INTERIM_1            ),
        .Q_FRAC_INTERIM_1                       (Q_FRAC_INTERIM_1           ),
        .Q_INT_INTERIM_2                        (Q_INT_INTERIM_2            ),
        .Q_FRAC_INTERIM_2                       (Q_FRAC_INTERIM_2           ),
        .Q_INT_INTERIM_3                        (Q_INT_INTERIM_3            ),
        .Q_FRAC_INTERIM_3                       (Q_FRAC_INTERIM_3           ),
        .Q_INT_INTERIM_4                        (Q_INT_INTERIM_4            ),
        .Q_FRAC_INTERIM_4                       (Q_FRAC_INTERIM_4           ),
        .Q_INT_OUTPUT                           (Q_INT_OUTPUT               ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_OUTPUT              )
    )
    DUT_TOP
    (
        .clk                                    (clk                    ),
        .rst_n                                  (rst_n                  ),

        .layer_bits                             (layer_bits             ),
        .convolution_enable                     (convolution_enable     ),

        .data_in_0                              (data_in[0 ]            ),
        .data_in_1                              (data_in[1 ]            ),
        .data_in_2                              (data_in[2 ]            ),
        .data_in_3                              (data_in[3 ]            ),
        .data_in_4                              (data_in[4 ]            ),
        .data_in_5                              (data_in[5 ]            ),
        .data_in_6                              (data_in[6 ]            ),
        .data_in_7                              (data_in[7 ]            ),
        .data_in_8                              (data_in[8 ]            ),
        .data_in_9                              (data_in[9 ]            ),
        .data_in_10                             (data_in[10]            ),
        .data_in_11                             (data_in[11]            ),
        .data_in_12                             (data_in[12]            ),
        .data_in_13                             (data_in[13]            ),
        .data_in_14                             (data_in[14]            ),
        .data_in_15                             (data_in[15]            ),
        .data_in_16                             (data_in[16]            ),
        .data_in_17                             (data_in[17]            ),
        .data_in_18                             (data_in[18]            ),
        .data_in_19                             (data_in[19]            ),
        .data_in_20                             (data_in[20]            ),
        .data_in_21                             (data_in[21]            ),
        .data_in_22                             (data_in[22]            ),
        .data_in_23                             (data_in[23]            ),
        .data_in_24                             (data_in[24]            ),
        .data_in_25                             (data_in[25]            ),
        .data_in_26                             (data_in[26]            ),
        .data_in_27                             (data_in[27]            ),
        .data_in_28                             (data_in[28]            ),
        .data_in_29                             (data_in[29]            ),
        .data_in_30                             (data_in[30]            ),
        .data_in_31                             (data_in[31]            ),
        .data_in_32                             (data_in[32]            ),
        .data_in_33                             (data_in[33]            ),
        .data_in_34                             (data_in[34]            ),
        .data_in_35                             (data_in[35]            ),
        .data_in_36                             (data_in[36]            ),
        .data_in_37                             (data_in[37]            ),
        .data_in_38                             (data_in[38]            ),
        .data_in_39                             (data_in[39]            ),
        .data_in_40                             (data_in[40]            ),
        .data_in_41                             (data_in[41]            ),
        .data_in_42                             (data_in[42]            ),
        .data_in_43                             (data_in[43]            ),
        .data_in_44                             (data_in[44]            ),
        .data_in_45                             (data_in[45]            ),
        .data_in_46                             (data_in[46]            ),
        .data_in_47                             (data_in[47]            ),
        .data_in_48                             (data_in[48]            ),
        .data_in_49                             (data_in[49]            ),
        .data_in_50                             (data_in[50]            ),
        .data_in_51                             (data_in[51]            ),
        .data_in_52                             (data_in[52]            ),
        .data_in_53                             (data_in[53]            ),
        .data_in_54                             (data_in[54]            ),
        .data_in_55                             (data_in[55]            ),
        .data_in_56                             (data_in[56]            ),
        .data_in_57                             (data_in[57]            ),
        .data_in_58                             (data_in[58]            ),
        .data_in_59                             (data_in[59]            ),
        .data_in_60                             (data_in[60]            ),
        .data_in_61                             (data_in[61]            ),
        .data_in_62                             (data_in[62]            ),
        .data_in_63                             (data_in[63]            ),
        .data_in_64                             (data_in[64]            ),
        .data_in_65                             (data_in[65]            ),
        .data_in_66                             (data_in[66]            ),
        .data_in_67                             (data_in[67]            ),
        .data_in_68                             (data_in[68]            ),
        .data_in_69                             (data_in[69]            ),
        .data_in_70                             (data_in[70]            ),
        .data_in_71                             (data_in[71]            ),
        .data_in_72                             (data_in[72]            ),
        .data_in_73                             (data_in[73]            ),
        .data_in_74                             (data_in[74]            ),
        .data_in_75                             (data_in[75]            ),
        .data_in_76                             (data_in[76]            ),
        .data_in_77                             (data_in[77]            ),
        .data_in_78                             (data_in[78]            ),
        .data_in_79                             (data_in[79]            ),
        .data_in_80                             (data_in[80]            ),
        .data_in_81                             (data_in[81]            ),
        .data_in_82                             (data_in[82]            ),
        .data_in_83                             (data_in[83]            ),
        .data_in_84                             (data_in[84]            ),
        .data_in_85                             (data_in[85]            ),
        .data_in_86                             (data_in[86]            ),
        .data_in_87                             (data_in[87]            ),
        .data_in_88                             (data_in[88]            ),
        .data_in_89                             (data_in[89]            ),
        .data_in_90                             (data_in[90]            ),
        .data_in_91                             (data_in[91]            ),
        .data_in_92                             (data_in[92]            ),
        .data_in_93                             (data_in[93]            ),
        .data_in_94                             (data_in[94]            ),
        .data_in_95                             (data_in[95]            ),
        .data_in_96                             (data_in[96]            ),
        .data_in_97                             (data_in[97]            ),
        .data_in_98                             (data_in[98]            ),
        .data_in_99                             (data_in[99]            ),
        .data_in_100                            (data_in[100]           ),
        .data_in_101                            (data_in[101]           ),
        .data_in_102                            (data_in[102]           ),
        .data_in_103                            (data_in[103]           ),
        .data_in_104                            (data_in[104]           ),
        .data_in_105                            (data_in[105]           ),
        .data_in_106                            (data_in[106]           ),
        .data_in_107                            (data_in[107]           ),

        .weight_in_0                            (weight_in[0 ]          ),
        .weight_in_1                            (weight_in[1 ]          ),
        .weight_in_2                            (weight_in[2 ]          ),
        .weight_in_3                            (weight_in[3 ]          ),
        .weight_in_4                            (weight_in[4 ]          ),
        .weight_in_5                            (weight_in[5 ]          ),
        .weight_in_6                            (weight_in[6 ]          ),
        .weight_in_7                            (weight_in[7 ]          ),
        .weight_in_8                            (weight_in[8 ]          ),
        .weight_in_9                            (weight_in[9 ]          ),
        .weight_in_10                           (weight_in[10]          ),
        .weight_in_11                           (weight_in[11]          ),
        .weight_in_12                           (weight_in[12]          ),
        .weight_in_13                           (weight_in[13]          ),
        .weight_in_14                           (weight_in[14]          ),
        .weight_in_15                           (weight_in[15]          ),
        .weight_in_16                           (weight_in[16]          ),
        .weight_in_17                           (weight_in[17]          ),
        .weight_in_18                           (weight_in[18]          ),
        .weight_in_19                           (weight_in[19]          ),
        .weight_in_20                           (weight_in[20]          ),
        .weight_in_21                           (weight_in[21]          ),
        .weight_in_22                           (weight_in[22]          ),
        .weight_in_23                           (weight_in[23]          ),
        .weight_in_24                           (weight_in[24]          ),
        .weight_in_25                           (weight_in[25]          ),
        .weight_in_26                           (weight_in[26]          ),
        .weight_in_27                           (weight_in[27]          ),
        .weight_in_28                           (weight_in[28]          ),
        .weight_in_29                           (weight_in[29]          ),
        .weight_in_30                           (weight_in[30]          ),
        .weight_in_31                           (weight_in[31]          ),
        .weight_in_32                           (weight_in[32]          ),
        .weight_in_33                           (weight_in[33]          ),
        .weight_in_34                           (weight_in[34]          ),
        .weight_in_35                           (weight_in[35]          ),
        .weight_in_36                           (weight_in[36]          ),
        .weight_in_37                           (weight_in[37]          ),
        .weight_in_38                           (weight_in[38]          ),
        .weight_in_39                           (weight_in[39]          ),
        .weight_in_40                           (weight_in[40]          ),
        .weight_in_41                           (weight_in[41]          ),
        .weight_in_42                           (weight_in[42]          ),
        .weight_in_43                           (weight_in[43]          ),
        .weight_in_44                           (weight_in[44]          ),
        .weight_in_45                           (weight_in[45]          ),
        .weight_in_46                           (weight_in[46]          ),
        .weight_in_47                           (weight_in[47]          ),
        .weight_in_48                           (weight_in[48]          ),
        .weight_in_49                           (weight_in[49]          ),
        .weight_in_50                           (weight_in[50]          ),
        .weight_in_51                           (weight_in[51]          ),
        .weight_in_52                           (weight_in[52]          ),
        .weight_in_53                           (weight_in[53]          ),
        .weight_in_54                           (weight_in[54]          ),
        .weight_in_55                           (weight_in[55]          ),
        .weight_in_56                           (weight_in[56]          ),
        .weight_in_57                           (weight_in[57]          ),
        .weight_in_58                           (weight_in[58]          ),
        .weight_in_59                           (weight_in[59]          ),
        .weight_in_60                           (weight_in[60]          ),
        .weight_in_61                           (weight_in[61]          ),
        .weight_in_62                           (weight_in[62]          ),
        .weight_in_63                           (weight_in[63]          ),
        .weight_in_64                           (weight_in[64]          ),
        .weight_in_65                           (weight_in[65]          ),
        .weight_in_66                           (weight_in[66]          ),
        .weight_in_67                           (weight_in[67]          ),
        .weight_in_68                           (weight_in[68]          ),
        .weight_in_69                           (weight_in[69]          ),
        .weight_in_70                           (weight_in[70]          ),
        .weight_in_71                           (weight_in[71]          ),
        .weight_in_72                           (weight_in[72]          ),
        .weight_in_73                           (weight_in[73]          ),
        .weight_in_74                           (weight_in[74]          ),
        .weight_in_75                           (weight_in[75]          ),
        .weight_in_76                           (weight_in[76]          ),
        .weight_in_77                           (weight_in[77]          ),
        .weight_in_78                           (weight_in[78]          ),
        .weight_in_79                           (weight_in[79]          ),
        .weight_in_80                           (weight_in[80]          ),
        .weight_in_81                           (weight_in[81]          ),
        .weight_in_82                           (weight_in[82]          ),
        .weight_in_83                           (weight_in[83]          ),
        .weight_in_84                           (weight_in[84]          ),
        .weight_in_85                           (weight_in[85]          ),
        .weight_in_86                           (weight_in[86]          ),
        .weight_in_87                           (weight_in[87]          ),
        .weight_in_88                           (weight_in[88]          ),
        .weight_in_89                           (weight_in[89]          ),
        .weight_in_90                           (weight_in[90]          ),
        .weight_in_91                           (weight_in[91]          ),
        .weight_in_92                           (weight_in[92]          ),
        .weight_in_93                           (weight_in[93]          ),
        .weight_in_94                           (weight_in[94]          ),
        .weight_in_95                           (weight_in[95]          ),
        .weight_in_96                           (weight_in[96]          ),
        .weight_in_97                           (weight_in[97]          ),
        .weight_in_98                           (weight_in[98]          ),
        .weight_in_99                           (weight_in[99]          ),
        .weight_in_100                          (weight_in[100]         ),
        .weight_in_101                          (weight_in[101]         ),
        .weight_in_102                          (weight_in[102]         ),
        .weight_in_103                          (weight_in[103]         ),
        .weight_in_104                          (weight_in[104]         ),
        .weight_in_105                          (weight_in[105]         ),
        .weight_in_106                          (weight_in[106]         ),
        .weight_in_107                          (weight_in[107]         ),

        .bias_in                                (bias_in                ),
        .slope_in                               (slope_in               ),
    
        .data_out                               (data_out               ),
        .data_out_enable                        (data_out_enable        )
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule