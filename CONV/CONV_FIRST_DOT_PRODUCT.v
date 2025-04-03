module CONV_FIRST_DOT_PRODUCT
#(
    parameter                           Q_INT   = 1         ,
    parameter                           Q_FRAC  = 15
)
(
    input                               dot_product_enable  ,

    input signed        [Q_TOT-1:0]     data_0              ,
    input signed        [Q_TOT-1:0]     data_1              ,
    input signed        [Q_TOT-1:0]     data_2              ,
    input signed        [Q_TOT-1:0]     data_3              ,
    input signed        [Q_TOT-1:0]     data_4              ,
    input signed        [Q_TOT-1:0]     data_5              ,
    input signed        [Q_TOT-1:0]     data_6              ,
    input signed        [Q_TOT-1:0]     data_7              ,
    input signed        [Q_TOT-1:0]     data_8              ,
    input signed        [Q_TOT-1:0]     data_9              ,
    input signed        [Q_TOT-1:0]     data_10             ,
    input signed        [Q_TOT-1:0]     data_11             ,
    input signed        [Q_TOT-1:0]     data_12             ,
    input signed        [Q_TOT-1:0]     data_13             ,
    input signed        [Q_TOT-1:0]     data_14             ,
    input signed        [Q_TOT-1:0]     data_15             ,
    input signed        [Q_TOT-1:0]     data_16             ,
    input signed        [Q_TOT-1:0]     data_17             ,
    input signed        [Q_TOT-1:0]     data_18             ,
    input signed        [Q_TOT-1:0]     data_19             ,
    input signed        [Q_TOT-1:0]     data_20             ,
    input signed        [Q_TOT-1:0]     data_21             ,
    input signed        [Q_TOT-1:0]     data_22             ,
    input signed        [Q_TOT-1:0]     data_23             ,
    input signed        [Q_TOT-1:0]     data_24             ,
    input signed        [Q_TOT-1:0]     data_25             ,
    input signed        [Q_TOT-1:0]     data_26             ,
    input signed        [Q_TOT-1:0]     data_27             ,
    input signed        [Q_TOT-1:0]     data_28             ,
    input signed        [Q_TOT-1:0]     data_29             ,
    input signed        [Q_TOT-1:0]     data_30             ,
    input signed        [Q_TOT-1:0]     data_31             ,
    input signed        [Q_TOT-1:0]     data_32             ,
    input signed        [Q_TOT-1:0]     data_33             ,
    input signed        [Q_TOT-1:0]     data_34             ,
    input signed        [Q_TOT-1:0]     data_35             ,
    input signed        [Q_TOT-1:0]     data_36             ,
    input signed        [Q_TOT-1:0]     data_37             ,
    input signed        [Q_TOT-1:0]     data_38             ,
    input signed        [Q_TOT-1:0]     data_39             ,
    input signed        [Q_TOT-1:0]     data_40             ,
    input signed        [Q_TOT-1:0]     data_41             ,
    input signed        [Q_TOT-1:0]     data_42             ,
    input signed        [Q_TOT-1:0]     data_43             ,
    input signed        [Q_TOT-1:0]     data_44             ,
    input signed        [Q_TOT-1:0]     data_45             ,
    input signed        [Q_TOT-1:0]     data_46             ,
    input signed        [Q_TOT-1:0]     data_47             ,
    input signed        [Q_TOT-1:0]     data_48             ,
    input signed        [Q_TOT-1:0]     data_49             ,
    input signed        [Q_TOT-1:0]     data_50             ,
    input signed        [Q_TOT-1:0]     data_51             ,
    input signed        [Q_TOT-1:0]     data_52             ,
    input signed        [Q_TOT-1:0]     data_53             ,
    input signed        [Q_TOT-1:0]     data_54             ,
    input signed        [Q_TOT-1:0]     data_55             ,
    input signed        [Q_TOT-1:0]     data_56             ,
    input signed        [Q_TOT-1:0]     data_57             ,
    input signed        [Q_TOT-1:0]     data_58             ,
    input signed        [Q_TOT-1:0]     data_59             ,
    input signed        [Q_TOT-1:0]     data_60             ,
    input signed        [Q_TOT-1:0]     data_61             ,
    input signed        [Q_TOT-1:0]     data_62             ,
    input signed        [Q_TOT-1:0]     data_63             ,
    input signed        [Q_TOT-1:0]     data_64             ,
    input signed        [Q_TOT-1:0]     data_65             ,
    input signed        [Q_TOT-1:0]     data_66             ,
    input signed        [Q_TOT-1:0]     data_67             ,
    input signed        [Q_TOT-1:0]     data_68             ,
    input signed        [Q_TOT-1:0]     data_69             ,
    input signed        [Q_TOT-1:0]     data_70             ,
    input signed        [Q_TOT-1:0]     data_71             ,
    input signed        [Q_TOT-1:0]     data_72             ,
    input signed        [Q_TOT-1:0]     data_73             ,
    input signed        [Q_TOT-1:0]     data_74             ,

    input signed        [Q_TOT-1:0]     weight_0            ,
    input signed        [Q_TOT-1:0]     weight_1            ,
    input signed        [Q_TOT-1:0]     weight_2            ,
    input signed        [Q_TOT-1:0]     weight_3            ,
    input signed        [Q_TOT-1:0]     weight_4            ,
    input signed        [Q_TOT-1:0]     weight_5            ,
    input signed        [Q_TOT-1:0]     weight_6            ,
    input signed        [Q_TOT-1:0]     weight_7            ,
    input signed        [Q_TOT-1:0]     weight_8            ,
    input signed        [Q_TOT-1:0]     weight_9            ,
    input signed        [Q_TOT-1:0]     weight_10           ,
    input signed        [Q_TOT-1:0]     weight_11           ,
    input signed        [Q_TOT-1:0]     weight_12           ,
    input signed        [Q_TOT-1:0]     weight_13           ,
    input signed        [Q_TOT-1:0]     weight_14           ,
    input signed        [Q_TOT-1:0]     weight_15           ,
    input signed        [Q_TOT-1:0]     weight_16           ,
    input signed        [Q_TOT-1:0]     weight_17           ,
    input signed        [Q_TOT-1:0]     weight_18           ,
    input signed        [Q_TOT-1:0]     weight_19           ,
    input signed        [Q_TOT-1:0]     weight_20           ,
    input signed        [Q_TOT-1:0]     weight_21           ,
    input signed        [Q_TOT-1:0]     weight_22           ,
    input signed        [Q_TOT-1:0]     weight_23           ,
    input signed        [Q_TOT-1:0]     weight_24           ,
    input signed        [Q_TOT-1:0]     weight_25           ,
    input signed        [Q_TOT-1:0]     weight_26           ,
    input signed        [Q_TOT-1:0]     weight_27           ,
    input signed        [Q_TOT-1:0]     weight_28           ,
    input signed        [Q_TOT-1:0]     weight_29           ,
    input signed        [Q_TOT-1:0]     weight_30           ,
    input signed        [Q_TOT-1:0]     weight_31           ,
    input signed        [Q_TOT-1:0]     weight_32           ,
    input signed        [Q_TOT-1:0]     weight_33           ,
    input signed        [Q_TOT-1:0]     weight_34           ,
    input signed        [Q_TOT-1:0]     weight_35           ,
    input signed        [Q_TOT-1:0]     weight_36           ,
    input signed        [Q_TOT-1:0]     weight_37           ,
    input signed        [Q_TOT-1:0]     weight_38           ,
    input signed        [Q_TOT-1:0]     weight_39           ,
    input signed        [Q_TOT-1:0]     weight_40           ,
    input signed        [Q_TOT-1:0]     weight_41           ,
    input signed        [Q_TOT-1:0]     weight_42           ,
    input signed        [Q_TOT-1:0]     weight_43           ,
    input signed        [Q_TOT-1:0]     weight_44           ,
    input signed        [Q_TOT-1:0]     weight_45           ,
    input signed        [Q_TOT-1:0]     weight_46           ,
    input signed        [Q_TOT-1:0]     weight_47           ,
    input signed        [Q_TOT-1:0]     weight_48           ,
    input signed        [Q_TOT-1:0]     weight_49           ,
    input signed        [Q_TOT-1:0]     weight_50           ,
    input signed        [Q_TOT-1:0]     weight_51           ,
    input signed        [Q_TOT-1:0]     weight_52           ,
    input signed        [Q_TOT-1:0]     weight_53           ,
    input signed        [Q_TOT-1:0]     weight_54           ,
    input signed        [Q_TOT-1:0]     weight_55           ,
    input signed        [Q_TOT-1:0]     weight_56           ,
    input signed        [Q_TOT-1:0]     weight_57           ,
    input signed        [Q_TOT-1:0]     weight_58           ,
    input signed        [Q_TOT-1:0]     weight_59           ,
    input signed        [Q_TOT-1:0]     weight_60           ,
    input signed        [Q_TOT-1:0]     weight_61           ,
    input signed        [Q_TOT-1:0]     weight_62           ,
    input signed        [Q_TOT-1:0]     weight_63           ,
    input signed        [Q_TOT-1:0]     weight_64           ,
    input signed        [Q_TOT-1:0]     weight_65           ,
    input signed        [Q_TOT-1:0]     weight_66           ,
    input signed        [Q_TOT-1:0]     weight_67           ,
    input signed        [Q_TOT-1:0]     weight_68           ,
    input signed        [Q_TOT-1:0]     weight_69           ,
    input signed        [Q_TOT-1:0]     weight_70           ,
    input signed        [Q_TOT-1:0]     weight_71           ,
    input signed        [Q_TOT-1:0]     weight_72           ,
    input signed        [Q_TOT-1:0]     weight_73           ,
    input signed        [Q_TOT-1:0]     weight_74           ,

    input signed        [Q_TOT-1:0]     bias_i              ,

    output reg signed   [Q_REG-1:0]     multiply_result_0   ,
    output reg signed   [Q_REG-1:0]     multiply_result_1   ,
    output reg signed   [Q_REG-1:0]     multiply_result_2   ,
    output reg signed   [Q_REG-1:0]     multiply_result_3   ,
    output reg signed   [Q_REG-1:0]     multiply_result_4   ,
    output reg signed   [Q_REG-1:0]     multiply_result_5   ,
    output reg signed   [Q_REG-1:0]     multiply_result_6   ,
    output reg signed   [Q_REG-1:0]     multiply_result_7   ,
    output reg signed   [Q_REG-1:0]     multiply_result_8   ,
    output reg signed   [Q_REG-1:0]     multiply_result_9   ,
    output reg signed   [Q_REG-1:0]     multiply_result_10  ,
    output reg signed   [Q_REG-1:0]     multiply_result_11  ,
    output reg signed   [Q_REG-1:0]     multiply_result_12  ,
    output reg signed   [Q_REG-1:0]     multiply_result_13  ,
    output reg signed   [Q_REG-1:0]     multiply_result_14  ,
    output reg signed   [Q_REG-1:0]     multiply_result_15  ,
    output reg signed   [Q_REG-1:0]     multiply_result_16  ,
    output reg signed   [Q_REG-1:0]     multiply_result_17  ,
    output reg signed   [Q_REG-1:0]     multiply_result_18  ,
    output reg signed   [Q_REG-1:0]     multiply_result_19  ,
    output reg signed   [Q_REG-1:0]     multiply_result_20  ,
    output reg signed   [Q_REG-1:0]     multiply_result_21  ,
    output reg signed   [Q_REG-1:0]     multiply_result_22  ,
    output reg signed   [Q_REG-1:0]     multiply_result_23  ,
    output reg signed   [Q_REG-1:0]     multiply_result_24  ,
    output reg signed   [Q_REG-1:0]     multiply_result_25  ,
    output reg signed   [Q_REG-1:0]     multiply_result_26  ,
    output reg signed   [Q_REG-1:0]     multiply_result_27  ,
    output reg signed   [Q_REG-1:0]     multiply_result_28  ,
    output reg signed   [Q_REG-1:0]     multiply_result_29  ,
    output reg signed   [Q_REG-1:0]     multiply_result_30  ,
    output reg signed   [Q_REG-1:0]     multiply_result_31  ,
    output reg signed   [Q_REG-1:0]     multiply_result_32  ,
    output reg signed   [Q_REG-1:0]     multiply_result_33  ,
    output reg signed   [Q_REG-1:0]     multiply_result_34  ,
    output reg signed   [Q_REG-1:0]     multiply_result_35  ,
    output reg signed   [Q_REG-1:0]     multiply_result_36  ,
    output reg signed   [Q_REG-1:0]     multiply_result_37  ,
    output reg signed   [Q_REG-1:0]     multiply_result_38  ,
    output reg signed   [Q_REG-1:0]     multiply_result_39  ,
    output reg signed   [Q_REG-1:0]     multiply_result_40  ,
    output reg signed   [Q_REG-1:0]     multiply_result_41  ,
    output reg signed   [Q_REG-1:0]     multiply_result_42  ,
    output reg signed   [Q_REG-1:0]     multiply_result_43  ,
    output reg signed   [Q_REG-1:0]     multiply_result_44  ,
    output reg signed   [Q_REG-1:0]     multiply_result_45  ,
    output reg signed   [Q_REG-1:0]     multiply_result_46  ,
    output reg signed   [Q_REG-1:0]     multiply_result_47  ,
    output reg signed   [Q_REG-1:0]     multiply_result_48  ,
    output reg signed   [Q_REG-1:0]     multiply_result_49  ,
    output reg signed   [Q_REG-1:0]     multiply_result_50  ,
    output reg signed   [Q_REG-1:0]     multiply_result_51  ,
    output reg signed   [Q_REG-1:0]     multiply_result_52  ,
    output reg signed   [Q_REG-1:0]     multiply_result_53  ,
    output reg signed   [Q_REG-1:0]     multiply_result_54  ,
    output reg signed   [Q_REG-1:0]     multiply_result_55  ,
    output reg signed   [Q_REG-1:0]     multiply_result_56  ,
    output reg signed   [Q_REG-1:0]     multiply_result_57  ,
    output reg signed   [Q_REG-1:0]     multiply_result_58  ,
    output reg signed   [Q_REG-1:0]     multiply_result_59  ,
    output reg signed   [Q_REG-1:0]     multiply_result_60  ,
    output reg signed   [Q_REG-1:0]     multiply_result_61  ,
    output reg signed   [Q_REG-1:0]     multiply_result_62  ,
    output reg signed   [Q_REG-1:0]     multiply_result_63  ,
    output reg signed   [Q_REG-1:0]     multiply_result_64  ,
    output reg signed   [Q_REG-1:0]     multiply_result_65  ,
    output reg signed   [Q_REG-1:0]     multiply_result_66  ,
    output reg signed   [Q_REG-1:0]     multiply_result_67  ,
    output reg signed   [Q_REG-1:0]     multiply_result_68  ,
    output reg signed   [Q_REG-1:0]     multiply_result_69  ,
    output reg signed   [Q_REG-1:0]     multiply_result_70  ,
    output reg signed   [Q_REG-1:0]     multiply_result_71  ,
    output reg signed   [Q_REG-1:0]     multiply_result_72  ,
    output reg signed   [Q_REG-1:0]     multiply_result_73  ,
    output reg signed   [Q_REG-1:0]     multiply_result_74  ,

    output reg signed   [Q_TOT-1:0]     bias_o
);

    localparam                          Q_TOT = Q_INT + Q_FRAC;
    localparam                          Q_REG = Q_TOT * 2 + 1;

    always @(posedge clk) begin
        if(!rst_n) begin
            multiply_result_0       <= 'b0;
            multiply_result_1       <= 'b0;
            multiply_result_2       <= 'b0;
            multiply_result_3       <= 'b0;
            multiply_result_4       <= 'b0;
            multiply_result_5       <= 'b0;
            multiply_result_6       <= 'b0;
            multiply_result_7       <= 'b0;
            multiply_result_8       <= 'b0;
            multiply_result_9       <= 'b0;
            multiply_result_10      <= 'b0;
            multiply_result_11      <= 'b0;
            multiply_result_12      <= 'b0;
            multiply_result_13      <= 'b0;
            multiply_result_14      <= 'b0;
            multiply_result_15      <= 'b0;
            multiply_result_16      <= 'b0;
            multiply_result_17      <= 'b0;
            multiply_result_18      <= 'b0;
            multiply_result_19      <= 'b0;
            multiply_result_20      <= 'b0;
            multiply_result_21      <= 'b0;
            multiply_result_22      <= 'b0;
            multiply_result_23      <= 'b0;
            multiply_result_24      <= 'b0;
            multiply_result_25      <= 'b0;
            multiply_result_26      <= 'b0;
            multiply_result_27      <= 'b0;
            multiply_result_28      <= 'b0;
            multiply_result_29      <= 'b0;
            multiply_result_30      <= 'b0;
            multiply_result_31      <= 'b0;
            multiply_result_32      <= 'b0;
            multiply_result_33      <= 'b0;
            multiply_result_34      <= 'b0;
            multiply_result_35      <= 'b0;
            multiply_result_36      <= 'b0;
            multiply_result_37      <= 'b0;
            multiply_result_38      <= 'b0;
            multiply_result_39      <= 'b0;
            multiply_result_40      <= 'b0;
            multiply_result_41      <= 'b0;
            multiply_result_42      <= 'b0;
            multiply_result_43      <= 'b0;
            multiply_result_44      <= 'b0;
            multiply_result_45      <= 'b0;
            multiply_result_46      <= 'b0;
            multiply_result_47      <= 'b0;
            multiply_result_48      <= 'b0;
            multiply_result_49      <= 'b0;
            multiply_result_50      <= 'b0;
            multiply_result_51      <= 'b0;
            multiply_result_52      <= 'b0;
            multiply_result_53      <= 'b0;
            multiply_result_54      <= 'b0;
            multiply_result_55      <= 'b0;
            multiply_result_56      <= 'b0;
            multiply_result_57      <= 'b0;
            multiply_result_58      <= 'b0;
            multiply_result_59      <= 'b0;
            multiply_result_60      <= 'b0;
            multiply_result_61      <= 'b0;
            multiply_result_62      <= 'b0;
            multiply_result_63      <= 'b0;
            multiply_result_64      <= 'b0;
            multiply_result_65      <= 'b0;
            multiply_result_66      <= 'b0;
            multiply_result_67      <= 'b0;
            multiply_result_68      <= 'b0;
            multiply_result_69      <= 'b0;
            multiply_result_70      <= 'b0;
            multiply_result_71      <= 'b0;
            multiply_result_72      <= 'b0;
            multiply_result_73      <= 'b0;
            multiply_result_74      <= 'b0;
        end
        else if(dot_product_enable) begin
            multiply_result_0       <= data_0 * weight_0;
            multiply_result_1       <= data_1 * weight_1;
            multiply_result_2       <= data_2 * weight_2;
            multiply_result_3       <= data_3 * weight_3;
            multiply_result_4       <= data_4 * weight_4;
            multiply_result_5       <= data_5 * weight_5;
            multiply_result_6       <= data_6 * weight_6;
            multiply_result_7       <= data_7 * weight_7;
            multiply_result_8       <= data_8 * weight_8;
            multiply_result_9       <= data_9 * weight_9;
            multiply_result_10      <= data_10 * weight_10;
            multiply_result_11      <= data_11 * weight_11;
            multiply_result_12      <= data_12 * weight_12;
            multiply_result_13      <= data_13 * weight_13;
            multiply_result_14      <= data_14 * weight_14;
            multiply_result_15      <= data_15 * weight_15;
            multiply_result_16      <= data_16 * weight_16;
            multiply_result_17      <= data_17 * weight_17;
            multiply_result_18      <= data_18 * weight_18;
            multiply_result_19      <= data_19 * weight_19;
            multiply_result_20      <= data_20 * weight_20;
            multiply_result_21      <= data_21 * weight_21;
            multiply_result_22      <= data_22 * weight_22;
            multiply_result_23      <= data_23 * weight_23;
            multiply_result_24      <= data_24 * weight_24;
            multiply_result_25      <= data_25 * weight_25;
            multiply_result_26      <= data_26 * weight_26;
            multiply_result_27      <= data_27 * weight_27;
            multiply_result_28      <= data_28 * weight_28;
            multiply_result_29      <= data_29 * weight_29;
            multiply_result_30      <= data_30 * weight_30;
            multiply_result_31      <= data_31 * weight_31;
            multiply_result_32      <= data_32 * weight_32;
            multiply_result_33      <= data_33 * weight_33;
            multiply_result_34      <= data_34 * weight_34;
            multiply_result_35      <= data_35 * weight_35;
            multiply_result_36      <= data_36 * weight_36;
            multiply_result_37      <= data_37 * weight_37;
            multiply_result_38      <= data_38 * weight_38;
            multiply_result_39      <= data_39 * weight_39;
            multiply_result_40      <= data_40 * weight_40;
            multiply_result_41      <= data_41 * weight_41;
            multiply_result_42      <= data_42 * weight_42;
            multiply_result_43      <= data_43 * weight_43;
            multiply_result_44      <= data_44 * weight_44;
            multiply_result_45      <= data_45 * weight_45;
            multiply_result_46      <= data_46 * weight_46;
            multiply_result_47      <= data_47 * weight_47;
            multiply_result_48      <= data_48 * weight_48;
            multiply_result_49      <= data_49 * weight_49;
            multiply_result_50      <= data_50 * weight_50;
            multiply_result_51      <= data_51 * weight_51;
            multiply_result_52      <= data_52 * weight_52;
            multiply_result_53      <= data_53 * weight_53;
            multiply_result_54      <= data_54 * weight_54;
            multiply_result_55      <= data_55 * weight_55;
            multiply_result_56      <= data_56 * weight_56;
            multiply_result_57      <= data_57 * weight_57;
            multiply_result_58      <= data_58 * weight_58;
            multiply_result_59      <= data_59 * weight_59;
            multiply_result_60      <= data_60 * weight_60;
            multiply_result_61      <= data_61 * weight_61;
            multiply_result_62      <= data_62 * weight_62;
            multiply_result_63      <= data_63 * weight_63;
            multiply_result_64      <= data_64 * weight_64;
            multiply_result_65      <= data_65 * weight_65;
            multiply_result_66      <= data_66 * weight_66;
            multiply_result_67      <= data_67 * weight_67;
            multiply_result_68      <= data_68 * weight_68;
            multiply_result_69      <= data_69 * weight_69;
            multiply_result_70      <= data_70 * weight_70;
            multiply_result_71      <= data_71 * weight_71;
            multiply_result_72      <= data_72 * weight_72;
            multiply_result_73      <= data_73 * weight_73;
            multiply_result_74      <= data_74 * weight_74;
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
