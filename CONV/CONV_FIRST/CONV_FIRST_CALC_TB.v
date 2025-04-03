module CONV_FIRST_CALC_TB;

    parameter Q_INT = 1                                 ;
    parameter Q_FRAC = 15                               ;

    parameter mem_size = 75                             ;

    reg clk                                             ;
    reg rst_n                                           ;

    reg [Q_INT+Q_FRAC-1:0] mem_data     [0:mem_size-1]  ;
    reg [Q_INT+Q_FRAC-1:0] mem_weight   [0:mem_size-1]  ;
    reg [Q_INT+Q_FRAC-1:0] mem_bias                     ;

    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    function INIT;
        begin
            clk = 1'b0;
            rst = 1'b1;
        end
    endfunction

    function READFILE;
        begin
            $readmemh();
        end
    endfunction

    function EVAL_ERROR;
    endfunction

    // -------------------------------------------------------------------------------
    // function definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task RESET;
        begin
            rst_n <= 1'b0;
            repeat (5) @(posedge clk);
            rst_n <= 1'b1;
        end
    endtask

    task INPUT;
    endtask

    task MONITOR;
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
        INIT();
        RESET();
        READFILE();
        INPUT();
        MONITOR();
        EVAL_ERROR();
    end

    // -------------------------------------------------------------------------------
    // test finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    CONV_FIRST_DOT_PRODUCT
    #(
        .Q_INT                                  (Q_INT                  ),
        .Q_FRAC                                 (Q_FRAC                 )
    )
    conv_first_dot_product_inst
    (
        .clk                                    (clk                    ),
        .rst_n                                  (rst_n                  ),

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

        .bias_in                                (bias_in                ),
    
        .data_out                               (data_out               ),
        .data_out_enable                        (data_out_enable        )
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule