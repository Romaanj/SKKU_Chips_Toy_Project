module CONV_FIRST_DOT_PRODUCT
#(
    // Assumption: Default data fixed point format = signed Q2.15
    parameter                                                   Q_INT_DATA      = 2     ,
    parameter                                                   Q_FRAC_DATA     = 15    ,

    // Assumption: Default weight fixed point format = signed Q1.15
    parameter                                                   Q_INT_WEIGHT    = 1     ,
    parameter                                                   Q_FRAC_WEIGHT   = 15    ,

    // Assumption: Default weight fixed point format = signed Q1.15
    parameter                                                   Q_INT_BIAS      = 1     ,
    parameter                                                   Q_FRAC_BIAS     = 15    ,

    // Assumption: Default output fixed point format = signed Q3.30
    parameter                                                   Q_INT_OUTPUT    = 3     ,
    parameter                                                   Q_FRAC_OUTPUT   = 30
)
(
    input                                                       clk                     ,
    input                                                       rst_n                   ,

    input                                                       dot_product_enable      ,

    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_0                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_1                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_2                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_3                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_4                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_5                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_6                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_7                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_8                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_9                  ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_10                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_11                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_12                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_13                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_14                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_15                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_16                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_17                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_18                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_19                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_20                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_21                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_22                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_23                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_24                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_25                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_26                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_27                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_28                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_29                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_30                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_31                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_32                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_33                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_34                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_35                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_36                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_37                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_38                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_39                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_40                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_41                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_42                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_43                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_44                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_45                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_46                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_47                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_48                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_49                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_50                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_51                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_52                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_53                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_54                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_55                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_56                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_57                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_58                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_59                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_60                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_61                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_62                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_63                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_64                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_65                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_66                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_67                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_68                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_69                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_70                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_71                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_72                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_73                 ,
    input signed        [Q_INT_DATA + Q_FRAC_DATA -1:0]         data_74                 ,

    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_0                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_1                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_2                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_3                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_4                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_5                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_6                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_7                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_8                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_9                ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_10               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_11               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_12               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_13               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_14               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_15               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_16               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_17               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_18               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_19               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_20               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_21               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_22               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_23               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_24               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_25               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_26               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_27               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_28               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_29               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_30               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_31               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_32               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_33               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_34               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_35               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_36               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_37               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_38               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_39               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_40               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_41               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_42               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_43               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_44               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_45               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_46               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_47               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_48               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_49               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_50               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_51               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_52               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_53               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_54               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_55               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_56               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_57               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_58               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_59               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_60               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_61               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_62               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_63               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_64               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_65               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_66               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_67               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_68               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_69               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_70               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_71               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_72               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_73               ,
    input signed        [Q_INT_WEIGHT + Q_FRAC_WEIGHT -1:0]     weight_74               ,

    input signed        [Q_INT_BIAS + Q_FRAC_BIAS -1:0]         bias_i                  ,

    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_0                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_1                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_2                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_3                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_4                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_5                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_6                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_7                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_8                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_9                ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_10               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_11               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_12               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_13               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_14               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_15               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_16               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_17               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_18               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_19               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_20               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_21               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_22               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_23               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_24               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_25               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_26               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_27               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_28               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_29               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_30               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_31               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_32               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_33               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_34               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_35               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_36               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_37               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_38               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_39               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_40               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_41               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_42               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_43               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_44               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_45               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_46               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_47               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_48               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_49               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_50               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_51               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_52               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_53               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_54               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_55               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_56               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_57               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_58               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_59               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_60               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_61               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_62               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_63               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_64               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_65               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_66               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_67               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_68               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_69               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_70               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_71               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_72               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_73               ,
    output reg signed   [Q_INT_OUTPUT + Q_FRAC_OUTPUT -1:0]     result_74               ,

    output reg signed   [Q_INT_BIAS + Q_FRAC_BIAS -1:0]         bias_o                  ,

    output reg                                                  adder_tree_enable
);

    wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_data      [0:74]          ;
    wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_weight    [0:74]          ;

    // sign extension: Qa.b -> Q(a+x).b
    assign internal_data[0]         = data_0                                            ;
    assign internal_data[1]         = data_1                                            ;
    assign internal_data[2]         = data_2                                            ;
    assign internal_data[3]         = data_3                                            ;
    assign internal_data[4]         = data_4                                            ;
    assign internal_data[5]         = data_5                                            ;
    assign internal_data[6]         = data_6                                            ;
    assign internal_data[7]         = data_7                                            ;
    assign internal_data[8]         = data_8                                            ;
    assign internal_data[9]         = data_9                                            ;
    assign internal_data[10]        = data_10                                           ;
    assign internal_data[11]        = data_11                                           ;
    assign internal_data[12]        = data_12                                           ;
    assign internal_data[13]        = data_13                                           ;
    assign internal_data[14]        = data_14                                           ;
    assign internal_data[15]        = data_15                                           ;
    assign internal_data[16]        = data_16                                           ;
    assign internal_data[17]        = data_17                                           ;
    assign internal_data[18]        = data_18                                           ;
    assign internal_data[19]        = data_19                                           ;
    assign internal_data[20]        = data_20                                           ;
    assign internal_data[21]        = data_21                                           ;
    assign internal_data[22]        = data_22                                           ;
    assign internal_data[23]        = data_23                                           ;
    assign internal_data[24]        = data_24                                           ;
    assign internal_data[25]        = data_25                                           ;
    assign internal_data[26]        = data_26                                           ;
    assign internal_data[27]        = data_27                                           ;
    assign internal_data[28]        = data_28                                           ;
    assign internal_data[29]        = data_29                                           ;
    assign internal_data[30]        = data_30                                           ;
    assign internal_data[31]        = data_31                                           ;
    assign internal_data[32]        = data_32                                           ;
    assign internal_data[33]        = data_33                                           ;
    assign internal_data[34]        = data_34                                           ;
    assign internal_data[35]        = data_35                                           ;
    assign internal_data[36]        = data_36                                           ;
    assign internal_data[37]        = data_37                                           ;
    assign internal_data[38]        = data_38                                           ;
    assign internal_data[39]        = data_39                                           ;
    assign internal_data[40]        = data_40                                           ;
    assign internal_data[41]        = data_41                                           ;
    assign internal_data[42]        = data_42                                           ;
    assign internal_data[43]        = data_43                                           ;
    assign internal_data[44]        = data_44                                           ;
    assign internal_data[45]        = data_45                                           ;
    assign internal_data[46]        = data_46                                           ;
    assign internal_data[47]        = data_47                                           ;
    assign internal_data[48]        = data_48                                           ;
    assign internal_data[49]        = data_49                                           ;
    assign internal_data[50]        = data_50                                           ;
    assign internal_data[51]        = data_51                                           ;
    assign internal_data[52]        = data_52                                           ;
    assign internal_data[53]        = data_53                                           ;
    assign internal_data[54]        = data_54                                           ;
    assign internal_data[55]        = data_55                                           ;
    assign internal_data[56]        = data_56                                           ;
    assign internal_data[57]        = data_57                                           ;
    assign internal_data[58]        = data_58                                           ;
    assign internal_data[59]        = data_59                                           ;
    assign internal_data[60]        = data_60                                           ;
    assign internal_data[61]        = data_61                                           ;
    assign internal_data[62]        = data_62                                           ;
    assign internal_data[63]        = data_63                                           ;
    assign internal_data[64]        = data_64                                           ;
    assign internal_data[65]        = data_65                                           ;
    assign internal_data[66]        = data_66                                           ;
    assign internal_data[67]        = data_67                                           ;
    assign internal_data[68]        = data_68                                           ;
    assign internal_data[69]        = data_69                                           ;
    assign internal_data[70]        = data_70                                           ;
    assign internal_data[71]        = data_71                                           ;
    assign internal_data[72]        = data_72                                           ;
    assign internal_data[73]        = data_73                                           ;
    assign internal_data[74]        = data_74                                           ;

    assign internal_weight[0]       = weight_0                                          ;
    assign internal_weight[1]       = weight_1                                          ;
    assign internal_weight[2]       = weight_2                                          ;
    assign internal_weight[3]       = weight_3                                          ;
    assign internal_weight[4]       = weight_4                                          ;
    assign internal_weight[5]       = weight_5                                          ;
    assign internal_weight[6]       = weight_6                                          ;
    assign internal_weight[7]       = weight_7                                          ;
    assign internal_weight[8]       = weight_8                                          ;
    assign internal_weight[9]       = weight_9                                          ;
    assign internal_weight[10]      = weight_10                                         ;
    assign internal_weight[11]      = weight_11                                         ;
    assign internal_weight[12]      = weight_12                                         ;
    assign internal_weight[13]      = weight_13                                         ;
    assign internal_weight[14]      = weight_14                                         ;
    assign internal_weight[15]      = weight_15                                         ;
    assign internal_weight[16]      = weight_16                                         ;
    assign internal_weight[17]      = weight_17                                         ;
    assign internal_weight[18]      = weight_18                                         ;
    assign internal_weight[19]      = weight_19                                         ;
    assign internal_weight[20]      = weight_20                                         ;
    assign internal_weight[21]      = weight_21                                         ;
    assign internal_weight[22]      = weight_22                                         ;
    assign internal_weight[23]      = weight_23                                         ;
    assign internal_weight[24]      = weight_24                                         ;
    assign internal_weight[25]      = weight_25                                         ;
    assign internal_weight[26]      = weight_26                                         ;
    assign internal_weight[27]      = weight_27                                         ;
    assign internal_weight[28]      = weight_28                                         ;
    assign internal_weight[29]      = weight_29                                         ;
    assign internal_weight[30]      = weight_30                                         ;
    assign internal_weight[31]      = weight_31                                         ;
    assign internal_weight[32]      = weight_32                                         ;
    assign internal_weight[33]      = weight_33                                         ;
    assign internal_weight[34]      = weight_34                                         ;
    assign internal_weight[35]      = weight_35                                         ;
    assign internal_weight[36]      = weight_36                                         ;
    assign internal_weight[37]      = weight_37                                         ;
    assign internal_weight[38]      = weight_38                                         ;
    assign internal_weight[39]      = weight_39                                         ;
    assign internal_weight[40]      = weight_40                                         ;
    assign internal_weight[41]      = weight_41                                         ;
    assign internal_weight[42]      = weight_42                                         ;
    assign internal_weight[43]      = weight_43                                         ;
    assign internal_weight[44]      = weight_44                                         ;
    assign internal_weight[45]      = weight_45                                         ;
    assign internal_weight[46]      = weight_46                                         ;
    assign internal_weight[47]      = weight_47                                         ;
    assign internal_weight[48]      = weight_48                                         ;
    assign internal_weight[49]      = weight_49                                         ;
    assign internal_weight[50]      = weight_50                                         ;
    assign internal_weight[51]      = weight_51                                         ;
    assign internal_weight[52]      = weight_52                                         ;
    assign internal_weight[53]      = weight_53                                         ;
    assign internal_weight[54]      = weight_54                                         ;
    assign internal_weight[55]      = weight_55                                         ;
    assign internal_weight[56]      = weight_56                                         ;
    assign internal_weight[57]      = weight_57                                         ;
    assign internal_weight[58]      = weight_58                                         ;
    assign internal_weight[59]      = weight_59                                         ;
    assign internal_weight[60]      = weight_60                                         ;
    assign internal_weight[61]      = weight_61                                         ;
    assign internal_weight[62]      = weight_62                                         ;
    assign internal_weight[63]      = weight_63                                         ;
    assign internal_weight[64]      = weight_64                                         ;
    assign internal_weight[65]      = weight_65                                         ;
    assign internal_weight[66]      = weight_66                                         ;
    assign internal_weight[67]      = weight_67                                         ;
    assign internal_weight[68]      = weight_68                                         ;
    assign internal_weight[69]      = weight_69                                         ;
    assign internal_weight[70]      = weight_70                                         ;
    assign internal_weight[71]      = weight_71                                         ;
    assign internal_weight[72]      = weight_72                                         ;
    assign internal_weight[73]      = weight_73                                         ;
    assign internal_weight[74]      = weight_74                                         ;

    always @(posedge clk) begin
        if(!rst_n) begin
            result_0       <= 'b0                                                       ;
            result_1       <= 'b0                                                       ;
            result_2       <= 'b0                                                       ;
            result_3       <= 'b0                                                       ;
            result_4       <= 'b0                                                       ;
            result_5       <= 'b0                                                       ;
            result_6       <= 'b0                                                       ;
            result_7       <= 'b0                                                       ;
            result_8       <= 'b0                                                       ;
            result_9       <= 'b0                                                       ;
            result_10      <= 'b0                                                       ;
            result_11      <= 'b0                                                       ;
            result_12      <= 'b0                                                       ;
            result_13      <= 'b0                                                       ;
            result_14      <= 'b0                                                       ;
            result_15      <= 'b0                                                       ;
            result_16      <= 'b0                                                       ;
            result_17      <= 'b0                                                       ;
            result_18      <= 'b0                                                       ;
            result_19      <= 'b0                                                       ;
            result_20      <= 'b0                                                       ;
            result_21      <= 'b0                                                       ;
            result_22      <= 'b0                                                       ;
            result_23      <= 'b0                                                       ;
            result_24      <= 'b0                                                       ;
            result_25      <= 'b0                                                       ;
            result_26      <= 'b0                                                       ;
            result_27      <= 'b0                                                       ;
            result_28      <= 'b0                                                       ;
            result_29      <= 'b0                                                       ;
            result_30      <= 'b0                                                       ;
            result_31      <= 'b0                                                       ;
            result_32      <= 'b0                                                       ;
            result_33      <= 'b0                                                       ;
            result_34      <= 'b0                                                       ;
            result_35      <= 'b0                                                       ;
            result_36      <= 'b0                                                       ;
            result_37      <= 'b0                                                       ;
            result_38      <= 'b0                                                       ;
            result_39      <= 'b0                                                       ;
            result_40      <= 'b0                                                       ;
            result_41      <= 'b0                                                       ;
            result_42      <= 'b0                                                       ;
            result_43      <= 'b0                                                       ;
            result_44      <= 'b0                                                       ;
            result_45      <= 'b0                                                       ;
            result_46      <= 'b0                                                       ;
            result_47      <= 'b0                                                       ;
            result_48      <= 'b0                                                       ;
            result_49      <= 'b0                                                       ;
            result_50      <= 'b0                                                       ;
            result_51      <= 'b0                                                       ;
            result_52      <= 'b0                                                       ;
            result_53      <= 'b0                                                       ;
            result_54      <= 'b0                                                       ;
            result_55      <= 'b0                                                       ;
            result_56      <= 'b0                                                       ;
            result_57      <= 'b0                                                       ;
            result_58      <= 'b0                                                       ;
            result_59      <= 'b0                                                       ;
            result_60      <= 'b0                                                       ;
            result_61      <= 'b0                                                       ;
            result_62      <= 'b0                                                       ;
            result_63      <= 'b0                                                       ;
            result_64      <= 'b0                                                       ;
            result_65      <= 'b0                                                       ;
            result_66      <= 'b0                                                       ;
            result_67      <= 'b0                                                       ;
            result_68      <= 'b0                                                       ;
            result_69      <= 'b0                                                       ;
            result_70      <= 'b0                                                       ;
            result_71      <= 'b0                                                       ;
            result_72      <= 'b0                                                       ;
            result_73      <= 'b0                                                       ;
            result_74      <= 'b0                                                       ;
        end
        else if(dot_product_enable) begin
            result_0       <= internal_data[0 ]    * internal_weight[0 ]                ;
            result_1       <= internal_data[1 ]    * internal_weight[1 ]                ;
            result_2       <= internal_data[2 ]    * internal_weight[2 ]                ;
            result_3       <= internal_data[3 ]    * internal_weight[3 ]                ;
            result_4       <= internal_data[4 ]    * internal_weight[4 ]                ;
            result_5       <= internal_data[5 ]    * internal_weight[5 ]                ;
            result_6       <= internal_data[6 ]    * internal_weight[6 ]                ;
            result_7       <= internal_data[7 ]    * internal_weight[7 ]                ;
            result_8       <= internal_data[8 ]    * internal_weight[8 ]                ;
            result_9       <= internal_data[9 ]    * internal_weight[9 ]                ;
            result_10      <= internal_data[10]    * internal_weight[10]                ;
            result_11      <= internal_data[11]    * internal_weight[11]                ;
            result_12      <= internal_data[12]    * internal_weight[12]                ;
            result_13      <= internal_data[13]    * internal_weight[13]                ;
            result_14      <= internal_data[14]    * internal_weight[14]                ;
            result_15      <= internal_data[15]    * internal_weight[15]                ;
            result_16      <= internal_data[16]    * internal_weight[16]                ;
            result_17      <= internal_data[17]    * internal_weight[17]                ;
            result_18      <= internal_data[18]    * internal_weight[18]                ;
            result_19      <= internal_data[19]    * internal_weight[19]                ;
            result_20      <= internal_data[20]    * internal_weight[20]                ;
            result_21      <= internal_data[21]    * internal_weight[21]                ;
            result_22      <= internal_data[22]    * internal_weight[22]                ;
            result_23      <= internal_data[23]    * internal_weight[23]                ;
            result_24      <= internal_data[24]    * internal_weight[24]                ;
            result_25      <= internal_data[25]    * internal_weight[25]                ;
            result_26      <= internal_data[26]    * internal_weight[26]                ;
            result_27      <= internal_data[27]    * internal_weight[27]                ;
            result_28      <= internal_data[28]    * internal_weight[28]                ;
            result_29      <= internal_data[29]    * internal_weight[29]                ;
            result_30      <= internal_data[30]    * internal_weight[30]                ;
            result_31      <= internal_data[31]    * internal_weight[31]                ;
            result_32      <= internal_data[32]    * internal_weight[32]                ;
            result_33      <= internal_data[33]    * internal_weight[33]                ;
            result_34      <= internal_data[34]    * internal_weight[34]                ;
            result_35      <= internal_data[35]    * internal_weight[35]                ;
            result_36      <= internal_data[36]    * internal_weight[36]                ;
            result_37      <= internal_data[37]    * internal_weight[37]                ;
            result_38      <= internal_data[38]    * internal_weight[38]                ;
            result_39      <= internal_data[39]    * internal_weight[39]                ;
            result_40      <= internal_data[40]    * internal_weight[40]                ;
            result_41      <= internal_data[41]    * internal_weight[41]                ;
            result_42      <= internal_data[42]    * internal_weight[42]                ;
            result_43      <= internal_data[43]    * internal_weight[43]                ;
            result_44      <= internal_data[44]    * internal_weight[44]                ;
            result_45      <= internal_data[45]    * internal_weight[45]                ;
            result_46      <= internal_data[46]    * internal_weight[46]                ;
            result_47      <= internal_data[47]    * internal_weight[47]                ;
            result_48      <= internal_data[48]    * internal_weight[48]                ;
            result_49      <= internal_data[49]    * internal_weight[49]                ;
            result_50      <= internal_data[50]    * internal_weight[50]                ;
            result_51      <= internal_data[51]    * internal_weight[51]                ;
            result_52      <= internal_data[52]    * internal_weight[52]                ;
            result_53      <= internal_data[53]    * internal_weight[53]                ;
            result_54      <= internal_data[54]    * internal_weight[54]                ;
            result_55      <= internal_data[55]    * internal_weight[55]                ;
            result_56      <= internal_data[56]    * internal_weight[56]                ;
            result_57      <= internal_data[57]    * internal_weight[57]                ;
            result_58      <= internal_data[58]    * internal_weight[58]                ;
            result_59      <= internal_data[59]    * internal_weight[59]                ;
            result_60      <= internal_data[60]    * internal_weight[60]                ;
            result_61      <= internal_data[61]    * internal_weight[61]                ;
            result_62      <= internal_data[62]    * internal_weight[62]                ;
            result_63      <= internal_data[63]    * internal_weight[63]                ;
            result_64      <= internal_data[64]    * internal_weight[64]                ;
            result_65      <= internal_data[65]    * internal_weight[65]                ;
            result_66      <= internal_data[66]    * internal_weight[66]                ;
            result_67      <= internal_data[67]    * internal_weight[67]                ;
            result_68      <= internal_data[68]    * internal_weight[68]                ;
            result_69      <= internal_data[69]    * internal_weight[69]                ;
            result_70      <= internal_data[70]    * internal_weight[70]                ;
            result_71      <= internal_data[71]    * internal_weight[71]                ;
            result_72      <= internal_data[72]    * internal_weight[72]                ;
            result_73      <= internal_data[73]    * internal_weight[73]                ;
            result_74      <= internal_data[74]    * internal_weight[74]                ;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            bias_o                  <= 'b0;
        end
        else if (dot_product_enable) begin
            bias_o                  <= bias_i;
        end
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            adder_tree_enable       <= 1'b0;
        end
        else if(dot_product_enable) begin
            adder_tree_enable       <= 1'b1;
        end
        else if(adder_tree_enable) begin
            adder_tree_enable       <= 1'b0;
        end
    end

endmodule