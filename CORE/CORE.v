// CORE: Calculator for all layers: from 'CONV_FIRST' to 'CONV_LAST'

module CORE
#(
    // Assumption: Default input fixed point format = signed Q4.15
    parameter                                                   Q_INT_INPUT         = 4     ,
    parameter                                                   Q_FRAC_INPUT        = 15    ,

    // Assumption: Default weight fixed point format = signed Q8.0
    parameter                                                   Q_INT_WEIGHT        = 8     ,
    parameter                                                   Q_FRAC_WEIGHT       = 0     ,

    // Assumption: Default bias fixed point format = signed Q8.0
    parameter                                                   Q_INT_BIAS          = 8     ,
    parameter                                                   Q_FRAC_BIAS         = 0     ,

    // Assumption: Default slope fixed point format = signed Q8.0
    parameter                                                   Q_INT_SLOPE         = 8     ,
    parameter                                                   Q_FRAC_SLOPE        = 0     ,

    // Assumption: Default scale (after Conv2d) fixed point format = signed Q1.12
    parameter                                                   Q_INT_SCALE_1       = 1     ,
    parameter                                                   Q_FRAC_SCALE_1      = 12    ,

    // Assumption: Default scale (after PReLU) fixed point format = signed Q1.9
    parameter                                                   Q_INT_SCALE_2       = 1     ,
    parameter                                                   Q_FRAC_SCALE_2      = 9     ,

    // Assumption: Default dot prod result fixed point format = signed Q12.15
    parameter                                                   Q_INT_INTERIM_1     = 12    ,
    parameter                                                   Q_FRAC_INTERIM_1    = 15    ,

    // Assumption: Default adder tree result fixed point format = signed Q19.15
    parameter                                                   Q_INT_INTERIM_2     = 19    ,
    parameter                                                   Q_FRAC_INTERIM_2    = 15    ,

    // Assumption: Default conv2d result fixed point format = signed Q20.27
    parameter                                                   Q_INT_INTERIM_3     = 20    ,
    parameter                                                   Q_FRAC_INTERIM_3    = 27    ,

    // Assumption: Default PReLU result fixed point format = signed Q28.27
    parameter                                                   Q_INT_INTERIM_4     = 28    ,
    parameter                                                   Q_FRAC_INTERIM_4    = 27    ,

    // Assumption: Default last acc result fixed point format = signed Q25.15
    parameter                                                   Q_INT_INTERIM_5     = 25    ,
    parameter                                                   Q_FRAC_INTERIM_5    = 15    ,

    // Assumption: Default output fixed point format = signed Q4.15
    parameter                                                   Q_INT_OUTPUT        = 4     ,
    parameter                                                   Q_FRAC_OUTPUT       = 15 
)
(
    input                                                       clk                         ,
    input                                                       rst_n                       ,

    input [2:0]                                                 layer_bits                  ,
    input                                                       convolution_enable          ,

    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_0                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_1                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_2                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_3                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_4                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_5                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_6                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_7                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_8                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_9                   ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_10                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_11                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_12                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_13                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_14                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_15                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_16                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_17                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_18                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_19                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_20                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_21                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_22                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_23                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_24                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_25                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_26                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_27                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_28                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_29                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_30                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_31                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_32                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_33                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_34                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_35                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_36                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_37                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_38                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_39                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_40                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_41                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_42                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_43                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_44                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_45                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_46                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_47                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_48                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_49                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_50                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_51                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_52                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_53                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_54                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_55                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_56                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_57                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_58                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_59                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_60                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_61                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_62                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_63                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_64                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_65                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_66                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_67                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_68                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_69                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_70                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_71                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_72                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_73                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_74                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_75                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_76                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_77                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_78                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_79                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_80                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_81                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_82                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_83                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_84                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_85                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_86                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_87                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_88                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_89                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_90                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_91                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_92                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_93                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_94                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_95                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_96                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_97                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_98                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_99                  ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_100                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_101                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_102                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_103                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_104                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_105                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_106                 ,
    input signed    [Q_INT_INPUT + Q_FRAC_INPUT -1:0]           data_in_107                 ,

    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_0                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_1                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_2                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_3                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_4                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_5                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_6                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_7                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_8                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_9                 ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_10                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_11                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_12                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_13                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_14                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_15                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_16                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_17                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_18                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_19                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_20                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_21                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_22                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_23                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_24                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_25                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_26                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_27                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_28                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_29                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_30                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_31                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_32                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_33                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_34                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_35                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_36                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_37                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_38                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_39                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_40                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_41                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_42                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_43                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_44                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_45                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_46                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_47                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_48                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_49                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_50                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_51                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_52                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_53                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_54                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_55                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_56                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_57                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_58                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_59                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_60                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_61                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_62                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_63                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_64                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_65                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_66                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_67                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_68                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_69                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_70                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_71                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_72                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_73                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_74                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_75                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_76                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_77                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_78                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_79                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_80                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_81                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_82                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_83                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_84                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_85                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_86                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_87                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_88                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_89                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_90                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_91                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_92                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_93                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_94                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_95                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_96                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_97                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_98                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_99                ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_100               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_101               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_102               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_103               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_104               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_105               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_106               ,
    input signed    [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]         weight_in_107               ,

    input signed    [Q_INT_BIAS + Q_FRAC_BIAS -1:0]             bias_in                     ,
    input signed    [Q_INT_SLOPE + Q_FRAC_SLOPE -1:0]           slope_in                    ,

    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     data_out                    ,
    output reg                                                  data_out_enable
);

    // -------------------------------------------------------------------------------
    // data control start
    // -------------------------------------------------------------------------------

    // In some layers, valid data comes after scale_1
    // which is the result of "F.Conv2d"
    // this result should wait for 1 cycle in a temporal buffer
    reg [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]                    conv2d_result               ;
    reg [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]                    temp_conv2d_result          ;
    wire                                                        is_conv2d_core_output       ;

    always @(posedge clk) begin
        if (!rst_n) begin
            conv2d_result <= 'b0;
        end
        else if (scale_1_result_enable) begin
            conv2d_result <= scale_1_result >> (Q_FRAC_INTERIM_3 - Q_FRAC_OUTPUT);
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            temp_conv2d_result <= 'b0;
        end
        else if (PReLU_result_enable) begin
            temp_conv2d_result <= conv2d_result;
        end
    end

    assign is_conv2d_core_output = (layer_bits == 3'd0
                                    || layer_bits == 3'd1
                                    || layer_bits == 3'd5
                                    || layer_bits == 3'd6 ) ? 1'b0 : 1'b1;

    // -------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            data_out_enable <= 1'b0;
        end
        else if (scale_2_result_enable) begin
            data_out_enable <= 1'b1;
        end
        else if (data_out_enable) begin
            data_out_enable <= 1'b0;
        end
    end


    always @(posedge clk) begin
        if (!rst_n) begin
            data_out <= 'b0;
        end
        else if (scale_2_result_enable) begin
            if (is_conv2d_core_output) begin
                data_out <= temp_conv2d_result;
            end
            else begin
                data_out <= scale_2_result;
            end
        end
    end

    // -------------------------------------------------------------------------------
    // data control finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // declaration of multi-bit interconnect wires start
    // -------------------------------------------------------------------------------

    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_0         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_1         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_2         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_3         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_4         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_5         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_6         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_7         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_8         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_9         ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_10        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_11        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_12        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_13        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_14        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_15        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_16        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_17        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_18        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_19        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_20        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_21        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_22        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_23        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_24        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_25        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_26        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_27        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_28        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_29        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_30        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_31        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_32        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_33        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_34        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_35        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_36        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_37        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_38        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_39        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_40        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_41        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_42        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_43        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_44        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_45        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_46        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_47        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_48        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_49        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_50        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_51        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_52        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_53        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_54        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_55        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_56        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_57        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_58        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_59        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_60        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_61        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_62        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_63        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_64        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_65        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_66        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_67        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_68        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_69        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_70        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_71        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_72        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_73        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_74        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_75        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_76        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_77        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_78        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_79        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_80        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_81        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_82        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_83        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_84        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_85        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_86        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_87        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_88        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_89        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_90        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_91        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_92        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_93        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_94        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_95        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_96        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_97        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_98        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_99        ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_100       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_101       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_102       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_103       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_104       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_105       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_106       ;
    wire signed [Q_INT_INTERIM_1 + Q_FRAC_INTERIM_1 -1:0]       multiplied_result_107       ;

    wire signed [Q_INT_BIAS + Q_FRAC_BIAS -1:0]                 bias_buffed                 ;

	  wire signed [Q_INT_INTERIM_2 + Q_FRAC_INTERIM_2 -1:0]       adder_tree_result           ;
    wire signed [Q_INT_INTERIM_3 + Q_FRAC_INTERIM_3 -1:0]       scale_1_result              ;
    wire signed [Q_INT_INTERIM_4 + Q_FRAC_INTERIM_4 -1:0]       PReLU_result                ;
    wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]             scale_2_result              ;

    // -------------------------------------------------------------------------------
    // declaration of multi-bit interconnect wires finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    CORE_DOT_PRODUCT
    #(
        .Q_INT_DATA                             (Q_INT_INPUT                ),
        .Q_FRAC_DATA                            (Q_FRAC_INPUT               ),
        .Q_INT_WEIGHT                           (Q_INT_WEIGHT               ),
        .Q_FRAC_WEIGHT                          (Q_FRAC_WEIGHT              ),
        .Q_INT_BIAS                             (Q_INT_BIAS                 ),
        .Q_FRAC_BIAS                            (Q_FRAC_BIAS                ),
        .Q_INT_OUTPUT                           (Q_INT_INTERIM_1            ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_INTERIM_1           )
    )
    dot_product_inst
    (
        .clk                                    (clk                        ),
        .rst_n                                  (rst_n                      ),

        .dot_product_enable                     (convolution_enable         ),

        .data_0                                 (data_in_0                  ),
        .data_1                                 (data_in_1                  ),
        .data_2                                 (data_in_2                  ),
        .data_3                                 (data_in_3                  ),
        .data_4                                 (data_in_4                  ),
        .data_5                                 (data_in_5                  ),
        .data_6                                 (data_in_6                  ),
        .data_7                                 (data_in_7                  ),
        .data_8                                 (data_in_8                  ),
        .data_9                                 (data_in_9                  ),
        .data_10                                (data_in_10                 ),
        .data_11                                (data_in_11                 ),
        .data_12                                (data_in_12                 ),
        .data_13                                (data_in_13                 ),
        .data_14                                (data_in_14                 ),
        .data_15                                (data_in_15                 ),
        .data_16                                (data_in_16                 ),
        .data_17                                (data_in_17                 ),
        .data_18                                (data_in_18                 ),
        .data_19                                (data_in_19                 ),
        .data_20                                (data_in_20                 ),
        .data_21                                (data_in_21                 ),
        .data_22                                (data_in_22                 ),
        .data_23                                (data_in_23                 ),
        .data_24                                (data_in_24                 ),
        .data_25                                (data_in_25                 ),
        .data_26                                (data_in_26                 ),
        .data_27                                (data_in_27                 ),
        .data_28                                (data_in_28                 ),
        .data_29                                (data_in_29                 ),
        .data_30                                (data_in_30                 ),
        .data_31                                (data_in_31                 ),
        .data_32                                (data_in_32                 ),
        .data_33                                (data_in_33                 ),
        .data_34                                (data_in_34                 ),
        .data_35                                (data_in_35                 ),
        .data_36                                (data_in_36                 ),
        .data_37                                (data_in_37                 ),
        .data_38                                (data_in_38                 ),
        .data_39                                (data_in_39                 ),
        .data_40                                (data_in_40                 ),
        .data_41                                (data_in_41                 ),
        .data_42                                (data_in_42                 ),
        .data_43                                (data_in_43                 ),
        .data_44                                (data_in_44                 ),
        .data_45                                (data_in_45                 ),
        .data_46                                (data_in_46                 ),
        .data_47                                (data_in_47                 ),
        .data_48                                (data_in_48                 ),
        .data_49                                (data_in_49                 ),
        .data_50                                (data_in_50                 ),
        .data_51                                (data_in_51                 ),
        .data_52                                (data_in_52                 ),
        .data_53                                (data_in_53                 ),
        .data_54                                (data_in_54                 ),
        .data_55                                (data_in_55                 ),
        .data_56                                (data_in_56                 ),
        .data_57                                (data_in_57                 ),
        .data_58                                (data_in_58                 ),
        .data_59                                (data_in_59                 ),
        .data_60                                (data_in_60                 ),
        .data_61                                (data_in_61                 ),
        .data_62                                (data_in_62                 ),
        .data_63                                (data_in_63                 ),
        .data_64                                (data_in_64                 ),
        .data_65                                (data_in_65                 ),
        .data_66                                (data_in_66                 ),
        .data_67                                (data_in_67                 ),
        .data_68                                (data_in_68                 ),
        .data_69                                (data_in_69                 ),
        .data_70                                (data_in_70                 ),
        .data_71                                (data_in_71                 ),
        .data_72                                (data_in_72                 ),
        .data_73                                (data_in_73                 ),
        .data_74                                (data_in_74                 ),
        .data_75                                (data_in_75                 ),
        .data_76                                (data_in_76                 ),
        .data_77                                (data_in_77                 ),
        .data_78                                (data_in_78                 ),
        .data_79                                (data_in_79                 ),
        .data_80                                (data_in_80                 ),
        .data_81                                (data_in_81                 ),
        .data_82                                (data_in_82                 ),
        .data_83                                (data_in_83                 ),
        .data_84                                (data_in_84                 ),
        .data_85                                (data_in_85                 ),
        .data_86                                (data_in_86                 ),
        .data_87                                (data_in_87                 ),
        .data_88                                (data_in_88                 ),
        .data_89                                (data_in_89                 ),
        .data_90                                (data_in_90                 ),
        .data_91                                (data_in_91                 ),
        .data_92                                (data_in_92                 ),
        .data_93                                (data_in_93                 ),
        .data_94                                (data_in_94                 ),
        .data_95                                (data_in_95                 ),
        .data_96                                (data_in_96                 ),
        .data_97                                (data_in_97                 ),
        .data_98                                (data_in_98                 ),
        .data_99                                (data_in_99                 ),
        .data_100                               (data_in_100                ),
        .data_101                               (data_in_101                ),
        .data_102                               (data_in_102                ),
        .data_103                               (data_in_103                ),
        .data_104                               (data_in_104                ),
        .data_105                               (data_in_105                ),
        .data_106                               (data_in_106                ),
        .data_107                               (data_in_107                ),

        .weight_0                               (weight_in_0                ),
        .weight_1                               (weight_in_1                ),
        .weight_2                               (weight_in_2                ),
        .weight_3                               (weight_in_3                ),
        .weight_4                               (weight_in_4                ),
        .weight_5                               (weight_in_5                ),
        .weight_6                               (weight_in_6                ),
        .weight_7                               (weight_in_7                ),
        .weight_8                               (weight_in_8                ),
        .weight_9                               (weight_in_9                ),
        .weight_10                              (weight_in_10               ),
        .weight_11                              (weight_in_11               ),
        .weight_12                              (weight_in_12               ),
        .weight_13                              (weight_in_13               ),
        .weight_14                              (weight_in_14               ),
        .weight_15                              (weight_in_15               ),
        .weight_16                              (weight_in_16               ),
        .weight_17                              (weight_in_17               ),
        .weight_18                              (weight_in_18               ),
        .weight_19                              (weight_in_19               ),
        .weight_20                              (weight_in_20               ),
        .weight_21                              (weight_in_21               ),
        .weight_22                              (weight_in_22               ),
        .weight_23                              (weight_in_23               ),
        .weight_24                              (weight_in_24               ),
        .weight_25                              (weight_in_25               ),
        .weight_26                              (weight_in_26               ),
        .weight_27                              (weight_in_27               ),
        .weight_28                              (weight_in_28               ),
        .weight_29                              (weight_in_29               ),
        .weight_30                              (weight_in_30               ),
        .weight_31                              (weight_in_31               ),
        .weight_32                              (weight_in_32               ),
        .weight_33                              (weight_in_33               ),
        .weight_34                              (weight_in_34               ),
        .weight_35                              (weight_in_35               ),
        .weight_36                              (weight_in_36               ),
        .weight_37                              (weight_in_37               ),
        .weight_38                              (weight_in_38               ),
        .weight_39                              (weight_in_39               ),
        .weight_40                              (weight_in_40               ),
        .weight_41                              (weight_in_41               ),
        .weight_42                              (weight_in_42               ),
        .weight_43                              (weight_in_43               ),
        .weight_44                              (weight_in_44               ),
        .weight_45                              (weight_in_45               ),
        .weight_46                              (weight_in_46               ),
        .weight_47                              (weight_in_47               ),
        .weight_48                              (weight_in_48               ),
        .weight_49                              (weight_in_49               ),
        .weight_50                              (weight_in_50               ),
        .weight_51                              (weight_in_51               ),
        .weight_52                              (weight_in_52               ),
        .weight_53                              (weight_in_53               ),
        .weight_54                              (weight_in_54               ),
        .weight_55                              (weight_in_55               ),
        .weight_56                              (weight_in_56               ),
        .weight_57                              (weight_in_57               ),
        .weight_58                              (weight_in_58               ),
        .weight_59                              (weight_in_59               ),
        .weight_60                              (weight_in_60               ),
        .weight_61                              (weight_in_61               ),
        .weight_62                              (weight_in_62               ),
        .weight_63                              (weight_in_63               ),
        .weight_64                              (weight_in_64               ),
        .weight_65                              (weight_in_65               ),
        .weight_66                              (weight_in_66               ),
        .weight_67                              (weight_in_67               ),
        .weight_68                              (weight_in_68               ),
        .weight_69                              (weight_in_69               ),
        .weight_70                              (weight_in_70               ),
        .weight_71                              (weight_in_71               ),
        .weight_72                              (weight_in_72               ),
        .weight_73                              (weight_in_73               ),
        .weight_74                              (weight_in_74               ),
        .weight_75                              (weight_in_75               ),
        .weight_76                              (weight_in_76               ),
        .weight_77                              (weight_in_77               ),
        .weight_78                              (weight_in_78               ),
        .weight_79                              (weight_in_79               ),
        .weight_80                              (weight_in_80               ),
        .weight_81                              (weight_in_81               ),
        .weight_82                              (weight_in_82               ),
        .weight_83                              (weight_in_83               ),
        .weight_84                              (weight_in_84               ),
        .weight_85                              (weight_in_85               ),
        .weight_86                              (weight_in_86               ),
        .weight_87                              (weight_in_87               ),
        .weight_88                              (weight_in_88               ),
        .weight_89                              (weight_in_89               ),
        .weight_90                              (weight_in_90               ),
        .weight_91                              (weight_in_91               ),
        .weight_92                              (weight_in_92               ),
        .weight_93                              (weight_in_93               ),
        .weight_94                              (weight_in_94               ),
        .weight_95                              (weight_in_95               ),
        .weight_96                              (weight_in_96               ),
        .weight_97                              (weight_in_97               ),
        .weight_98                              (weight_in_98               ),
        .weight_99                              (weight_in_99               ),
        .weight_100                             (weight_in_100              ),
        .weight_101                             (weight_in_101              ),
        .weight_102                             (weight_in_102              ),
        .weight_103                             (weight_in_103              ),
        .weight_104                             (weight_in_104              ),
        .weight_105                             (weight_in_105              ),
        .weight_106                             (weight_in_106              ),
        .weight_107                             (weight_in_107              ),

        .bias_i                                 (bias_in                    ),

        .result_0                               (multiplied_result_0        ),
        .result_1                               (multiplied_result_1        ),
        .result_2                               (multiplied_result_2        ),
        .result_3                               (multiplied_result_3        ),
        .result_4                               (multiplied_result_4        ),
        .result_5                               (multiplied_result_5        ),
        .result_6                               (multiplied_result_6        ),
        .result_7                               (multiplied_result_7        ),
        .result_8                               (multiplied_result_8        ),
        .result_9                               (multiplied_result_9        ),
        .result_10                              (multiplied_result_10       ),
        .result_11                              (multiplied_result_11       ),
        .result_12                              (multiplied_result_12       ),
        .result_13                              (multiplied_result_13       ),
        .result_14                              (multiplied_result_14       ),
        .result_15                              (multiplied_result_15       ),
        .result_16                              (multiplied_result_16       ),
        .result_17                              (multiplied_result_17       ),
        .result_18                              (multiplied_result_18       ),
        .result_19                              (multiplied_result_19       ),
        .result_20                              (multiplied_result_20       ),
        .result_21                              (multiplied_result_21       ),
        .result_22                              (multiplied_result_22       ),
        .result_23                              (multiplied_result_23       ),
        .result_24                              (multiplied_result_24       ),
        .result_25                              (multiplied_result_25       ),
        .result_26                              (multiplied_result_26       ),
        .result_27                              (multiplied_result_27       ),
        .result_28                              (multiplied_result_28       ),
        .result_29                              (multiplied_result_29       ),
        .result_30                              (multiplied_result_30       ),
        .result_31                              (multiplied_result_31       ),
        .result_32                              (multiplied_result_32       ),
        .result_33                              (multiplied_result_33       ),
        .result_34                              (multiplied_result_34       ),
        .result_35                              (multiplied_result_35       ),
        .result_36                              (multiplied_result_36       ),
        .result_37                              (multiplied_result_37       ),
        .result_38                              (multiplied_result_38       ),
        .result_39                              (multiplied_result_39       ),
        .result_40                              (multiplied_result_40       ),
        .result_41                              (multiplied_result_41       ),
        .result_42                              (multiplied_result_42       ),
        .result_43                              (multiplied_result_43       ),
        .result_44                              (multiplied_result_44       ),
        .result_45                              (multiplied_result_45       ),
        .result_46                              (multiplied_result_46       ),
        .result_47                              (multiplied_result_47       ),
        .result_48                              (multiplied_result_48       ),
        .result_49                              (multiplied_result_49       ),
        .result_50                              (multiplied_result_50       ),
        .result_51                              (multiplied_result_51       ),
        .result_52                              (multiplied_result_52       ),
        .result_53                              (multiplied_result_53       ),
        .result_54                              (multiplied_result_54       ),
        .result_55                              (multiplied_result_55       ),
        .result_56                              (multiplied_result_56       ),
        .result_57                              (multiplied_result_57       ),
        .result_58                              (multiplied_result_58       ),
        .result_59                              (multiplied_result_59       ),
        .result_60                              (multiplied_result_60       ),
        .result_61                              (multiplied_result_61       ),
        .result_62                              (multiplied_result_62       ),
        .result_63                              (multiplied_result_63       ),
        .result_64                              (multiplied_result_64       ),
        .result_65                              (multiplied_result_65       ),
        .result_66                              (multiplied_result_66       ),
        .result_67                              (multiplied_result_67       ),
        .result_68                              (multiplied_result_68       ),
        .result_69                              (multiplied_result_69       ),
        .result_70                              (multiplied_result_70       ),
        .result_71                              (multiplied_result_71       ),
        .result_72                              (multiplied_result_72       ),
        .result_73                              (multiplied_result_73       ),
        .result_74                              (multiplied_result_74       ),
        .result_75                              (multiplied_result_75       ),
        .result_76                              (multiplied_result_76       ),
        .result_77                              (multiplied_result_77       ),
        .result_78                              (multiplied_result_78       ),
        .result_79                              (multiplied_result_79       ),
        .result_80                              (multiplied_result_80       ),
        .result_81                              (multiplied_result_81       ),
        .result_82                              (multiplied_result_82       ),
        .result_83                              (multiplied_result_83       ),
        .result_84                              (multiplied_result_84       ),
        .result_85                              (multiplied_result_85       ),
        .result_86                              (multiplied_result_86       ),
        .result_87                              (multiplied_result_87       ),
        .result_88                              (multiplied_result_88       ),
        .result_89                              (multiplied_result_89       ),
        .result_90                              (multiplied_result_90       ),
        .result_91                              (multiplied_result_91       ),
        .result_92                              (multiplied_result_92       ),
        .result_93                              (multiplied_result_93       ),
        .result_94                              (multiplied_result_94       ),
        .result_95                              (multiplied_result_95       ),
        .result_96                              (multiplied_result_96       ),
        .result_97                              (multiplied_result_97       ),
        .result_98                              (multiplied_result_98       ),
        .result_99                              (multiplied_result_99       ),
        .result_100                             (multiplied_result_100      ),
        .result_101                             (multiplied_result_101      ),
        .result_102                             (multiplied_result_102      ),
        .result_103                             (multiplied_result_103      ),
        .result_104                             (multiplied_result_104      ),
        .result_105                             (multiplied_result_105      ),
        .result_106                             (multiplied_result_106      ),
        .result_107                             (multiplied_result_107      ),

        .bias_o                                 (bias_buffed                ),

        .adder_tree_enable                      (adder_tree_enable          )
    );

    CORE_ADDER_TREE
    #(
        .Q_INT_INPUT                            (Q_INT_INTERIM_1            ),
        .Q_FRAC_INPUT                           (Q_FRAC_INTERIM_1           ),
        .Q_INT_BIAS                             (Q_INT_BIAS                 ),
        .Q_FRAC_BIAS                            (Q_FRAC_BIAS                ),
        .Q_INT_OUTPUT                           (Q_INT_INTERIM_2            ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_INTERIM_2           )
    )
    adder_tree_inst
    (
        .clk                                    (clk                        ),
        .rst_n                                  (rst_n                      ),

        .adder_tree_first_stage_enable			     (adder_tree_enable          ),

        .addend_0                               (multiplied_result_0        ),
        .addend_1                               (multiplied_result_1        ),
        .addend_2                               (multiplied_result_2        ),
        .addend_3                               (multiplied_result_3        ),
        .addend_4                               (multiplied_result_4        ),
        .addend_5                               (multiplied_result_5        ),
        .addend_6                               (multiplied_result_6        ),
        .addend_7                               (multiplied_result_7        ),
        .addend_8                               (multiplied_result_8        ),
        .addend_9                               (multiplied_result_9        ),
        .addend_10                              (multiplied_result_10       ),
        .addend_11                              (multiplied_result_11       ),
        .addend_12                              (multiplied_result_12       ),
        .addend_13                              (multiplied_result_13       ),
        .addend_14                              (multiplied_result_14       ),
        .addend_15                              (multiplied_result_15       ),
        .addend_16                              (multiplied_result_16       ),
        .addend_17                              (multiplied_result_17       ),
        .addend_18                              (multiplied_result_18       ),
        .addend_19                              (multiplied_result_19       ),
        .addend_20                              (multiplied_result_20       ),
        .addend_21                              (multiplied_result_21       ),
        .addend_22                              (multiplied_result_22       ),
        .addend_23                              (multiplied_result_23       ),
        .addend_24                              (multiplied_result_24       ),
        .addend_25                              (multiplied_result_25       ),
        .addend_26                              (multiplied_result_26       ),
        .addend_27                              (multiplied_result_27       ),
        .addend_28                              (multiplied_result_28       ),
        .addend_29                              (multiplied_result_29       ),
        .addend_30                              (multiplied_result_30       ),
        .addend_31                              (multiplied_result_31       ),
        .addend_32                              (multiplied_result_32       ),
        .addend_33                              (multiplied_result_33       ),
        .addend_34                              (multiplied_result_34       ),
        .addend_35                              (multiplied_result_35       ),
        .addend_36                              (multiplied_result_36       ),
        .addend_37                              (multiplied_result_37       ),
        .addend_38                              (multiplied_result_38       ),
        .addend_39                              (multiplied_result_39       ),
        .addend_40                              (multiplied_result_40       ),
        .addend_41                              (multiplied_result_41       ),
        .addend_42                              (multiplied_result_42       ),
        .addend_43                              (multiplied_result_43       ),
        .addend_44                              (multiplied_result_44       ),
        .addend_45                              (multiplied_result_45       ),
        .addend_46                              (multiplied_result_46       ),
        .addend_47                              (multiplied_result_47       ),
        .addend_48                              (multiplied_result_48       ),
        .addend_49                              (multiplied_result_49       ),
        .addend_50                              (multiplied_result_50       ),
        .addend_51                              (multiplied_result_51       ),
        .addend_52                              (multiplied_result_52       ),
        .addend_53                              (multiplied_result_53       ),
        .addend_54                              (multiplied_result_54       ),
        .addend_55                              (multiplied_result_55       ),
        .addend_56                              (multiplied_result_56       ),
        .addend_57                              (multiplied_result_57       ),
        .addend_58                              (multiplied_result_58       ),
        .addend_59                              (multiplied_result_59       ),
        .addend_60                              (multiplied_result_60       ),
        .addend_61                              (multiplied_result_61       ),
        .addend_62                              (multiplied_result_62       ),
        .addend_63                              (multiplied_result_63       ),
        .addend_64                              (multiplied_result_64       ),
        .addend_65                              (multiplied_result_65       ),
        .addend_66                              (multiplied_result_66       ),
        .addend_67                              (multiplied_result_67       ),
        .addend_68                              (multiplied_result_68       ),
        .addend_69                              (multiplied_result_69       ),
        .addend_70                              (multiplied_result_70       ),
        .addend_71                              (multiplied_result_71       ),
        .addend_72                              (multiplied_result_72       ),
        .addend_73                              (multiplied_result_73       ),
        .addend_74                              (multiplied_result_74       ),
        .addend_75                              (multiplied_result_75       ),
        .addend_76                              (multiplied_result_76       ),
        .addend_77                              (multiplied_result_77       ),
        .addend_78                              (multiplied_result_78       ),
        .addend_79                              (multiplied_result_79       ),
        .addend_80                              (multiplied_result_80       ),
        .addend_81                              (multiplied_result_81       ),
        .addend_82                              (multiplied_result_82       ),
        .addend_83                              (multiplied_result_83       ),
        .addend_84                              (multiplied_result_84       ),
        .addend_85                              (multiplied_result_85       ),
        .addend_86                              (multiplied_result_86       ),
        .addend_87                              (multiplied_result_87       ),
        .addend_88                              (multiplied_result_88       ),
        .addend_89                              (multiplied_result_89       ),
        .addend_90                              (multiplied_result_90       ),
        .addend_91                              (multiplied_result_91       ),
        .addend_92                              (multiplied_result_92       ),
        .addend_93                              (multiplied_result_93       ),
        .addend_94                              (multiplied_result_94       ),
        .addend_95                              (multiplied_result_95       ),
        .addend_96                              (multiplied_result_96       ),
        .addend_97                              (multiplied_result_97       ),
        .addend_98                              (multiplied_result_98       ),
        .addend_99                              (multiplied_result_99       ),
        .addend_100                             (multiplied_result_100      ),
        .addend_101                             (multiplied_result_101      ),
        .addend_102                             (multiplied_result_102      ),
        .addend_103                             (multiplied_result_103      ),
        .addend_104                             (multiplied_result_104      ),
        .addend_105                             (multiplied_result_105      ),
        .addend_106                             (multiplied_result_106      ),
        .addend_107                             (multiplied_result_107      ),

        .bias                                   (bias_buffed                ),

        .adder_tree_result                      (adder_tree_result          ),
        .adder_tree_result_enable               (adder_tree_result_enable   )
    );

    LAST_ACC
    #(
      .Q_INT_INPUT                             (Q_INT_INTERIM_2            ),
      .Q_FRAC_INTPUT                           (Q_FRAC_INTERIM_2           ),
      .Q_INT_OUTPUT                            (Q_INT_INTERIM_5            ),
      .Q_FRAC_OUTPUT                           (Q_FRAC_INTERIM_5           )
    )
    last_acc_inst
    (
      .clk                                     (clk                        ),
      .rst_n                                   (rst_n                      ),
      .last_acc_enable                         (adder_tree_result_enable   ),
      .addend                                  (adder_tree_result          ),
      .last_acc_result_enable                  (last_acc_result_enable     ),
      .last_acc_result                         (last_acc_result            )
    );
    SCALE_1
    #(
        .Q_INT_OPERAND                          (Q_INT_INTERIM_2            ),
        .Q_FRAC_OPERAND                         (Q_FRAC_INTERIM_2           ),
        .Q_INT_SCALE                            (Q_INT_SCALE_1              ),
        .Q_FRAC_SCALE                           (Q_FRAC_SCALE_1             ),
        .Q_INT_OUTPUT                           (Q_INT_INTERIM_3            ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_INTERIM_3           )
    )
    scale_1_inst
    (
        .clk                                    (clk                        ),
        .rst_n                                  (rst_n                      ),
        .layer_bits                             (layer_bits                 ),
        .scale_1_enable                         (adder_tree_result_enable   ),
        .operand                                (adder_tree_result          ),
        .scale_1_result_enable                  (scale_1_result_enable      ),
        .result                                 (scale_1_result             )
    );

    PReLU
    #(
        .Q_INT_data                             (Q_INT_INTERIM_3            ),
        .Q_FRAC_data                            (Q_FRAC_INTERIM_3           ),
        .Q_INT_slope                            (Q_INT_SLOPE                ),
        .Q_FRAC_slope                           (Q_FRAC_SLOPE               ),
        .Q_INT_result                           (Q_INT_INTERIM_4            ),
        .Q_FRAC_result                          (Q_FRAC_INTERIM_4           )
    )
    PReLU_inst
    (
        .clk                                    (clk                        ),
        .rst_n                                  (rst_n                      ),
        .PReLU_enable                           (scale_1_result_enable      ),
        .data                                   (scale_1_result             ),
        .slope                                  (slope_in                   ),
        .PReLU_result_enable                    (PReLU_result_enable        ),
        .PReLU_operand_sign                     (PReLU_operand_sign         ),
        .result                                 (PReLU_result               )
    );

    SCALE_2
    #(
        .Q_INT_OPERAND                          (Q_INT_INTERIM_4            ),
        .Q_FRAC_OPERAND                         (Q_FRAC_INTERIM_4           ),
        .Q_INT_SCALE                            (Q_INT_SCALE_2              ),
        .Q_FRAC_SCALE                           (Q_FRAC_SCALE_2             ),
        .Q_INT_OUTPUT                           (Q_INT_OUTPUT               ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_OUTPUT              )
    )
    scale_2_inst
    (
        .clk                                    (clk                        ),
        .rst_n                                  (rst_n                      ),
        .layer_bits                             (layer_bits                 ),
        .scale_2_enable                         (PReLU_result_enable        ),
        .PReLU_operand_sign                     (PReLU_operand_sign         ),
        .operand                                (PReLU_result               ),
        .scale_2_result_enable                  (scale_2_result_enable      ),
        .result                                 (scale_2_result             )
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule
