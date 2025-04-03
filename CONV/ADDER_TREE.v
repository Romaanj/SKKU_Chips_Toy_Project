module CONV_FIRST_ADDER_TREE
#(
    // Default fixed point format = signed Q1.15
    parameter                               Q_INT           = 1                         ,
    parameter                               Q_FRAC          = 15                        ,
)
(
    input                                   clk                                         ,
    input                                   rst_n                                       ,
    input                                   adder_tree_middle_stage_enable              ,

    input signed [width_addend-1:0]         addend_0                                    ,
    input signed [width_addend-1:0]         addend_1                                    ,
    input signed [width_addend-1:0]         addend_2                                    ,
    input signed [width_addend-1:0]         addend_3                                    ,
    input signed [width_addend-1:0]         addend_4                                    ,
    input signed [width_addend-1:0]         addend_5                                    ,
    input signed [width_addend-1:0]         addend_6                                    ,
    input signed [width_addend-1:0]         addend_7                                    ,
    input signed [width_addend-1:0]         addend_8                                    ,
    input signed [width_addend-1:0]         addend_9                                    ,
    input signed [width_addend-1:0]         addend_10                                   ,
    input signed [width_addend-1:0]         addend_11                                   ,
    input signed [width_addend-1:0]         addend_12                                   ,
    input signed [width_addend-1:0]         addend_13                                   ,
    input signed [width_addend-1:0]         addend_14                                   ,
    input signed [width_addend-1:0]         addend_15                                   ,
    input signed [width_addend-1:0]         addend_16                                   ,
    input signed [width_addend-1:0]         addend_17                                   ,
    input signed [width_addend-1:0]         addend_18                                   ,
    input signed [width_addend-1:0]         addend_19                                   ,
    input signed [width_addend-1:0]         addend_20                                   ,
    input signed [width_addend-1:0]         addend_21                                   ,
    input signed [width_addend-1:0]         addend_22                                   ,
    input signed [width_addend-1:0]         addend_23                                   ,
    input signed [width_addend-1:0]         addend_24                                   ,
    input signed [width_addend-1:0]         addend_25                                   ,
    input signed [width_addend-1:0]         addend_26                                   ,
    input signed [width_addend-1:0]         addend_27                                   ,
    input signed [width_addend-1:0]         addend_28                                   ,
    input signed [width_addend-1:0]         addend_29                                   ,
    input signed [width_addend-1:0]         addend_30                                   ,
    input signed [width_addend-1:0]         addend_31                                   ,
    input signed [width_addend-1:0]         addend_32                                   ,
    input signed [width_addend-1:0]         addend_33                                   ,
    input signed [width_addend-1:0]         addend_34                                   ,
    input signed [width_addend-1:0]         addend_35                                   ,
    input signed [width_addend-1:0]         addend_36                                   ,
    input signed [width_addend-1:0]         addend_37                                   ,
    input signed [width_addend-1:0]         addend_38                                   ,
    input signed [width_addend-1:0]         addend_39                                   ,
    input signed [width_addend-1:0]         addend_40                                   ,
    input signed [width_addend-1:0]         addend_41                                   ,
    input signed [width_addend-1:0]         addend_42                                   ,
    input signed [width_addend-1:0]         addend_43                                   ,
    input signed [width_addend-1:0]         addend_44                                   ,
    input signed [width_addend-1:0]         addend_45                                   ,
    input signed [width_addend-1:0]         addend_46                                   ,
    input signed [width_addend-1:0]         addend_47                                   ,
    input signed [width_addend-1:0]         addend_48                                   ,
    input signed [width_addend-1:0]         addend_49                                   ,
    input signed [width_addend-1:0]         addend_50                                   ,
    input signed [width_addend-1:0]         addend_51                                   ,
    input signed [width_addend-1:0]         addend_52                                   ,
    input signed [width_addend-1:0]         addend_53                                   ,
    input signed [width_addend-1:0]         addend_54                                   ,
    input signed [width_addend-1:0]         addend_55                                   ,
    input signed [width_addend-1:0]         addend_56                                   ,
    input signed [width_addend-1:0]         addend_57                                   ,
    input signed [width_addend-1:0]         addend_58                                   ,
    input signed [width_addend-1:0]         addend_59                                   ,
    input signed [width_addend-1:0]         addend_60                                   ,
    input signed [width_addend-1:0]         addend_61                                   ,
    input signed [width_addend-1:0]         addend_62                                   ,
    input signed [width_addend-1:0]         addend_63                                   ,
    input signed [width_addend-1:0]         addend_64                                   ,
    input signed [width_addend-1:0]         addend_65                                   ,
    input signed [width_addend-1:0]         addend_66                                   ,
    input signed [width_addend-1:0]         addend_67                                   ,
    input signed [width_addend-1:0]         addend_68                                   ,
    input signed [width_addend-1:0]         addend_69                                   ,
    input signed [width_addend-1:0]         addend_70                                   ,
    input signed [width_addend-1:0]         addend_71                                   ,
    input signed [width_addend-1:0]         addend_72                                   ,
    input signed [width_addend-1:0]         addend_73                                   ,
    input signed [width_addend-1:0]         addend_74                                   ,
    input signed [width_bias-1  :0]         bias                                        ,

    output reg signed [width_output-1:0]    adder_tree_result                           ,
    output reg                              adder_tree_result_enable
)

    localparam                              width_addend    = 2 * (Q_INT + Q_FRAC)      ;
    localparam                              width_bias      = Q_INT + Q_FRAC            ;
    localparam                              width_output    = Q_INT + Q_FRAC            ;

    localparam                              width_stage_1   = width_addend  + 1         ;
    localparam                              width_stage_2   = width_stage_1 + 1         ;
    localparam                              width_stage_3   = width_stage_2 + 1         ;
    localparam                              width_stage_4   = width_stage_3 + 1         ;
    localparam                              width_stage_5   = width_stage_4 + 1         ;
    localparam                              width_stage_6   = width_stage_5 + 1         ;
    localparam                              width_stage_7   = width_stage_6 + 1         ;

    wire signed [width_stage_1-1:0]         stage_1_result[0:37]                        ; // 76 = 38 * 2
    wire signed [width_stage_2-1:0]         stage_2_result[0:18]                        ; // 38 = 19 * 2
    wire signed [width_stage_3-1:0]         stage_3_result[0:9]                         ; // 19 = 9 * 2 + 1
    wire signed [width_stage_4-1:0]         stage_4_result[0:4]                         ; // 10 = 5 * 2
    wire signed [width_stage_5-1:0]         stage_5_result[0:2]                         ; // 5  = 2 * 2 + 1
    wire signed [width_stage_6-1:0]         stage_6_result[0:1]                         ; // 3  = 1 * 2 + 1
    wire signed [width_stage_7-1:0]         stage_7_result                              ; // 2  = 1 * 2

    reg signed  [width_stage_4-1:0]         stage_4_result_reg[0:4]                     ;

    // -------------------------------------------------------------------------------
    // stage 1 start
    // -------------------------------------------------------------------------------

    assign stage_1_result[0]    = addend_0              +   addend_1            ;
    assign stage_1_result[1]    = addend_2              +   addend_3            ;
    assign stage_1_result[2]    = addend_4              +   addend_5            ;
    assign stage_1_result[3]    = addend_6              +   addend_7            ;
    assign stage_1_result[4]    = addend_8              +   addend_9            ;
    assign stage_1_result[5]    = addend_10             +   addend_11           ;
    assign stage_1_result[6]    = addend_12             +   addend_13           ;
    assign stage_1_result[7]    = addend_14             +   addend_15           ;
    assign stage_1_result[8]    = addend_16             +   addend_17           ;
    assign stage_1_result[9]    = addend_18             +   addend_19           ;
    assign stage_1_result[10]   = addend_20             +   addend_21           ;
    assign stage_1_result[11]   = addend_22             +   addend_23           ;
    assign stage_1_result[12]   = addend_24             +   addend_25           ;
    assign stage_1_result[13]   = addend_26             +   addend_27           ;
    assign stage_1_result[14]   = addend_28             +   addend_29           ;
    assign stage_1_result[15]   = addend_30             +   addend_31           ;
    assign stage_1_result[16]   = addend_32             +   addend_33           ;
    assign stage_1_result[17]   = addend_34             +   addend_35           ;
    assign stage_1_result[18]   = addend_36             +   addend_37           ;
    assign stage_1_result[19]   = addend_38             +   addend_39           ;
    assign stage_1_result[20]   = addend_40             +   addend_41           ;
    assign stage_1_result[21]   = addend_42             +   addend_43           ;
    assign stage_1_result[22]   = addend_44             +   addend_45           ;
    assign stage_1_result[23]   = addend_46             +   addend_47           ;
    assign stage_1_result[24]   = addend_48             +   addend_49           ;
    assign stage_1_result[25]   = addend_50             +   addend_51           ;
    assign stage_1_result[26]   = addend_52             +   addend_53           ;
    assign stage_1_result[27]   = addend_54             +   addend_55           ;
    assign stage_1_result[28]   = addend_56             +   addend_57           ;
    assign stage_1_result[29]   = addend_58             +   addend_59           ;
    assign stage_1_result[30]   = addend_60             +   addend_61           ;
    assign stage_1_result[31]   = addend_62             +   addend_63           ;
    assign stage_1_result[32]   = addend_64             +   addend_65           ;
    assign stage_1_result[33]   = addend_66             +   addend_67           ;
    assign stage_1_result[34]   = addend_68             +   addend_69           ;
    assign stage_1_result[35]   = addend_70             +   addend_71           ;
    assign stage_1_result[36]   = addend_72             +   addend_73           ;
    assign stage_1_result[37]   = addend_74             +   bias                ;
    
    // -------------------------------------------------------------------------------
    // stage 1 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 2 start
    // -------------------------------------------------------------------------------

    assign stage_2_result[0]    = stage_1_result[ 0]    +   stage_1_result[ 1]  ;
    assign stage_2_result[1]    = stage_1_result[ 2]    +   stage_1_result[ 3]  ;
    assign stage_2_result[2]    = stage_1_result[ 4]    +   stage_1_result[ 5]  ;
    assign stage_2_result[3]    = stage_1_result[ 6]    +   stage_1_result[ 7]  ;
    assign stage_2_result[4]    = stage_1_result[ 8]    +   stage_1_result[ 9]  ;
    assign stage_2_result[5]    = stage_1_result[10]    +   stage_1_result[11]  ;
    assign stage_2_result[6]    = stage_1_result[12]    +   stage_1_result[13]  ;
    assign stage_2_result[7]    = stage_1_result[14]    +   stage_1_result[15]  ;
    assign stage_2_result[8]    = stage_1_result[16]    +   stage_1_result[17]  ;
    assign stage_2_result[9]    = stage_1_result[18]    +   stage_1_result[19]  ;
    assign stage_2_result[10]   = stage_1_result[20]    +   stage_1_result[21]  ;
    assign stage_2_result[11]   = stage_1_result[22]    +   stage_1_result[23]  ;
    assign stage_2_result[12]   = stage_1_result[24]    +   stage_1_result[25]  ;
    assign stage_2_result[13]   = stage_1_result[26]    +   stage_1_result[27]  ;
    assign stage_2_result[14]   = stage_1_result[28]    +   stage_1_result[29]  ;
    assign stage_2_result[15]   = stage_1_result[30]    +   stage_1_result[31]  ;
    assign stage_2_result[16]   = stage_1_result[32]    +   stage_1_result[33]  ;
    assign stage_2_result[17]   = stage_1_result[34]    +   stage_1_result[35]  ;
    assign stage_2_result[18]   = stage_1_result[36]    +   stage_1_result[37]  ;

    // -------------------------------------------------------------------------------
    // stage 2 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 3 start
    // -------------------------------------------------------------------------------

    assign stage_3_result[0]    = stage_2_result[ 0]    +   stage_2_result[ 1]  ;
    assign stage_3_result[1]    = stage_2_result[ 2]    +   stage_2_result[ 3]  ;
    assign stage_3_result[2]    = stage_2_result[ 4]    +   stage_2_result[ 5]  ;
    assign stage_3_result[3]    = stage_2_result[ 6]    +   stage_2_result[ 7]  ;
    assign stage_3_result[4]    = stage_2_result[ 8]    +   stage_2_result[ 9]  ;
    assign stage_3_result[5]    = stage_2_result[10]    +   stage_2_result[11]  ;
    assign stage_3_result[6]    = stage_2_result[12]    +   stage_2_result[13]  ;
    assign stage_3_result[7]    = stage_2_result[14]    +   stage_2_result[15]  ;
    assign stage_3_result[8]    = stage_2_result[16]    +   stage_2_result[17]  ;
    assign stage_3_result[9]    = stage_2_result[18]                            ;

    // -------------------------------------------------------------------------------
    // stage 3 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 4 start
    // -------------------------------------------------------------------------------

    assign stage_4_result[0]    = stage_3_result[0]     +   stage_3_result[1]   ;
    assign stage_4_result[1]    = stage_3_result[2]     +   stage_3_result[3]   ;
    assign stage_4_result[2]    = stage_3_result[4]     +   stage_3_result[5]   ;
    assign stage_4_result[3]    = stage_3_result[6]     +   stage_3_result[7]   ;
    assign stage_4_result[4]    = stage_3_result[8]     +   stage_3_result[9]   ;

    // -------------------------------------------------------------------------------
    // stage 4 end
    // -------------------------------------------------------------------------------

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
    // stage 5 start
    // -------------------------------------------------------------------------------

    assign stage_5_result[0]    = stage_4_result_reg[0] +   stage_4_result_reg[1]   ;
    assign stage_5_result[1]    = stage_4_result_reg[2] +   stage_4_result_reg[3]   ;
    assign stage_5_result[2]    = stage_4_result_reg[4]                             ;

    // -------------------------------------------------------------------------------
    // stage 5 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 6 start
    // -------------------------------------------------------------------------------

    assign stage_6_result[0]    = stage_5_result[0]     +   stage_5_result[1]   ;
    assign stage_6_result[1]    = stage_5_result[2]                             ;

    // -------------------------------------------------------------------------------
    // stage 6 end
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // stage 7 start
    // -------------------------------------------------------------------------------

    assign stage_7_result[0]    = stage_6_result[0]     +   stage_6_result[1]   ;

    // -------------------------------------------------------------------------------
    // stage 7 end
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            adder_tree_result   <= 'd0;
        end
        else if (adder_tree_result_enable) begin
            adder_tree_result   <= stage_7_result >> (width_stage_7 - width_output);
        end
    end

endmodule
