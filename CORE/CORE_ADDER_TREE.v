module CORE_ADDER_TREE
#(
    // Assumption: Default input fixed point format = signed Q12.15
    parameter                                               Q_INT_INPUT     = 12                                ,
    parameter                                               Q_FRAC_INPUT    = 15                                ,

    // Assumption: Default bias fixed point format = signed Q8.0
    parameter                                               Q_INT_BIAS      = 8                                 ,
    parameter                                               Q_FRAC_BIAS     = 0                                 ,

    // Assumption: Default output fixed point format = signed Q19.15
    parameter                                               Q_INT_OUTPUT    = 19                                ,
    parameter                                               Q_FRAC_OUTPUT   = 15
)
(
    input                                                   clk                                                 ,
    input                                                   rst_n                                               ,
    input                                                   adder_tree_first_stage_enable                      ,

    // By assumption, each addend has signed Q3.30
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_0                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_1                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_2                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_3                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_4                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_5                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_6                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_7                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_8                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_9                                            ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_10                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_11                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_12                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_13                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_14                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_15                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_16                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_17                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_18                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_19                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_20                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_21                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_22                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_23                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_24                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_25                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_26                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_27                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_28                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_29                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_30                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_31                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_32                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_33                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_34                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_35                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_36                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_37                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_38                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_39                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_40                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_41                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_42                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_43                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_44                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_45                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_46                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_47                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_48                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_49                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_50                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_51                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_52                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_53                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_54                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_55                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_56                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_57                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_58                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_59                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_60                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_61                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_62                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_63                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_64                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_65                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_66                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_67                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_68                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_69                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_70                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_71                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_72                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_73                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_74                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_75                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_76                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_77                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_78                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_79                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_80                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_81                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_82                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_83                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_84                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_85                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_86                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_87                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_88                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_89                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_90                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_91                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_92                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_93                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_94                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_95                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_96                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_97                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_98                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_99                                           ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_100                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_101                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_102                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_103                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_104                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_105                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_106                                          ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend_107                                          ,

    input signed [Q_INT_BIAS + Q_FRAC_BIAS - 1:0]           bias                                                ,

    output reg signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]  adder_tree_result                                   ,
    output reg                                              adder_tree_result_enable
);

    localparam                                              width_stage_1   = Q_INT_INPUT + Q_FRAC_INPUT + 1    ;
    localparam                                              width_stage_2   = width_stage_1 + 1                 ;
    localparam                                              width_stage_3   = width_stage_2 + 1                 ;
    localparam                                              width_stage_4   = width_stage_3 + 1                 ;
    localparam                                              width_stage_5   = width_stage_4 + 1                 ;
    localparam                                              width_stage_6   = width_stage_5 + 1                 ;
    localparam                                              width_stage_7   = width_stage_6 + 1                 ;

    // -------------------------------------------------------------------------------
    // stage 1 start
    // operand  : signed Qa.b -> signed Q(a+1).b (for preventing arithmetic overflow)
    // result   : signed Q(a+1).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_1 - 1:0]                       stage_1_operand [0:108]                             ;
    wire signed [width_stage_1 - 1:0]                       stage_1_result  [0:54]                              ; // 109 = 54 * 2 + 1

    // sign extension: Qa.b -> Q(a+1).b
    assign stage_1_operand[0]       = addend_0                                                                  ;
    assign stage_1_operand[1]       = addend_1                                                                  ;
    assign stage_1_operand[2]       = addend_2                                                                  ;
    assign stage_1_operand[3]       = addend_3                                                                  ;
    assign stage_1_operand[4]       = addend_4                                                                  ;
    assign stage_1_operand[5]       = addend_5                                                                  ;
    assign stage_1_operand[6]       = addend_6                                                                  ;
    assign stage_1_operand[7]       = addend_7                                                                  ;
    assign stage_1_operand[8]       = addend_8                                                                  ;
    assign stage_1_operand[9]       = addend_9                                                                  ;
    assign stage_1_operand[10]      = addend_10                                                                 ;
    assign stage_1_operand[11]      = addend_11                                                                 ;
    assign stage_1_operand[12]      = addend_12                                                                 ;
    assign stage_1_operand[13]      = addend_13                                                                 ;
    assign stage_1_operand[14]      = addend_14                                                                 ;
    assign stage_1_operand[15]      = addend_15                                                                 ;
    assign stage_1_operand[16]      = addend_16                                                                 ;
    assign stage_1_operand[17]      = addend_17                                                                 ;
    assign stage_1_operand[18]      = addend_18                                                                 ;
    assign stage_1_operand[19]      = addend_19                                                                 ;
    assign stage_1_operand[20]      = addend_20                                                                 ;
    assign stage_1_operand[21]      = addend_21                                                                 ;
    assign stage_1_operand[22]      = addend_22                                                                 ;
    assign stage_1_operand[23]      = addend_23                                                                 ;
    assign stage_1_operand[24]      = addend_24                                                                 ;
    assign stage_1_operand[25]      = addend_25                                                                 ;
    assign stage_1_operand[26]      = addend_26                                                                 ;
    assign stage_1_operand[27]      = addend_27                                                                 ;
    assign stage_1_operand[28]      = addend_28                                                                 ;
    assign stage_1_operand[29]      = addend_29                                                                 ;
    assign stage_1_operand[30]      = addend_30                                                                 ;
    assign stage_1_operand[31]      = addend_31                                                                 ;
    assign stage_1_operand[32]      = addend_32                                                                 ;
    assign stage_1_operand[33]      = addend_33                                                                 ;
    assign stage_1_operand[34]      = addend_34                                                                 ;
    assign stage_1_operand[35]      = addend_35                                                                 ;
    assign stage_1_operand[36]      = addend_36                                                                 ;
    assign stage_1_operand[37]      = addend_37                                                                 ;
    assign stage_1_operand[38]      = addend_38                                                                 ;
    assign stage_1_operand[39]      = addend_39                                                                 ;
    assign stage_1_operand[40]      = addend_40                                                                 ;
    assign stage_1_operand[41]      = addend_41                                                                 ;
    assign stage_1_operand[42]      = addend_42                                                                 ;
    assign stage_1_operand[43]      = addend_43                                                                 ;
    assign stage_1_operand[44]      = addend_44                                                                 ;
    assign stage_1_operand[45]      = addend_45                                                                 ;
    assign stage_1_operand[46]      = addend_46                                                                 ;
    assign stage_1_operand[47]      = addend_47                                                                 ;
    assign stage_1_operand[48]      = addend_48                                                                 ;
    assign stage_1_operand[49]      = addend_49                                                                 ;
    assign stage_1_operand[50]      = addend_50                                                                 ;
    assign stage_1_operand[51]      = addend_51                                                                 ;
    assign stage_1_operand[52]      = addend_52                                                                 ;
    assign stage_1_operand[53]      = addend_53                                                                 ;
    assign stage_1_operand[54]      = addend_54                                                                 ;
    assign stage_1_operand[55]      = addend_55                                                                 ;
    assign stage_1_operand[56]      = addend_56                                                                 ;
    assign stage_1_operand[57]      = addend_57                                                                 ;
    assign stage_1_operand[58]      = addend_58                                                                 ;
    assign stage_1_operand[59]      = addend_59                                                                 ;
    assign stage_1_operand[60]      = addend_60                                                                 ;
    assign stage_1_operand[61]      = addend_61                                                                 ;
    assign stage_1_operand[62]      = addend_62                                                                 ;
    assign stage_1_operand[63]      = addend_63                                                                 ;
    assign stage_1_operand[64]      = addend_64                                                                 ;
    assign stage_1_operand[65]      = addend_65                                                                 ;
    assign stage_1_operand[66]      = addend_66                                                                 ;
    assign stage_1_operand[67]      = addend_67                                                                 ;
    assign stage_1_operand[68]      = addend_68                                                                 ;
    assign stage_1_operand[69]      = addend_69                                                                 ;
    assign stage_1_operand[70]      = addend_70                                                                 ;
    assign stage_1_operand[71]      = addend_71                                                                 ;
    assign stage_1_operand[72]      = addend_72                                                                 ;
    assign stage_1_operand[73]      = addend_73                                                                 ;
    assign stage_1_operand[74]      = addend_74                                                                 ;
    assign stage_1_operand[75]      = addend_75                                                                 ;
    assign stage_1_operand[76]      = addend_76                                                                 ;
    assign stage_1_operand[77]      = addend_77                                                                 ;
    assign stage_1_operand[78]      = addend_78                                                                 ;
    assign stage_1_operand[79]      = addend_79                                                                 ;
    assign stage_1_operand[80]      = addend_80                                                                 ;
    assign stage_1_operand[81]      = addend_81                                                                 ;
    assign stage_1_operand[82]      = addend_82                                                                 ;
    assign stage_1_operand[83]      = addend_83                                                                 ;
    assign stage_1_operand[84]      = addend_84                                                                 ;
    assign stage_1_operand[85]      = addend_85                                                                 ;
    assign stage_1_operand[86]      = addend_86                                                                 ;
    assign stage_1_operand[87]      = addend_87                                                                 ;
    assign stage_1_operand[88]      = addend_88                                                                 ;
    assign stage_1_operand[89]      = addend_89                                                                 ;
    assign stage_1_operand[90]      = addend_90                                                                 ;
    assign stage_1_operand[91]      = addend_91                                                                 ;
    assign stage_1_operand[92]      = addend_92                                                                 ;
    assign stage_1_operand[93]      = addend_93                                                                 ;
    assign stage_1_operand[94]      = addend_94                                                                 ;
    assign stage_1_operand[95]      = addend_95                                                                 ;
    assign stage_1_operand[96]      = addend_96                                                                 ;
    assign stage_1_operand[97]      = addend_97                                                                 ;
    assign stage_1_operand[98]      = addend_98                                                                 ;
    assign stage_1_operand[99]      = addend_99                                                                 ;
    assign stage_1_operand[100]     = addend_100                                                                ;
    assign stage_1_operand[101]     = addend_101                                                                ;
    assign stage_1_operand[102]     = addend_102                                                                ;
    assign stage_1_operand[103]     = addend_103                                                                ;
    assign stage_1_operand[104]     = addend_104                                                                ;
    assign stage_1_operand[105]     = addend_105                                                                ;
    assign stage_1_operand[106]     = addend_106                                                                ;
    assign stage_1_operand[107]     = addend_107                                                                ;
    assign stage_1_operand[108]     = bias << (Q_FRAC_INPUT - Q_FRAC_BIAS)                                      ;

    assign stage_1_result[0]        = stage_1_operand[0 ]   +   stage_1_operand[1 ]                             ;
    assign stage_1_result[1]        = stage_1_operand[2 ]   +   stage_1_operand[3 ]                             ;
    assign stage_1_result[2]        = stage_1_operand[4 ]   +   stage_1_operand[5 ]                             ;
    assign stage_1_result[3]        = stage_1_operand[6 ]   +   stage_1_operand[7 ]                             ;
    assign stage_1_result[4]        = stage_1_operand[8 ]   +   stage_1_operand[9 ]                             ;
    assign stage_1_result[5]        = stage_1_operand[10]   +   stage_1_operand[11]                             ;
    assign stage_1_result[6]        = stage_1_operand[12]   +   stage_1_operand[13]                             ;
    assign stage_1_result[7]        = stage_1_operand[14]   +   stage_1_operand[15]                             ;
    assign stage_1_result[8]        = stage_1_operand[16]   +   stage_1_operand[17]                             ;
    assign stage_1_result[9]        = stage_1_operand[18]   +   stage_1_operand[19]                             ;
    assign stage_1_result[10]       = stage_1_operand[20]   +   stage_1_operand[21]                             ;
    assign stage_1_result[11]       = stage_1_operand[22]   +   stage_1_operand[23]                             ;
    assign stage_1_result[12]       = stage_1_operand[24]   +   stage_1_operand[25]                             ;
    assign stage_1_result[13]       = stage_1_operand[26]   +   stage_1_operand[27]                             ;
    assign stage_1_result[14]       = stage_1_operand[28]   +   stage_1_operand[29]                             ;
    assign stage_1_result[15]       = stage_1_operand[30]   +   stage_1_operand[31]                             ;
    assign stage_1_result[16]       = stage_1_operand[32]   +   stage_1_operand[33]                             ;
    assign stage_1_result[17]       = stage_1_operand[34]   +   stage_1_operand[35]                             ;
    assign stage_1_result[18]       = stage_1_operand[36]   +   stage_1_operand[37]                             ;
    assign stage_1_result[19]       = stage_1_operand[38]   +   stage_1_operand[39]                             ;
    assign stage_1_result[20]       = stage_1_operand[40]   +   stage_1_operand[41]                             ;
    assign stage_1_result[21]       = stage_1_operand[42]   +   stage_1_operand[43]                             ;
    assign stage_1_result[22]       = stage_1_operand[44]   +   stage_1_operand[45]                             ;
    assign stage_1_result[23]       = stage_1_operand[46]   +   stage_1_operand[47]                             ;
    assign stage_1_result[24]       = stage_1_operand[48]   +   stage_1_operand[49]                             ;
    assign stage_1_result[25]       = stage_1_operand[50]   +   stage_1_operand[51]                             ;
    assign stage_1_result[26]       = stage_1_operand[52]   +   stage_1_operand[53]                             ;
    assign stage_1_result[27]       = stage_1_operand[54]   +   stage_1_operand[55]                             ;
    assign stage_1_result[28]       = stage_1_operand[56]   +   stage_1_operand[57]                             ;
    assign stage_1_result[29]       = stage_1_operand[58]   +   stage_1_operand[59]                             ;
    assign stage_1_result[30]       = stage_1_operand[60]   +   stage_1_operand[61]                             ;
    assign stage_1_result[31]       = stage_1_operand[62]   +   stage_1_operand[63]                             ;
    assign stage_1_result[32]       = stage_1_operand[64]   +   stage_1_operand[65]                             ;
    assign stage_1_result[33]       = stage_1_operand[66]   +   stage_1_operand[67]                             ;
    assign stage_1_result[34]       = stage_1_operand[68]   +   stage_1_operand[69]                             ;
    assign stage_1_result[35]       = stage_1_operand[70]   +   stage_1_operand[71]                             ;
    assign stage_1_result[36]       = stage_1_operand[72]   +   stage_1_operand[73]                             ;
    assign stage_1_result[37]       = stage_1_operand[74]   +   stage_1_operand[75]                             ;
    assign stage_1_result[38]       = stage_1_operand[76]   +   stage_1_operand[77]                             ;
    assign stage_1_result[39]       = stage_1_operand[78]   +   stage_1_operand[79]                             ;
    assign stage_1_result[40]       = stage_1_operand[80]   +   stage_1_operand[81]                             ;
    assign stage_1_result[41]       = stage_1_operand[82]   +   stage_1_operand[83]                             ;
    assign stage_1_result[42]       = stage_1_operand[84]   +   stage_1_operand[85]                             ;
    assign stage_1_result[43]       = stage_1_operand[86]   +   stage_1_operand[87]                             ;
    assign stage_1_result[44]       = stage_1_operand[88]   +   stage_1_operand[89]                             ;
    assign stage_1_result[45]       = stage_1_operand[90]   +   stage_1_operand[91]                             ;
    assign stage_1_result[46]       = stage_1_operand[92]   +   stage_1_operand[93]                             ;
    assign stage_1_result[47]       = stage_1_operand[94]   +   stage_1_operand[95]                             ;
    assign stage_1_result[48]       = stage_1_operand[96]   +   stage_1_operand[97]                             ;
    assign stage_1_result[49]       = stage_1_operand[98]   +   stage_1_operand[99]                             ;
    assign stage_1_result[50]       = stage_1_operand[100]  +   stage_1_operand[101]                            ;
    assign stage_1_result[51]       = stage_1_operand[102]  +   stage_1_operand[103]                            ;
    assign stage_1_result[52]       = stage_1_operand[104]  +   stage_1_operand[105]                            ;
    assign stage_1_result[53]       = stage_1_operand[106]  +   stage_1_operand[107]                            ;
    assign stage_1_result[54]       = stage_1_operand[108]                                                      ;
    
    // -------------------------------------------------------------------------------
    // stage 1 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 2 start
    // operand  : signed Q(a+1).b -> signed Q(a+2).b (for preventing arithmetic overflow)
    // result   : signed Q(a+2).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_2 - 1:0]               stage_2_operand [0:54]                                      ;
    wire signed [width_stage_2 - 1:0]               stage_2_result  [0:27]                                      ; // 55 = 27 * 2 + 1

    // sign extension: Q(a+1).b -> Q(a+2).b
    assign stage_2_operand[0]       = stage_1_result[0 ]                                                        ;
    assign stage_2_operand[1]       = stage_1_result[1 ]                                                        ;
    assign stage_2_operand[2]       = stage_1_result[2 ]                                                        ;
    assign stage_2_operand[3]       = stage_1_result[3 ]                                                        ;
    assign stage_2_operand[4]       = stage_1_result[4 ]                                                        ;
    assign stage_2_operand[5]       = stage_1_result[5 ]                                                        ;
    assign stage_2_operand[6]       = stage_1_result[6 ]                                                        ;
    assign stage_2_operand[7]       = stage_1_result[7 ]                                                        ;
    assign stage_2_operand[8]       = stage_1_result[8 ]                                                        ;
    assign stage_2_operand[9]       = stage_1_result[9 ]                                                        ;
    assign stage_2_operand[10]      = stage_1_result[10]                                                        ;
    assign stage_2_operand[11]      = stage_1_result[11]                                                        ;
    assign stage_2_operand[12]      = stage_1_result[12]                                                        ;
    assign stage_2_operand[13]      = stage_1_result[13]                                                        ;
    assign stage_2_operand[14]      = stage_1_result[14]                                                        ;
    assign stage_2_operand[15]      = stage_1_result[15]                                                        ;
    assign stage_2_operand[16]      = stage_1_result[16]                                                        ;
    assign stage_2_operand[17]      = stage_1_result[17]                                                        ;
    assign stage_2_operand[18]      = stage_1_result[18]                                                        ;
    assign stage_2_operand[19]      = stage_1_result[19]                                                        ;
    assign stage_2_operand[20]      = stage_1_result[20]                                                        ;
    assign stage_2_operand[21]      = stage_1_result[21]                                                        ;
    assign stage_2_operand[22]      = stage_1_result[22]                                                        ;
    assign stage_2_operand[23]      = stage_1_result[23]                                                        ;
    assign stage_2_operand[24]      = stage_1_result[24]                                                        ;
    assign stage_2_operand[25]      = stage_1_result[25]                                                        ;
    assign stage_2_operand[26]      = stage_1_result[26]                                                        ;
    assign stage_2_operand[27]      = stage_1_result[27]                                                        ;
    assign stage_2_operand[28]      = stage_1_result[28]                                                        ;
    assign stage_2_operand[29]      = stage_1_result[29]                                                        ;
    assign stage_2_operand[30]      = stage_1_result[30]                                                        ;
    assign stage_2_operand[31]      = stage_1_result[31]                                                        ;
    assign stage_2_operand[32]      = stage_1_result[32]                                                        ;
    assign stage_2_operand[33]      = stage_1_result[33]                                                        ;
    assign stage_2_operand[34]      = stage_1_result[34]                                                        ;
    assign stage_2_operand[35]      = stage_1_result[35]                                                        ;
    assign stage_2_operand[36]      = stage_1_result[36]                                                        ;
    assign stage_2_operand[37]      = stage_1_result[37]                                                        ;
    assign stage_2_operand[38]      = stage_1_result[38]                                                        ;
    assign stage_2_operand[39]      = stage_1_result[39]                                                        ;
    assign stage_2_operand[40]      = stage_1_result[40]                                                        ;
    assign stage_2_operand[41]      = stage_1_result[41]                                                        ;
    assign stage_2_operand[42]      = stage_1_result[42]                                                        ;
    assign stage_2_operand[43]      = stage_1_result[43]                                                        ;
    assign stage_2_operand[44]      = stage_1_result[44]                                                        ;
    assign stage_2_operand[45]      = stage_1_result[45]                                                        ;
    assign stage_2_operand[46]      = stage_1_result[46]                                                        ;
    assign stage_2_operand[47]      = stage_1_result[47]                                                        ;
    assign stage_2_operand[48]      = stage_1_result[48]                                                        ;
    assign stage_2_operand[49]      = stage_1_result[49]                                                        ;
    assign stage_2_operand[50]      = stage_1_result[50]                                                        ;
    assign stage_2_operand[51]      = stage_1_result[51]                                                        ;
    assign stage_2_operand[52]      = stage_1_result[52]                                                        ;
    assign stage_2_operand[53]      = stage_1_result[53]                                                        ;
    assign stage_2_operand[54]      = stage_1_result[54]                                                        ;

    assign stage_2_result[0]        = stage_2_operand[0 ]   +   stage_2_operand[1 ]                             ;
    assign stage_2_result[1]        = stage_2_operand[2 ]   +   stage_2_operand[3 ]                             ;
    assign stage_2_result[2]        = stage_2_operand[4 ]   +   stage_2_operand[5 ]                             ;
    assign stage_2_result[3]        = stage_2_operand[6 ]   +   stage_2_operand[7 ]                             ;
    assign stage_2_result[4]        = stage_2_operand[8 ]   +   stage_2_operand[9 ]                             ;
    assign stage_2_result[5]        = stage_2_operand[10]   +   stage_2_operand[11]                             ;
    assign stage_2_result[6]        = stage_2_operand[12]   +   stage_2_operand[13]                             ;
    assign stage_2_result[7]        = stage_2_operand[14]   +   stage_2_operand[15]                             ;
    assign stage_2_result[8]        = stage_2_operand[16]   +   stage_2_operand[17]                             ;
    assign stage_2_result[9]        = stage_2_operand[18]   +   stage_2_operand[19]                             ;
    assign stage_2_result[10]       = stage_2_operand[20]   +   stage_2_operand[21]                             ;
    assign stage_2_result[11]       = stage_2_operand[22]   +   stage_2_operand[23]                             ;
    assign stage_2_result[12]       = stage_2_operand[24]   +   stage_2_operand[25]                             ;
    assign stage_2_result[13]       = stage_2_operand[26]   +   stage_2_operand[27]                             ;
    assign stage_2_result[14]       = stage_2_operand[28]   +   stage_2_operand[29]                             ;
    assign stage_2_result[15]       = stage_2_operand[30]   +   stage_2_operand[31]                             ;
    assign stage_2_result[16]       = stage_2_operand[32]   +   stage_2_operand[33]                             ;
    assign stage_2_result[17]       = stage_2_operand[34]   +   stage_2_operand[35]                             ;
    assign stage_2_result[18]       = stage_2_operand[36]   +   stage_2_operand[37]                             ;
    assign stage_2_result[19]       = stage_2_operand[38]   +   stage_2_operand[39]                             ;
    assign stage_2_result[20]       = stage_2_operand[40]   +   stage_2_operand[41]                             ;
    assign stage_2_result[21]       = stage_2_operand[42]   +   stage_2_operand[43]                             ;
    assign stage_2_result[22]       = stage_2_operand[44]   +   stage_2_operand[45]                             ;
    assign stage_2_result[23]       = stage_2_operand[46]   +   stage_2_operand[47]                             ;
    assign stage_2_result[24]       = stage_2_operand[48]   +   stage_2_operand[49]                             ;
    assign stage_2_result[25]       = stage_2_operand[50]   +   stage_2_operand[51]                             ;
    assign stage_2_result[26]       = stage_2_operand[52]   +   stage_2_operand[53]                             ;
    assign stage_2_result[27]       = stage_2_operand[54]                                                       ;

    // -------------------------------------------------------------------------------
    // stage 2 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 3 start
    // operand  : signed Q(a+2).b -> signed Q(a+3).b (for preventing arithmetic overflow)
    // result   : signed Q(a+3).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_3 - 1:0]               stage_3_operand [0:27]                                      ;
    wire signed [width_stage_3 - 1:0]               stage_3_result  [0:13]                                      ; // 28 = 14 * 2

    // sign extension: Q(a+2).b -> Q(a+3).b
    assign stage_3_operand[0]       = stage_2_result[0 ]                                                        ;
    assign stage_3_operand[1]       = stage_2_result[1 ]                                                        ;
    assign stage_3_operand[2]       = stage_2_result[2 ]                                                        ;
    assign stage_3_operand[3]       = stage_2_result[3 ]                                                        ;
    assign stage_3_operand[4]       = stage_2_result[4 ]                                                        ;
    assign stage_3_operand[5]       = stage_2_result[5 ]                                                        ;
    assign stage_3_operand[6]       = stage_2_result[6 ]                                                        ;
    assign stage_3_operand[7]       = stage_2_result[7 ]                                                        ;
    assign stage_3_operand[8]       = stage_2_result[8 ]                                                        ;
    assign stage_3_operand[9]       = stage_2_result[9 ]                                                        ;
    assign stage_3_operand[10]      = stage_2_result[10]                                                        ;
    assign stage_3_operand[11]      = stage_2_result[11]                                                        ;
    assign stage_3_operand[12]      = stage_2_result[12]                                                        ;
    assign stage_3_operand[13]      = stage_2_result[13]                                                        ;
    assign stage_3_operand[14]      = stage_2_result[14]                                                        ;
    assign stage_3_operand[15]      = stage_2_result[15]                                                        ;
    assign stage_3_operand[16]      = stage_2_result[16]                                                        ;
    assign stage_3_operand[17]      = stage_2_result[17]                                                        ;
    assign stage_3_operand[18]      = stage_2_result[18]                                                        ;
    assign stage_3_operand[19]      = stage_2_result[19]                                                        ;
    assign stage_3_operand[20]      = stage_2_result[20]                                                        ;
    assign stage_3_operand[21]      = stage_2_result[21]                                                        ;
    assign stage_3_operand[22]      = stage_2_result[22]                                                        ;
    assign stage_3_operand[23]      = stage_2_result[23]                                                        ;
    assign stage_3_operand[24]      = stage_2_result[24]                                                        ;
    assign stage_3_operand[25]      = stage_2_result[25]                                                        ;
    assign stage_3_operand[26]      = stage_2_result[26]                                                        ;
    assign stage_3_operand[27]      = stage_2_result[27]                                                        ;

    assign stage_3_result[0]        = stage_3_operand[0 ]   +   stage_3_operand[1 ]                             ;
    assign stage_3_result[1]        = stage_3_operand[2 ]   +   stage_3_operand[3 ]                             ;
    assign stage_3_result[2]        = stage_3_operand[4 ]   +   stage_3_operand[5 ]                             ;
    assign stage_3_result[3]        = stage_3_operand[6 ]   +   stage_3_operand[7 ]                             ;
    assign stage_3_result[4]        = stage_3_operand[8 ]   +   stage_3_operand[9 ]                             ;
    assign stage_3_result[5]        = stage_3_operand[10]   +   stage_3_operand[11]                             ;
    assign stage_3_result[6]        = stage_3_operand[12]   +   stage_3_operand[13]                             ;
    assign stage_3_result[7]        = stage_3_operand[14]   +   stage_3_operand[15]                             ;
    assign stage_3_result[8]        = stage_3_operand[16]   +   stage_3_operand[17]                             ;
    assign stage_3_result[9]        = stage_3_operand[18]   +   stage_3_operand[19]                             ;
    assign stage_3_result[10]       = stage_3_operand[20]   +   stage_3_operand[21]                             ;
    assign stage_3_result[11]       = stage_3_operand[22]   +   stage_3_operand[23]                             ;
    assign stage_3_result[12]       = stage_3_operand[24]   +   stage_3_operand[25]                             ;
    assign stage_3_result[13]       = stage_3_operand[26]   +   stage_3_operand[27]                             ;

    // -------------------------------------------------------------------------------
    // stage 3 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 4 start
    // operand  : signed Q(a+3).b -> signed Q(a+4).b (for preventing arithmetic overflow)
    // result   : signed Q(a+4).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_4 - 1:0]               stage_4_operand     [0:13]                                  ;
    wire signed [width_stage_4 - 1:0]               stage_4_result      [0:6]                                   ; // 14 = 7 * 2
    reg signed  [width_stage_4 - 1:0]               stage_4_result_reg  [0:6]                                   ;
    reg                                             adder_tree_second_stage_enable                              ;

    // sign extension: Q(a+3).b -> Q(a+4).b
    assign stage_4_operand[0]       = stage_3_result[0 ]                                                        ;
    assign stage_4_operand[1]       = stage_3_result[1 ]                                                        ;
    assign stage_4_operand[2]       = stage_3_result[2 ]                                                        ;
    assign stage_4_operand[3]       = stage_3_result[3 ]                                                        ;
    assign stage_4_operand[4]       = stage_3_result[4 ]                                                        ;
    assign stage_4_operand[5]       = stage_3_result[5 ]                                                        ;
    assign stage_4_operand[6]       = stage_3_result[6 ]                                                        ;
    assign stage_4_operand[7]       = stage_3_result[7 ]                                                        ;
    assign stage_4_operand[8]       = stage_3_result[8 ]                                                        ;
    assign stage_4_operand[9]       = stage_3_result[9 ]                                                        ;
    assign stage_4_operand[10]      = stage_3_result[10]                                                        ;
    assign stage_4_operand[11]      = stage_3_result[11]                                                        ;
    assign stage_4_operand[12]      = stage_3_result[12]                                                        ;
    assign stage_4_operand[13]      = stage_3_result[13]                                                        ;

    assign stage_4_result[0]        = stage_4_operand[0 ]   +   stage_4_operand[1 ]                             ;
    assign stage_4_result[1]        = stage_4_operand[2 ]   +   stage_4_operand[3 ]                             ;
    assign stage_4_result[2]        = stage_4_operand[4 ]   +   stage_4_operand[5 ]                             ;
    assign stage_4_result[3]        = stage_4_operand[6 ]   +   stage_4_operand[7 ]                             ;
    assign stage_4_result[4]        = stage_4_operand[8 ]   +   stage_4_operand[9 ]                             ;
    assign stage_4_result[5]        = stage_4_operand[10]   +   stage_4_operand[11]                             ;
    assign stage_4_result[6]        = stage_4_operand[12]   +   stage_4_operand[13]                             ;

    always @(posedge clk) begin
        if (!rst_n) begin
            stage_4_result_reg[0]   <= 'd0;
            stage_4_result_reg[1]   <= 'd0;
            stage_4_result_reg[2]   <= 'd0;
            stage_4_result_reg[3]   <= 'd0;
            stage_4_result_reg[4]   <= 'd0;
            stage_4_result_reg[5]   <= 'd0;
            stage_4_result_reg[6]   <= 'd0;
        end
        else if (adder_tree_first_stage_enable) begin
            stage_4_result_reg[0]   <= stage_4_result[0];
            stage_4_result_reg[1]   <= stage_4_result[1];
            stage_4_result_reg[2]   <= stage_4_result[2];
            stage_4_result_reg[3]   <= stage_4_result[3];
            stage_4_result_reg[4]   <= stage_4_result[4];
            stage_4_result_reg[5]   <= stage_4_result[5];
            stage_4_result_reg[6]   <= stage_4_result[6];
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_second_stage_enable <= 1'b0;
        end
        else if (adder_tree_first_stage_enable) begin
            adder_tree_second_stage_enable <= 1'b1;
        end
        else if (adder_tree_second_stage_enable) begin
            adder_tree_second_stage_enable <= 1'b0;
        end
    end

    // -------------------------------------------------------------------------------
    // stage 4 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 5 start
    // operand  : signed Q(a+4).b -> signed Q(a+5).b (for preventing arithmetic overflow)
    // result   : signed Q(a+5).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_5 - 1:0]               stage_5_operand     [0:6]                   ;
    wire signed [width_stage_5 - 1:0]               stage_5_result      [0:3]                   ; // 7 = 3 * 2 + 1

    // sign extension: Q(a+4).b -> Q(a+5).b
    assign stage_5_operand[0]       = stage_4_result_reg[0 ]                                    ;
    assign stage_5_operand[1]       = stage_4_result_reg[1 ]                                    ;
    assign stage_5_operand[2]       = stage_4_result_reg[2 ]                                    ;
    assign stage_5_operand[3]       = stage_4_result_reg[3 ]                                    ;
    assign stage_5_operand[4]       = stage_4_result_reg[4 ]                                    ;
    assign stage_5_operand[5]       = stage_4_result_reg[5 ]                                    ;
    assign stage_5_operand[6]       = stage_4_result_reg[6 ]                                    ;

    assign stage_5_result[0]        = stage_5_operand[0 ]   +   stage_5_operand[1 ]             ;
    assign stage_5_result[1]        = stage_5_operand[2 ]   +   stage_5_operand[3 ]             ;
    assign stage_5_result[2]        = stage_5_operand[4 ]   +   stage_5_operand[5 ]             ;
    assign stage_5_result[3]        = stage_5_operand[6 ]                                       ;

    // -------------------------------------------------------------------------------
    // stage 5 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 6 start
    // operand  : signed Q(a+5).b -> signed Q(a+6).b (for preventing arithmetic overflow)
    // result   : signed Q(a+6).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_6 - 1:0]               stage_6_operand     [0:3]                   ;
    wire signed [width_stage_6 - 1:0]               stage_6_result      [0:1]                   ; // 4 = 2 * 2

    // sign extension: Q(a+5).b -> Q(a+6).b
    assign stage_6_operand[0]       = stage_5_result[0 ]                                        ;
    assign stage_6_operand[1]       = stage_5_result[1 ]                                        ;
    assign stage_6_operand[2]       = stage_5_result[2 ]                                        ;
    assign stage_6_operand[3]       = stage_5_result[3 ]                                        ;

    assign stage_6_result[0]        = stage_6_operand[0 ]   +   stage_6_operand[1 ]             ;
    assign stage_6_result[1]        = stage_6_operand[2 ]   +   stage_6_operand[3 ]             ;

    // -------------------------------------------------------------------------------
    // stage 6 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 7 start
    // operand  : signed Q(a+6).b -> signed Q(a+7).b (for preventing arithmetic overflow)
    // result   : signed Q(a+7).b
    // -------------------------------------------------------------------------------

    wire signed [width_stage_7 - 1:0]               stage_7_operand     [0:1]                   ;
    wire signed [width_stage_7 - 1:0]               stage_7_result                              ; // 2 = 1 * 2

    // sign extension: Q(a+6).b -> Q(a+7).b
    assign stage_7_operand[0]       = stage_6_result[0 ]                                        ;
    assign stage_7_operand[1]       = stage_6_result[1 ]                                        ;

    assign stage_7_result           = stage_7_operand[0 ]   +   stage_7_operand[1 ]             ;

    // -------------------------------------------------------------------------------
    // stage 7 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // output start
    // result       : signed Q(a+7).b
    // output       : signed Qc.d
    // assumption   : a+7 >= c, b >= d
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_result_enable <= 1'b0;
        end
        else if (adder_tree_second_stage_enable) begin
            adder_tree_result_enable <= 1'b1;
        end
        else if (adder_tree_result_enable) begin
            adder_tree_result_enable <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_result   <= 'd0;
        end
        else if (adder_tree_second_stage_enable) begin
            adder_tree_result   <= stage_7_result >> (Q_FRAC_INPUT - Q_FRAC_OUTPUT)             ;
        end
    end

    // -------------------------------------------------------------------------------
    // output finish
    // -------------------------------------------------------------------------------

endmodule