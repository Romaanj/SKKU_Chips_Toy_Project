module CONV_FIRST
#(
    // Default fixed point format = signed Q1.15
    parameter                               Q_INT           = 1                         ,
    parameter                               Q_FRAC          = 15                        ,
)
(
    input                                   clk                                         ,
    input                                   rst_n                                       ,

    input signed    [width_data-1:0]        data_in                                     ,
    input                                   data_in_enable                              ,

    input signed    [width_weight-1:0]      weight_in                                   ,
    input                                   weight_in_enable                            ,

    input signed    [width_weight-1:0]      bias_in                                     ,
    input                                   bias_in_enable                              ,

    output signed   [width_data-1:0]        data_out                                    ,
    output                                  data_out_enable
);

    localparam                              width_data      = Q_INT + Q_FRAC            ;
    localparam                              width_weight    = Q_INT + Q_FRAC            ;
    localparam                              width_bias      = Q_INT + Q_FRAC            ;

    reg signed      [width_data-1:0]        internal_data   [0:74]  ;
    reg signed      [width_weight-1:0]      internal_weight [0:74]  ;
    reg signed      [width_bias-1:0]        internal_bias           ;

    // -------------------------------------------------------------------------------
    // count how many data(+weight+bias) has come
    // maximum is 74 or 75
    // -------------------------------------------------------------------------------

    reg             [6:0]                   count_data              ;
    reg             [6:0]                   count_weight            ;

    always @(posedge clk) begin
        if (!rst_n) begin
            count_data                  <= 7'd0;
        end
        /* TODO */
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            count_weight                <= 7'd0;
        end
        /* TODO */
    end

    // -------------------------------------------------------------------------------
    // count finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // store input start
    // -------------------------------------------------------------------------------

    always @(posedge clk) begin
        if (!rst_n) begin
            internal_data                   <= 'd0;
            internal_weight                 <= 'd0;
            internal_bias                   <= 'd0;
        end
        else if (data_in_enable) begin
            internal_data[count_data]       <= data_in;
        end
        else if (weight_in_enable) begin
            internal_weight[count_weight]   <= weight_in;
        end
        else if (bias_in_enable) begin
            internal_bias                   <= bias_in;
        end
    end

    // -------------------------------------------------------------------------------
    // store input finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // enable control start
    // -------------------------------------------------------------------------------

    /* TODO */

    // -------------------------------------------------------------------------------
    // enable control finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    CONV_FIRST_ADDER_TREE
    #(
        .Q_INT                          (Q_INT),
        .Q_FRAC                         (Q_FRAC),
    )
    conv_first_adder_tree_inst
    (
        .clk                            (clk),
        .rst_n                          (rst_n),

        .adder_tree_middle_stage_enable (),

        .addend_0                       (_0),
        .addend_1                       (_1),
        .addend_2                       (_2),
        .addend_3                       (_3),
        .addend_4                       (_4),
        .addend_5                       (_5),
        .addend_6                       (_6),
        .addend_7                       (_7),
        .addend_8                       (_8),
        .addend_9                       (_9),
        .addend_10                      (_10),
        .addend_11                      (_11),
        .addend_12                      (_12),
        .addend_13                      (_13),
        .addend_14                      (_14),
        .addend_15                      (_15),
        .addend_16                      (_16),
        .addend_17                      (_17),
        .addend_18                      (_18),
        .addend_19                      (_19),
        .addend_20                      (_20),
        .addend_21                      (_21),
        .addend_22                      (_22),
        .addend_23                      (_23),
        .addend_24                      (_24),
        .addend_25                      (_25),
        .addend_26                      (_26),
        .addend_27                      (_27),
        .addend_28                      (_28),
        .addend_29                      (_29),
        .addend_30                      (_30),
        .addend_31                      (_31),
        .addend_32                      (_32),
        .addend_33                      (_33),
        .addend_34                      (_34),
        .addend_35                      (_35),
        .addend_36                      (_36),
        .addend_37                      (_37),
        .addend_38                      (_38),
        .addend_39                      (_39),
        .addend_40                      (_40),
        .addend_41                      (_41),
        .addend_42                      (_42),
        .addend_43                      (_43),
        .addend_44                      (_44),
        .addend_45                      (_45),
        .addend_46                      (_46),
        .addend_47                      (_47),
        .addend_48                      (_48),
        .addend_49                      (_49),
        .addend_50                      (_50),
        .addend_51                      (_51),
        .addend_52                      (_52),
        .addend_53                      (_53),
        .addend_54                      (_54),
        .addend_55                      (_55),
        .addend_56                      (_56),
        .addend_57                      (_57),
        .addend_58                      (_58),
        .addend_59                      (_59),
        .addend_60                      (_60),
        .addend_61                      (_61),
        .addend_62                      (_62),
        .addend_63                      (_63),
        .addend_64                      (_64),
        .addend_65                      (_65),
        .addend_66                      (_66),
        .addend_67                      (_67),
        .addend_68                      (_68),
        .addend_69                      (_69),
        .addend_70                      (_70),
        .addend_71                      (_71),
        .addend_72                      (_72),
        .addend_73                      (_73),
        .addend_74                      (_74),

        .bias                           (),

        .adder_tree_result              (),
        .adder_tree_result_enable       ()
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule
