module CONV_FIRST_ADDER_TREE
#(
    // Assumption: Default fixed point format = signed Q1.15
    parameter                                       Q_INT           = 1                         ,
    parameter                                       Q_FRAC          = 15
)
(
    input                                           clk                                         ,
    input                                           rst_n                                       ,
    input                                           adder_tree_middle_stage_enable              ,

    // By assumption, each addend has signed Q2.30
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_0                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_1                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_2                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_3                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_4                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_5                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_6                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_7                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_8                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_9                                    ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_10                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_11                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_12                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_13                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_14                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_15                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_16                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_17                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_18                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_19                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_20                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_21                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_22                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_23                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_24                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_25                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_26                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_27                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_28                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_29                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_30                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_31                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_32                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_33                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_34                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_35                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_36                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_37                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_38                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_39                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_40                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_41                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_42                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_43                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_44                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_45                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_46                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_47                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_48                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_49                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_50                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_51                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_52                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_53                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_54                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_55                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_56                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_57                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_58                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_59                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_60                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_61                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_62                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_63                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_64                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_65                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_66                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_67                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_68                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_69                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_70                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_71                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_72                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_73                                   ,
    input signed [2 * (Q_INT + Q_FRAC) - 1:0]       addend_74                                   ,
    input signed [Q_INT + Q_FRAC - 1:0]             bias                                        ,

    output reg signed [Q_INT + Q_FRAC - 1:0]        adder_tree_result                           ,
    output reg                                      adder_tree_result_enable
);

    localparam                                      width_stage_1   = 2 * (Q_INT + Q_FRAC) + 1  ;
    localparam                                      width_stage_2   = width_stage_1 + 1         ;
    localparam                                      width_stage_3   = width_stage_2 + 1         ;
    localparam                                      width_stage_4   = width_stage_3 + 1         ;
    localparam                                      width_stage_5   = width_stage_4 + 1         ;
    localparam                                      width_stage_6   = width_stage_5 + 1         ;
    localparam                                      width_stage_7   = width_stage_6 + 1         ;

    // -------------------------------------------------------------------------------
    // stage 1 start
    // operand  : signed Q2.30 -> signed Q3.30 (for preventing arithmetic overflow)
    // result   : signed Q3.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_1 - 1:0]               stage_1_operand [0:75]                      ;
    wire signed [width_stage_1 - 1:0]               stage_1_result  [0:37]                      ; // 76 = 38 * 2

    assign stage_1_operand[0]       = addend_0                                                  ;
    assign stage_1_operand[1]       = addend_1                                                  ;
    assign stage_1_operand[2]       = addend_2                                                  ;
    assign stage_1_operand[3]       = addend_3                                                  ;
    assign stage_1_operand[4]       = addend_4                                                  ;
    assign stage_1_operand[5]       = addend_5                                                  ;
    assign stage_1_operand[6]       = addend_6                                                  ;
    assign stage_1_operand[7]       = addend_7                                                  ;
    assign stage_1_operand[8]       = addend_8                                                  ;
    assign stage_1_operand[9]       = addend_9                                                  ;
    assign stage_1_operand[10]      = addend_10                                                 ;
    assign stage_1_operand[11]      = addend_11                                                 ;
    assign stage_1_operand[12]      = addend_12                                                 ;
    assign stage_1_operand[13]      = addend_13                                                 ;
    assign stage_1_operand[14]      = addend_14                                                 ;
    assign stage_1_operand[15]      = addend_15                                                 ;
    assign stage_1_operand[16]      = addend_16                                                 ;
    assign stage_1_operand[17]      = addend_17                                                 ;
    assign stage_1_operand[18]      = addend_18                                                 ;
    assign stage_1_operand[19]      = addend_19                                                 ;
    assign stage_1_operand[20]      = addend_20                                                 ;
    assign stage_1_operand[21]      = addend_21                                                 ;
    assign stage_1_operand[22]      = addend_22                                                 ;
    assign stage_1_operand[23]      = addend_23                                                 ;
    assign stage_1_operand[24]      = addend_24                                                 ;
    assign stage_1_operand[25]      = addend_25                                                 ;
    assign stage_1_operand[26]      = addend_26                                                 ;
    assign stage_1_operand[27]      = addend_27                                                 ;
    assign stage_1_operand[28]      = addend_28                                                 ;
    assign stage_1_operand[29]      = addend_29                                                 ;
    assign stage_1_operand[30]      = addend_30                                                 ;
    assign stage_1_operand[31]      = addend_31                                                 ;
    assign stage_1_operand[32]      = addend_32                                                 ;
    assign stage_1_operand[33]      = addend_33                                                 ;
    assign stage_1_operand[34]      = addend_34                                                 ;
    assign stage_1_operand[35]      = addend_35                                                 ;
    assign stage_1_operand[36]      = addend_36                                                 ;
    assign stage_1_operand[37]      = addend_37                                                 ;
    assign stage_1_operand[38]      = addend_38                                                 ;
    assign stage_1_operand[39]      = addend_39                                                 ;
    assign stage_1_operand[40]      = addend_40                                                 ;
    assign stage_1_operand[41]      = addend_41                                                 ;
    assign stage_1_operand[42]      = addend_42                                                 ;
    assign stage_1_operand[43]      = addend_43                                                 ;
    assign stage_1_operand[44]      = addend_44                                                 ;
    assign stage_1_operand[45]      = addend_45                                                 ;
    assign stage_1_operand[46]      = addend_46                                                 ;
    assign stage_1_operand[47]      = addend_47                                                 ;
    assign stage_1_operand[48]      = addend_48                                                 ;
    assign stage_1_operand[49]      = addend_49                                                 ;
    assign stage_1_operand[50]      = addend_50                                                 ;
    assign stage_1_operand[51]      = addend_51                                                 ;
    assign stage_1_operand[52]      = addend_52                                                 ;
    assign stage_1_operand[53]      = addend_53                                                 ;
    assign stage_1_operand[54]      = addend_54                                                 ;
    assign stage_1_operand[55]      = addend_55                                                 ;
    assign stage_1_operand[56]      = addend_56                                                 ;
    assign stage_1_operand[57]      = addend_57                                                 ;
    assign stage_1_operand[58]      = addend_58                                                 ;
    assign stage_1_operand[59]      = addend_59                                                 ;
    assign stage_1_operand[60]      = addend_60                                                 ;
    assign stage_1_operand[61]      = addend_61                                                 ;
    assign stage_1_operand[62]      = addend_62                                                 ;
    assign stage_1_operand[63]      = addend_63                                                 ;
    assign stage_1_operand[64]      = addend_64                                                 ;
    assign stage_1_operand[65]      = addend_65                                                 ;
    assign stage_1_operand[66]      = addend_66                                                 ;
    assign stage_1_operand[67]      = addend_67                                                 ;
    assign stage_1_operand[68]      = addend_68                                                 ;
    assign stage_1_operand[69]      = addend_69                                                 ;
    assign stage_1_operand[70]      = addend_70                                                 ;
    assign stage_1_operand[71]      = addend_71                                                 ;
    assign stage_1_operand[72]      = addend_72                                                 ;
    assign stage_1_operand[73]      = addend_73                                                 ;
    assign stage_1_operand[74]      = addend_74                                                 ;
    assign stage_1_operand[75]      = bias << Q_FRAC                                            ;

    assign stage_1_result[0]        = stage_1_operand[0 ]   +   stage_1_operand[1 ]             ;
    assign stage_1_result[1]        = stage_1_operand[2 ]   +   stage_1_operand[3 ]             ;
    assign stage_1_result[2]        = stage_1_operand[4 ]   +   stage_1_operand[5 ]             ;
    assign stage_1_result[3]        = stage_1_operand[6 ]   +   stage_1_operand[7 ]             ;
    assign stage_1_result[4]        = stage_1_operand[8 ]   +   stage_1_operand[9 ]             ;
    assign stage_1_result[5]        = stage_1_operand[10]   +   stage_1_operand[11]             ;
    assign stage_1_result[6]        = stage_1_operand[12]   +   stage_1_operand[13]             ;
    assign stage_1_result[7]        = stage_1_operand[14]   +   stage_1_operand[15]             ;
    assign stage_1_result[8]        = stage_1_operand[16]   +   stage_1_operand[17]             ;
    assign stage_1_result[9]        = stage_1_operand[18]   +   stage_1_operand[19]             ;
    assign stage_1_result[10]       = stage_1_operand[20]   +   stage_1_operand[21]             ;
    assign stage_1_result[11]       = stage_1_operand[22]   +   stage_1_operand[23]             ;
    assign stage_1_result[12]       = stage_1_operand[24]   +   stage_1_operand[25]             ;
    assign stage_1_result[13]       = stage_1_operand[26]   +   stage_1_operand[27]             ;
    assign stage_1_result[14]       = stage_1_operand[28]   +   stage_1_operand[29]             ;
    assign stage_1_result[15]       = stage_1_operand[30]   +   stage_1_operand[31]             ;
    assign stage_1_result[16]       = stage_1_operand[32]   +   stage_1_operand[33]             ;
    assign stage_1_result[17]       = stage_1_operand[34]   +   stage_1_operand[35]             ;
    assign stage_1_result[18]       = stage_1_operand[36]   +   stage_1_operand[37]             ;
    assign stage_1_result[19]       = stage_1_operand[38]   +   stage_1_operand[39]             ;
    assign stage_1_result[20]       = stage_1_operand[40]   +   stage_1_operand[41]             ;
    assign stage_1_result[21]       = stage_1_operand[42]   +   stage_1_operand[43]             ;
    assign stage_1_result[22]       = stage_1_operand[44]   +   stage_1_operand[45]             ;
    assign stage_1_result[23]       = stage_1_operand[46]   +   stage_1_operand[47]             ;
    assign stage_1_result[24]       = stage_1_operand[48]   +   stage_1_operand[49]             ;
    assign stage_1_result[25]       = stage_1_operand[50]   +   stage_1_operand[51]             ;
    assign stage_1_result[26]       = stage_1_operand[52]   +   stage_1_operand[53]             ;
    assign stage_1_result[27]       = stage_1_operand[54]   +   stage_1_operand[55]             ;
    assign stage_1_result[28]       = stage_1_operand[56]   +   stage_1_operand[57]             ;
    assign stage_1_result[29]       = stage_1_operand[58]   +   stage_1_operand[59]             ;
    assign stage_1_result[30]       = stage_1_operand[60]   +   stage_1_operand[61]             ;
    assign stage_1_result[31]       = stage_1_operand[62]   +   stage_1_operand[63]             ;
    assign stage_1_result[32]       = stage_1_operand[64]   +   stage_1_operand[65]             ;
    assign stage_1_result[33]       = stage_1_operand[66]   +   stage_1_operand[67]             ;
    assign stage_1_result[34]       = stage_1_operand[68]   +   stage_1_operand[69]             ;
    assign stage_1_result[35]       = stage_1_operand[70]   +   stage_1_operand[71]             ;
    assign stage_1_result[36]       = stage_1_operand[72]   +   stage_1_operand[73]             ;
    assign stage_1_result[37]       = stage_1_operand[74]   +   stage_1_operand[75]             ;
    
    // -------------------------------------------------------------------------------
    // stage 1 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 2 start
    // operand  : signed Q3.30 -> signed Q4.30 (for preventing arithmetic overflow)
    // result   : signed Q4.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_2 - 1:0]               stage_2_operand [0:37]                      ;
    wire signed [width_stage_2 - 1:0]               stage_2_result  [0:18]                      ; // 38 = 19 * 2

    assign stage_2_operand[0]       = stage_1_result[0 ]                                        ;
    assign stage_2_operand[1]       = stage_1_result[1 ]                                        ;
    assign stage_2_operand[2]       = stage_1_result[2 ]                                        ;
    assign stage_2_operand[3]       = stage_1_result[3 ]                                        ;
    assign stage_2_operand[4]       = stage_1_result[4 ]                                        ;
    assign stage_2_operand[5]       = stage_1_result[5 ]                                        ;
    assign stage_2_operand[6]       = stage_1_result[6 ]                                        ;
    assign stage_2_operand[7]       = stage_1_result[7 ]                                        ;
    assign stage_2_operand[8]       = stage_1_result[8 ]                                        ;
    assign stage_2_operand[9]       = stage_1_result[9 ]                                        ;
    assign stage_2_operand[10]      = stage_1_result[10]                                        ;
    assign stage_2_operand[11]      = stage_1_result[11]                                        ;
    assign stage_2_operand[12]      = stage_1_result[12]                                        ;
    assign stage_2_operand[13]      = stage_1_result[13]                                        ;
    assign stage_2_operand[14]      = stage_1_result[14]                                        ;
    assign stage_2_operand[15]      = stage_1_result[15]                                        ;
    assign stage_2_operand[16]      = stage_1_result[16]                                        ;
    assign stage_2_operand[17]      = stage_1_result[17]                                        ;
    assign stage_2_operand[18]      = stage_1_result[18]                                        ;
    assign stage_2_operand[19]      = stage_1_result[19]                                        ;
    assign stage_2_operand[20]      = stage_1_result[20]                                        ;
    assign stage_2_operand[21]      = stage_1_result[21]                                        ;
    assign stage_2_operand[22]      = stage_1_result[22]                                        ;
    assign stage_2_operand[23]      = stage_1_result[23]                                        ;
    assign stage_2_operand[24]      = stage_1_result[24]                                        ;
    assign stage_2_operand[25]      = stage_1_result[25]                                        ;
    assign stage_2_operand[26]      = stage_1_result[26]                                        ;
    assign stage_2_operand[27]      = stage_1_result[27]                                        ;
    assign stage_2_operand[28]      = stage_1_result[28]                                        ;
    assign stage_2_operand[29]      = stage_1_result[29]                                        ;
    assign stage_2_operand[30]      = stage_1_result[30]                                        ;
    assign stage_2_operand[31]      = stage_1_result[31]                                        ;
    assign stage_2_operand[32]      = stage_1_result[32]                                        ;
    assign stage_2_operand[33]      = stage_1_result[33]                                        ;
    assign stage_2_operand[34]      = stage_1_result[34]                                        ;
    assign stage_2_operand[35]      = stage_1_result[35]                                        ;
    assign stage_2_operand[36]      = stage_1_result[36]                                        ;
    assign stage_2_operand[37]      = stage_1_result[37]                                        ;

    assign stage_2_result[0]        = stage_2_operand[0 ]   +   stage_2_operand[1 ]             ;
    assign stage_2_result[1]        = stage_2_operand[2 ]   +   stage_2_operand[3 ]             ;
    assign stage_2_result[2]        = stage_2_operand[4 ]   +   stage_2_operand[5 ]             ;
    assign stage_2_result[3]        = stage_2_operand[6 ]   +   stage_2_operand[7 ]             ;
    assign stage_2_result[4]        = stage_2_operand[8 ]   +   stage_2_operand[9 ]             ;
    assign stage_2_result[5]        = stage_2_operand[10]   +   stage_2_operand[11]             ;
    assign stage_2_result[6]        = stage_2_operand[12]   +   stage_2_operand[13]             ;
    assign stage_2_result[7]        = stage_2_operand[14]   +   stage_2_operand[15]             ;
    assign stage_2_result[8]        = stage_2_operand[16]   +   stage_2_operand[17]             ;
    assign stage_2_result[9]        = stage_2_operand[18]   +   stage_2_operand[19]             ;
    assign stage_2_result[10]       = stage_2_operand[20]   +   stage_2_operand[21]             ;
    assign stage_2_result[11]       = stage_2_operand[22]   +   stage_2_operand[23]             ;
    assign stage_2_result[12]       = stage_2_operand[24]   +   stage_2_operand[25]             ;
    assign stage_2_result[13]       = stage_2_operand[26]   +   stage_2_operand[27]             ;
    assign stage_2_result[14]       = stage_2_operand[28]   +   stage_2_operand[29]             ;
    assign stage_2_result[15]       = stage_2_operand[30]   +   stage_2_operand[31]             ;
    assign stage_2_result[16]       = stage_2_operand[32]   +   stage_2_operand[33]             ;
    assign stage_2_result[17]       = stage_2_operand[34]   +   stage_2_operand[35]             ;
    assign stage_2_result[18]       = stage_2_operand[36]   +   stage_2_operand[37]             ;

    // -------------------------------------------------------------------------------
    // stage 2 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 3 start
    // operand  : signed Q4.30 -> signed Q5.30 (for preventing arithmetic overflow)
    // result   : signed Q5.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_3 - 1:0]               stage_3_operand [0:18]                      ;
    wire signed [width_stage_3 - 1:0]               stage_3_result  [0:9]                       ; // 19 = 9 * 2 + 1

    assign stage_3_operand[0]       = stage_2_result[0 ]                                        ;
    assign stage_3_operand[1]       = stage_2_result[1 ]                                        ;
    assign stage_3_operand[2]       = stage_2_result[2 ]                                        ;
    assign stage_3_operand[3]       = stage_2_result[3 ]                                        ;
    assign stage_3_operand[4]       = stage_2_result[4 ]                                        ;
    assign stage_3_operand[5]       = stage_2_result[5 ]                                        ;
    assign stage_3_operand[6]       = stage_2_result[6 ]                                        ;
    assign stage_3_operand[7]       = stage_2_result[7 ]                                        ;
    assign stage_3_operand[8]       = stage_2_result[8 ]                                        ;
    assign stage_3_operand[9]       = stage_2_result[9 ]                                        ;
    assign stage_3_operand[10]      = stage_2_result[10]                                        ;
    assign stage_3_operand[11]      = stage_2_result[11]                                        ;
    assign stage_3_operand[12]      = stage_2_result[12]                                        ;
    assign stage_3_operand[13]      = stage_2_result[13]                                        ;
    assign stage_3_operand[14]      = stage_2_result[14]                                        ;
    assign stage_3_operand[15]      = stage_2_result[15]                                        ;
    assign stage_3_operand[16]      = stage_2_result[16]                                        ;
    assign stage_3_operand[17]      = stage_2_result[17]                                        ;
    assign stage_3_operand[18]      = stage_2_result[18]                                        ;

    assign stage_3_result[0]        = stage_3_operand[0 ]   +   stage_3_operand[1 ]             ;
    assign stage_3_result[1]        = stage_3_operand[2 ]   +   stage_3_operand[3 ]             ;
    assign stage_3_result[2]        = stage_3_operand[4 ]   +   stage_3_operand[5 ]             ;
    assign stage_3_result[3]        = stage_3_operand[6 ]   +   stage_3_operand[7 ]             ;
    assign stage_3_result[4]        = stage_3_operand[8 ]   +   stage_3_operand[9 ]             ;
    assign stage_3_result[5]        = stage_3_operand[10]   +   stage_3_operand[11]             ;
    assign stage_3_result[6]        = stage_3_operand[12]   +   stage_3_operand[13]             ;
    assign stage_3_result[7]        = stage_3_operand[14]   +   stage_3_operand[15]             ;
    assign stage_3_result[8]        = stage_3_operand[16]   +   stage_3_operand[17]             ;
    assign stage_3_result[9]        = stage_3_operand[18]                                       ;

    // -------------------------------------------------------------------------------
    // stage 3 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 4 start
    // operand  : signed Q5.30 -> signed Q6.30 (for preventing arithmetic overflow)
    // result   : signed Q6.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_4 - 1:0]               stage_4_operand     [0:9]                   ;
    wire signed [width_stage_4 - 1:0]               stage_4_result      [0:4]                   ; // 10 = 5 * 2
    reg signed  [width_stage_4 - 1:0]               stage_4_result_reg  [0:4]                   ;

    assign stage_4_operand[0]       = stage_3_result[0 ]                                        ;
    assign stage_4_operand[1]       = stage_3_result[1 ]                                        ;
    assign stage_4_operand[2]       = stage_3_result[2 ]                                        ;
    assign stage_4_operand[3]       = stage_3_result[3 ]                                        ;
    assign stage_4_operand[4]       = stage_3_result[4 ]                                        ;
    assign stage_4_operand[5]       = stage_3_result[5 ]                                        ;
    assign stage_4_operand[6]       = stage_3_result[6 ]                                        ;
    assign stage_4_operand[7]       = stage_3_result[7 ]                                        ;
    assign stage_4_operand[8]       = stage_3_result[8 ]                                        ;
    assign stage_4_operand[9]       = stage_3_result[9 ]                                        ;

    assign stage_4_result[0]        = stage_4_operand[0 ]   +   stage_4_operand[1 ]             ;
    assign stage_4_result[1]        = stage_4_operand[2 ]   +   stage_4_operand[3 ]             ;
    assign stage_4_result[2]        = stage_4_operand[4 ]   +   stage_4_operand[5 ]             ;
    assign stage_4_result[3]        = stage_4_operand[6 ]   +   stage_4_operand[7 ]             ;
    assign stage_4_result[4]        = stage_4_operand[8 ]   +   stage_4_operand[9 ]             ;

    always @(posedge clk) begin
        if (!rst_n) begin
            stage_4_result_reg[0]   <= 'd0;
            stage_4_result_reg[1]   <= 'd0;
            stage_4_result_reg[2]   <= 'd0;
            stage_4_result_reg[3]   <= 'd0;
            stage_4_result_reg[4]   <= 'd0;
        end
        else if (adder_tree_middle_stage_enable) begin
            stage_4_result_reg[0]   <= stage_4_result[0];
            stage_4_result_reg[1]   <= stage_4_result[1];
            stage_4_result_reg[2]   <= stage_4_result[2];
            stage_4_result_reg[3]   <= stage_4_result[3];
            stage_4_result_reg[4]   <= stage_4_result[4];
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_result_enable <= 1'b0;
        end
        else if (adder_tree_middle_stage_enable) begin
            adder_tree_result_enable <= 1'b1;
        end
        else if (adder_tree_result_enable) begin
            adder_tree_result_enable <= 1'b0;
        end
    end

    // -------------------------------------------------------------------------------
    // stage 4 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 5 start
    // operand  : signed Q6.30 -> signed Q7.30 (for preventing arithmetic overflow)
    // result   : signed Q7.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_5 - 1:0]               stage_5_operand     [0:4]                   ;
    wire signed [width_stage_5 - 1:0]               stage_5_result      [0:2]                   ; // 5 = 2 * 2 + 1

    assign stage_5_operand[0]       = stage_4_result_reg[0 ]                                    ;
    assign stage_5_operand[1]       = stage_4_result_reg[1 ]                                    ;
    assign stage_5_operand[2]       = stage_4_result_reg[2 ]                                    ;
    assign stage_5_operand[3]       = stage_4_result_reg[3 ]                                    ;
    assign stage_5_operand[4]       = stage_4_result_reg[4 ]                                    ;

    assign stage_5_result[0]        = stage_5_operand[0 ]   +   stage_5_operand[1 ]             ;
    assign stage_5_result[1]        = stage_5_operand[2 ]   +   stage_5_operand[3 ]             ;
    assign stage_5_result[2]        = stage_5_operand[4 ]                                       ;

    // -------------------------------------------------------------------------------
    // stage 5 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 6 start
    // operand  : signed Q7.30 -> signed Q8.30 (for preventing arithmetic overflow)
    // result   : signed Q8.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_6 - 1:0]               stage_6_operand     [0:2]                   ;
    wire signed [width_stage_6 - 1:0]               stage_6_result      [0:1]                   ; // 3 = 1 * 2 + 1

    assign stage_6_operand[0]       = stage_5_result[0 ]                                        ;
    assign stage_6_operand[1]       = stage_5_result[1 ]                                        ;
    assign stage_6_operand[2]       = stage_5_result[2 ]                                        ;

    assign stage_6_result[0]        = stage_6_operand[0 ]   +   stage_6_operand[1 ]             ;
    assign stage_6_result[1]        = stage_6_operand[2 ]                                       ;

    // -------------------------------------------------------------------------------
    // stage 6 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 7 start
    // operand  : signed Q8.30 -> signed Q9.30 (for preventing arithmetic overflow)
    // result   : signed Q9.30
    // -------------------------------------------------------------------------------

    wire signed [width_stage_7 - 1:0]               stage_7_operand     [0:1]                   ;
    wire signed [width_stage_7 - 1:0]               stage_7_result                              ; // 2 = 1 * 2

    assign stage_7_operand[0]       = stage_6_result[0 ]                                        ;
    assign stage_7_operand[1]       = stage_6_result[1 ]                                        ;

    assign stage_7_result           = stage_7_operand[0 ]   +   stage_7_operand[1 ]             ;

    // -------------------------------------------------------------------------------
    // stage 7 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // output start
    // result   : signed Q9.30
    // output   : signed Q1.15
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_result   <= 'd0;
        end
        else if (adder_tree_result_enable) begin
            adder_tree_result   <= (stage_7_result >> Q_FRAC) + stage_7_result[Q_FRAC-1]        ;
        end
    end

    // -------------------------------------------------------------------------------
    // output finish
    // -------------------------------------------------------------------------------

endmodule