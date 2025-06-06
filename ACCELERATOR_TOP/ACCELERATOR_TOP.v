module ACCELERATOR_TOP
(
    input           clk,
    input           rst_n,
    input           interrupt
);

    // Assumption: Default weight fixed point format = signed Q8.0
    parameter                                       Q_INT_WEIGHT        = 8         ;
    parameter                                       Q_FRAC_WEIGHT       = 0         ;

    // Assumption: Default bias fixed point format = signed Q8.0
    parameter                                       Q_INT_BIAS          = 8         ;
    parameter                                       Q_FRAC_BIAS         = 0         ;

    // Assumption: Default slope fixed point format = signed Q8.0
    parameter                                       Q_INT_SLOPE         = 8         ;
    parameter                                       Q_FRAC_SLOPE        = 0         ;

    reg             clken;
    wire            clk_disable;

    wire            PARAMETER_valid;
    wire [2:0]      PARAMETER_layer;
    wire [1:0]      PARAMETER_type;
    wire [31:0]     PARAMETER;

    wire            PIXEL_valid;
    wire            PIXEL_first;
    wire            PIXEL_last;
    wire            PIXEL_lastline;
    wire [39:0]     PIXEL_R;
    wire [39:0]     PIXEL_G;
    wire [39:0]     PIXEL_B;

    always @(posedge clk) begin
        if (!rst_n) begin
            clken <= 1'b1;
        end
        else if (clk_disable) begin
            clken <= 1'b0;
        end
        else if(outside_signal) begin
            clken <= 1'b1;
        end
    end

    reg outside_signal;
    initial begin
        repeat (5) @(posedge clk);
        repeat (5) @(posedge clk);
        repeat (1) @(posedge clk);
        repeat (10) @(posedge clk);
        repeat (8200) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (200) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
       repeat (400) @(posedge clk);
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);
        repeat (5000) @(posedge clk);
    end

    FETCHER_TOP
    fetcher_top_inst
    (
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .interrupt          (interrupt          ),

        .clken              (clken              ),
        .clk_disable        (clk_disable        ),

        .PARAMETER_valid    (PARAMETER_valid    ),
        .PARAMETER_layer    (PARAMETER_layer    ),
        .PARAMETER_type     (PARAMETER_type     ),
        .PARAMETER          (PARAMETER          ),

        .PIXEL_valid        (PIXEL_valid        ),
        .PIXEL_first        (PIXEL_first        ),
        .PIXEL_last         (PIXEL_last         ),
        .PIXEL_lastline     (PIXEL_lastline     ),
        .PIXEL_R            (PIXEL_R            ),
        .PIXEL_G            (PIXEL_G            ),
        .PIXEL_B            (PIXEL_B            )
    );

    wire [7:0] weight_in [0:107];
    wire [7:0] bias_in;
    wire [7:0] slope_in;

    PARAM_LOADER
    #(
        .Q_INT_WEIGHT       (Q_INT_WEIGHT       ),
        .Q_FRAC_WEIGHT      (Q_FRAC_WEIGHT      ),
        .Q_INT_BIAS         (Q_INT_BIAS         ),
        .Q_FRAC_BIAS        (Q_FRAC_BIAS        ),
        .Q_INT_SLOPE        (Q_INT_SLOPE        ),
        .Q_FRAC_SLOPE       (Q_FRAC_SLOPE       )
    )
    param_loader_inst
    (
        .clk                (clk                ),
        .rst_n              (rst_n              ),

        .PARAMETER_valid    (PARAMETER_valid    ),
        .PARAMETER_layer    (PARAMETER_layer    ),
        .PARAMETER_type     (PARAMETER_type     ),
        .PARAMETER          (PARAMETER          ),

        .weight_in_0        (weight_in[0 ]      ),
        .weight_in_1        (weight_in[1 ]      ),
        .weight_in_2        (weight_in[2 ]      ),
        .weight_in_3        (weight_in[3 ]      ),
        .weight_in_4        (weight_in[4 ]      ),
        .weight_in_5        (weight_in[5 ]      ),
        .weight_in_6        (weight_in[6 ]      ),
        .weight_in_7        (weight_in[7 ]      ),
        .weight_in_8        (weight_in[8 ]      ),
        .weight_in_9        (weight_in[9 ]      ),
        .weight_in_10       (weight_in[10]      ),
        .weight_in_11       (weight_in[11]      ),
        .weight_in_12       (weight_in[12]      ),
        .weight_in_13       (weight_in[13]      ),
        .weight_in_14       (weight_in[14]      ),
        .weight_in_15       (weight_in[15]      ),
        .weight_in_16       (weight_in[16]      ),
        .weight_in_17       (weight_in[17]      ),
        .weight_in_18       (weight_in[18]      ),
        .weight_in_19       (weight_in[19]      ),
        .weight_in_20       (weight_in[20]      ),
        .weight_in_21       (weight_in[21]      ),
        .weight_in_22       (weight_in[22]      ),
        .weight_in_23       (weight_in[23]      ),
        .weight_in_24       (weight_in[24]      ),
        .weight_in_25       (weight_in[25]      ),
        .weight_in_26       (weight_in[26]      ),
        .weight_in_27       (weight_in[27]      ),
        .weight_in_28       (weight_in[28]      ),
        .weight_in_29       (weight_in[29]      ),
        .weight_in_30       (weight_in[30]      ),
        .weight_in_31       (weight_in[31]      ),
        .weight_in_32       (weight_in[32]      ),
        .weight_in_33       (weight_in[33]      ),
        .weight_in_34       (weight_in[34]      ),
        .weight_in_35       (weight_in[35]      ),
        .weight_in_36       (weight_in[36]      ),
        .weight_in_37       (weight_in[37]      ),
        .weight_in_38       (weight_in[38]      ),
        .weight_in_39       (weight_in[39]      ),
        .weight_in_40       (weight_in[40]      ),
        .weight_in_41       (weight_in[41]      ),
        .weight_in_42       (weight_in[42]      ),
        .weight_in_43       (weight_in[43]      ),
        .weight_in_44       (weight_in[44]      ),
        .weight_in_45       (weight_in[45]      ),
        .weight_in_46       (weight_in[46]      ),
        .weight_in_47       (weight_in[47]      ),
        .weight_in_48       (weight_in[48]      ),
        .weight_in_49       (weight_in[49]      ),
        .weight_in_50       (weight_in[50]      ),
        .weight_in_51       (weight_in[51]      ),
        .weight_in_52       (weight_in[52]      ),
        .weight_in_53       (weight_in[53]      ),
        .weight_in_54       (weight_in[54]      ),
        .weight_in_55       (weight_in[55]      ),
        .weight_in_56       (weight_in[56]      ),
        .weight_in_57       (weight_in[57]      ),
        .weight_in_58       (weight_in[58]      ),
        .weight_in_59       (weight_in[59]      ),
        .weight_in_60       (weight_in[60]      ),
        .weight_in_61       (weight_in[61]      ),
        .weight_in_62       (weight_in[62]      ),
        .weight_in_63       (weight_in[63]      ),
        .weight_in_64       (weight_in[64]      ),
        .weight_in_65       (weight_in[65]      ),
        .weight_in_66       (weight_in[66]      ),
        .weight_in_67       (weight_in[67]      ),
        .weight_in_68       (weight_in[68]      ),
        .weight_in_69       (weight_in[69]      ),
        .weight_in_70       (weight_in[70]      ),
        .weight_in_71       (weight_in[71]      ),
        .weight_in_72       (weight_in[72]      ),
        .weight_in_73       (weight_in[73]      ),
        .weight_in_74       (weight_in[74]      ),
        .weight_in_75       (weight_in[75]      ),
        .weight_in_76       (weight_in[76]      ),
        .weight_in_77       (weight_in[77]      ),
        .weight_in_78       (weight_in[78]      ),
        .weight_in_79       (weight_in[79]      ),
        .weight_in_80       (weight_in[80]      ),
        .weight_in_81       (weight_in[81]      ),
        .weight_in_82       (weight_in[82]      ),
        .weight_in_83       (weight_in[83]      ),
        .weight_in_84       (weight_in[84]      ),
        .weight_in_85       (weight_in[85]      ),
        .weight_in_86       (weight_in[86]      ),
        .weight_in_87       (weight_in[87]      ),
        .weight_in_88       (weight_in[88]      ),
        .weight_in_89       (weight_in[89]      ),
        .weight_in_90       (weight_in[90]      ),
        .weight_in_91       (weight_in[91]      ),
        .weight_in_92       (weight_in[92]      ),
        .weight_in_93       (weight_in[93]      ),
        .weight_in_94       (weight_in[94]      ),
        .weight_in_95       (weight_in[95]      ),
        .weight_in_96       (weight_in[96]      ),
        .weight_in_97       (weight_in[97]      ),
        .weight_in_98       (weight_in[98]      ),
        .weight_in_99       (weight_in[99]      ),
        .weight_in_100      (weight_in[100]     ),
        .weight_in_101      (weight_in[101]     ),
        .weight_in_102      (weight_in[102]     ),
        .weight_in_103      (weight_in[103]     ),
        .weight_in_104      (weight_in[104]     ),
        .weight_in_105      (weight_in[105]     ),
        .weight_in_106      (weight_in[106]     ),
        .weight_in_107      (weight_in[107]     ),

        .bias_in            (bias_in            ),
        .slope_in           (slope_in           )
    );

    CORE_TB core_tb_inst();

    //BRAM_CONTROLLER
    //bram_controller_inst
    //(
        //.PIXEL_valid        (PIXEL_valid        ),
        //.PIXEL_first        (PIXEL_first        ),
        //.PIXEL_last         (PIXEL_last         ),
        //.PIXEL_lastline     (PIXEL_lastline     ),
        //.PIXEL_R            (PIXEL_R            ),
        //.PIXEL_G            (PIXEL_G            ),
        //.PIXEL_B            (PIXEL_B            )
    //);

endmodule