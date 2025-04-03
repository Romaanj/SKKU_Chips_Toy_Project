module UART_TOP
(
    input   clk,
    input   rst,

    input	RX,
    output  TX
);

    wire            axi_aclk;
    wire            axi_aresetn;
    wire    [3:0]   axi_awaddr;
    wire    [31:0]  axi_wdata;
    wire    [3:0]   axi_wstrb;
    wire    [1:0]   axi_bresp;
    wire    [3:0]   axi_araddr;
    wire    [31:0]  axi_rdata;
    wire    [1:0]   axi_rresp;
    wire    [31:0]  data_to_pc;

    axi_uartlite_0 DUT
    (
        .s_axi_aclk         (axi_aclk           ),
        .s_axi_aresetn      (axi_aresetn        ),
        .interrupt          (interrupt          ),
        .s_axi_awaddr       (axi_awaddr         ),
        .s_axi_awvalid      (axi_awvalid        ),
        .s_axi_awready      (axi_awready        ),
        .s_axi_wdata        (axi_wdata          ),
        .s_axi_wstrb        (axi_wstrb          ),
        .s_axi_wvalid       (axi_wvalid         ),
        .s_axi_wready       (axi_wready         ),
        .s_axi_bresp        (axi_bresp          ),
        .s_axi_bvalid       (axi_bvalid         ),
        .s_axi_bready       (axi_bready         ),
        .s_axi_araddr       (axi_araddr         ),
        .s_axi_arvalid      (axi_arvalid        ),
        .s_axi_arready      (axi_arready        ),
        .s_axi_rdata        (axi_rdata          ),
        .s_axi_rresp        (axi_rresp          ),
        .s_axi_rvalid       (axi_rvalid         ),
        .s_axi_rready       (axi_rready         ),
        .rx                 (RX                 ),
        .tx                 (TX                 )
    );

    UART_TESTER UART_TESTER_INST
    (
        .m_axi_aclk         (axi_aclk           ),
        .m_axi_aresetn      (axi_aresetn        ),
        .interrupt          (interrupt          ),
        .m_axi_awaddr       (axi_awaddr         ),
        .m_axi_awvalid      (axi_awvalid        ),
        .m_axi_awready      (axi_awready        ),
        .m_axi_wdata        (axi_wdata          ),
        .m_axi_wstrb        (axi_wstrb          ),
        .m_axi_wvalid       (axi_wvalid         ),
        .m_axi_wready       (axi_wready         ),
        .m_axi_bresp        (axi_bresp          ),
        .m_axi_bvalid       (axi_bvalid         ),
        .m_axi_bready       (axi_bready         ),
        .m_axi_araddr       (axi_araddr         ),
        .m_axi_arvalid      (axi_arvalid        ),
        .m_axi_arready      (axi_arready        ),
        .m_axi_rdata        (axi_rdata          ),
        .m_axi_rresp        (axi_rresp          ),
        .m_axi_rvalid       (axi_rvalid         ),
        .m_axi_rready       (axi_rready         ),

        //.loopback_en        (loopback_en        ),
        .data_to_pc         (data_to_pc         ),
        .data_to_pc_en      (data_to_pc_en      )
        //.data_to_fpga       (data_to_fpga       ),
        //.data_to_fpga_en    (data_to_fpga_en    )
    );

    assign  axi_aclk        = clk;
    assign  axi_aresetn     = rst;
    //assign  loopback_en     = 1'b1;
    assign  data_to_pc      = {{24{1'b0}}, 8'b0100_0001};
    assign  data_to_pc_en   = 1'b1;

endmodule