module BRAM_TOP
#(
    parameter                                   LMB_DATA_WIDTH      = 40    ,
    parameter                                   LMB_ADDR_WIDTH      = 12    ,
    parameter                                   LMB_WE_WIDTH        = 5     ,
    parameter                                   Q_INT_INPUT         = 2     ,
    parameter                                   Q_FRAC_INPUT        = 15
)
(
    input                                       clk                 ,
    input                                       rst_n               ,

    input                                       PIXEL_START         ,
    input                                       PIXEL_valid         ,
    input                                       PIXEL_first         ,
    input                                       PIXEL_last          ,
    input                                       PIXEL_lastline      ,
    input [39:0]                                PIXEL_R             ,
    input [39:0]                                PIXEL_G             ,
    input [39:0]                                PIXEL_B
);

    wire [LMB_WE_WIDTH-1:0]                     we_a_1              ;
    wire [LMB_WE_WIDTH-1:0]                     we_b_1              ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_a_1            ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_b_1            ;
    wire [LMB_DATA_WIDTH-1:0]                   din_a_1             ;
    wire [LMB_DATA_WIDTH-1:0]                   din_b_1             ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_a_1            ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_b_1            ;

    wire [LMB_WE_WIDTH-1:0]                     we_a_2              ;
    wire [LMB_WE_WIDTH-1:0]                     we_b_2              ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_a_2            ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_b_2            ;
    wire [LMB_DATA_WIDTH-1:0]                   din_a_2             ;
    wire [LMB_DATA_WIDTH-1:0]                   din_b_2             ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_a_2            ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_b_2            ;

    wire [LMB_WE_WIDTH-1:0]                     we_a_3              ;
    wire [LMB_WE_WIDTH-1:0]                     we_b_3              ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_a_3            ;
    wire [LMB_ADDR_WIDTH-1:0]                   addr_b_3            ;
    wire [LMB_DATA_WIDTH-1:0]                   din_a_3             ;
    wire [LMB_DATA_WIDTH-1:0]                   din_b_3             ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_a_3            ;
    wire [LMB_DATA_WIDTH-1:0]                   dout_b_3            ;

    BRAM_ACCESS_CONTROLLER
    #(
        .LMB_DATA_WIDTH                         (LMB_DATA_WIDTH )   ,
        .LMB_ADDR_WIDTH                         (LMB_ADDR_WIDTH )   ,
        .LMB_WE_WIDTH                           (LMB_WE_WIDTH   )   ,
        .Q_INT_INPUT                            (Q_INT_INPUT    )   ,
        .Q_FRAC_INPUT                           (Q_FRAC_INPUT   )
    )
    bram_access_controller_inst
    (
        .clk                                    (clk            )   ,
        .rst_n                                  (rst_n          )   ,

        .PIXEL_START                            (PIXEL_START    )   ,
        .PIXEL_valid                            (PIXEL_valid    )   ,
        .PIXEL_first                            (PIXEL_first    )   ,
        .PIXEL_last                             (PIXEL_last     )   ,
        .PIXEL_lastline                         (PIXEL_lastline )   ,

        .PIXEL_R                                (PIXEL_R        )   ,
        .PIXEL_G                                (PIXEL_G        )   ,
        .PIXEL_B                                (PIXEL_B        )   ,

        .we_a_1                                 (we_a_1         )   ,
        .we_b_1                                 (we_b_1         )   ,
        .addr_a_1                               (addr_a_1       )   ,
        .addr_b_1                               (addr_b_1       )   ,
        .din_a_1                                (din_a_1        )   ,
        .din_b_1                                (din_b_1        )   ,
        .dout_a_1                               (dout_a_1       )   ,
        .dout_b_1                               (dout_b_1       )

        //.we_a_2                                 (we_a_2         )   ,
        //.we_b_2                                 (we_b_2         )   ,
        //.addr_a_2                               (addr_a_2       )   ,
        //.addr_b_2                               (addr_b_2       )   ,
        //.din_a_2                                (din_a_2        )   ,
        //.din_b_2                                (din_b_2        )   ,
        //.dout_a_2                               (dout_a_2       )   ,
        //.dout_b_2                               (dout_b_2       )   ,
//
        //.we_a_3                                 (we_a_3         )   ,
        //.we_b_3                                 (we_b_3         )   ,
        //.addr_a_3                               (addr_a_3       )   ,
        //.addr_b_3                               (addr_b_3       )   ,
        //.din_a_3                                (din_a_3        )   ,
        //.din_b_3                                (din_b_3        )   ,
        //.dout_a_3                               (dout_a_3       )   ,
        //.dout_b_3                               (dout_b_3       )
    );

    BRAM_40x3528_TDP_RF
    u_bram_1
    (
        // Port A
        .clka                                   (clk            )   ,
        .wea                                    (we_a_1         )   ,
        .addra                                  (addr_a_1       )   ,
        .dina                                   (din_a_1        )   ,
        .douta                                  (dout_a_1       )   ,
        // Port B
        .clkb                                   (clk            )   ,
        .web                                    (we_b_1         )   ,
        .addrb                                  (addr_b_1       )   ,
        .dinb                                   (din_b_1        )   ,
        .doutb                                  (dout_b_1       )
    );
//
    //BRAM_40x3528_TDP_RF
    //u_bram_2
    //(
        //// Port A
        //.clka                                   (clk            )   ,
        //.ena                                    (en_a_2         )   ,
        //.wea                                    (we_a_2         )   ,
        //.addra                                  (addr_a_2       )   ,
        //.dina                                   (din_a_2        )   ,
        //.douta                                  (dout_a_2       )   ,
        //// Port B
        //.clkb                                   (clk            )   ,
        //.enb                                    (en_b_2         )   ,
        //.web                                    (we_b_2         )   ,
        //.addrb                                  (addr_b_2       )   ,
        //.dinb                                   (din_b_2        )   ,
        //.doutb                                  (dout_b_2       )
    //);
//
    //BRAM_40x3528_TDP_RF
    //u_bram_3
    //(
        //// Port A
        //.clka                                   (clk            )   ,
        //.ena                                    (en_a_3         )   ,
        //.wea                                    (we_a_3         )   ,
        //.addra                                  (addr_a_3       )   ,
        //.dina                                   (din_a_3        )   ,
        //.douta                                  (dout_a_3       )   ,
        //// Port B
        //.clkb                                   (clk            )   ,
        //.enb                                    (en_b_3         )   ,
        //.web                                    (we_b_3         )   ,
        //.addrb                                  (addr_b_3       )   ,
        //.dinb                                   (din_b_3        )   ,
        //.doutb                                  (dout_b_3       )
    //);

endmodule