module PARAM_LOADER
#(
    // Assumption: Default weight fixed point format = signed Q8.0
    parameter                                       Q_INT_WEIGHT        = 8         ,
    parameter                                       Q_FRAC_WEIGHT       = 0         ,

    // Assumption: Default bias fixed point format = signed Q8.0
    parameter                                       Q_INT_BIAS          = 8         ,
    parameter                                       Q_FRAC_BIAS         = 0         ,

    // Assumption: Default slope fixed point format = signed Q8.0
    parameter                                       Q_INT_SLOPE         = 8         ,
    parameter                                       Q_FRAC_SLOPE        = 0
)
(
    input                                           clk                             ,
    input                                           rst_n                           ,

    input                                           PARAMETER_valid                 ,
    input [2:0]                                     PARAMETER_layer                 ,
    input [1:0]                                     PARAMETER_type                  ,
    input [31:0]                                    PARAMETER                       ,

    input                                           load_enable                     ,

    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_0                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_1                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_2                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_3                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_4                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_5                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_6                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_7                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_8                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_9                     ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_10                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_11                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_12                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_13                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_14                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_15                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_16                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_17                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_18                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_19                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_20                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_21                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_22                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_23                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_24                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_25                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_26                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_27                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_28                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_29                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_30                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_31                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_32                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_33                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_34                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_35                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_36                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_37                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_38                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_39                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_40                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_41                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_42                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_43                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_44                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_45                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_46                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_47                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_48                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_49                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_50                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_51                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_52                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_53                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_54                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_55                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_56                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_57                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_58                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_59                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_60                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_61                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_62                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_63                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_64                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_65                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_66                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_67                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_68                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_69                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_70                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_71                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_72                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_73                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_74                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_75                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_76                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_77                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_78                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_79                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_80                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_81                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_82                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_83                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_84                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_85                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_86                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_87                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_88                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_89                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_90                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_91                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_92                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_93                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_94                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_95                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_96                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_97                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_98                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_99                    ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_100                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_101                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_102                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_103                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_104                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_105                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_106                   ,
    output reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_in_107                   ,

    output reg [Q_INT_BIAS + Q_FRAC_BIAS - 1:0]     bias_in                         ,
    output reg [Q_INT_SLOPE + Q_FRAC_SLOPE - 1:0]   slope_in           
);

    reg [12:0] weight_cnt;
    always @(posedge clk) begin
        if (!rst_n) begin
            weight_cnt <= 'd0;
        end
        else if (PARAMETER_valid && PARAMETER_type == 'd0) begin
            if (weight_cnt == 'd4532) begin
                weight_cnt <= 'd0;
            end
            else if (PARAMETER_layer == 'd0 && weight_cnt == 'd4196) begin
                weight_cnt <= 'd0;
            end
            else begin
                weight_cnt <= weight_cnt + 'd4;
            end
        end
    end

    reg [Q_INT_WEIGHT + Q_FRAC_WEIGHT - 1:0] weight_buffer [0:4535];
    always @(posedge clk) begin
        if (PARAMETER_valid && PARAMETER_type == 'd0) begin
            weight_buffer[weight_cnt + 0] <= PARAMETER[31 -: 8];
            weight_buffer[weight_cnt + 1] <= PARAMETER[23 -: 8];
            weight_buffer[weight_cnt + 2] <= PARAMETER[15 -: 8];
            weight_buffer[weight_cnt + 3] <= PARAMETER[7 -: 8];
        end
    end

endmodule