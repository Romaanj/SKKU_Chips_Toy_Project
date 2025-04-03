module UART_TESTER
(
    input   wire                m_axi_aclk,
    input   wire                m_axi_aresetn,

    input   wire                interrupt,

    output  reg     [3:0]       m_axi_awaddr,
    output  reg                 m_axi_awvalid,
    input   wire                m_axi_awready,

    output  reg     [31:0]      m_axi_wdata,
    output  reg     [3:0]       m_axi_wstrb,
    output  reg                 m_axi_wvalid,
    input   wire                m_axi_wready,

    input   wire    [1:0]       m_axi_bresp,
    input   wire                m_axi_bvalid,
    output  reg                 m_axi_bready,

    output  reg     [3:0]       m_axi_araddr,
    output  reg                 m_axi_arvalid,
    input   wire                m_axi_arready,

    input   wire    [31:0]      m_axi_rdata,
    input   wire    [1:0]       m_axi_rresp,
    input   wire                m_axi_rvalid,
    output  reg                 m_axi_rready,

    //input   wire                loopback_en,
    input   wire    [31:0]      data_to_pc,
    input   wire                data_to_pc_en
    //output  wire    [31:0]      data_to_fpga,
    //output  wire                data_to_fpga_en
);

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_awvalid   <= 1'b0;
        end
        else if (data_to_pc_en) begin
            m_axi_awvalid   <= 1'b1;
        end
        else if (m_axi_awready) begin
            m_axi_awvalid   <= 1'b0;
        end
    end

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_awaddr <= 'b0;
        end
        else if (data_to_pc_en) begin
            m_axi_awaddr <= 'h4;
        end
    end

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_wvalid    <= 1'b0;
        end
        else if (data_to_pc_en) begin
            m_axi_wvalid    <= 1'b1;
        end
        else if (m_axi_wready) begin
            m_axi_wvalid    <= 1'b0;
        end
    end

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_wdata <= 'b0;
        end
        else if (data_to_pc_en) begin
            m_axi_wdata <= data_to_pc;
        end
    end

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_wstrb <= 4'b0000;
        end
        else if (data_to_pc_en) begin
            m_axi_wstrb <= 4'b1111;
        end
    end

    always @(posedge m_axi_aclk) begin
        if (!m_axi_aresetn) begin
            m_axi_bready <= 1'b0;
        end
        else if (m_axi_bvalid) begin
            m_axi_bready <= 1'b1;
        end
        else if (m_axi_bready) begin
            m_axi_bready <= 1'b0;
        end
    end

    //always @(posedge m_axi_aclk) begin
        //if (!m_axi_aresetn) begin
            //m_axi_araddr <= 'b0;
        //end
        //else if (loopback_en) begin
            //m_axi_araddr <= 'h0;
        //end
    //end
//
    //always @(posedge m_axi_aclk) begin
        //if (!m_axi_aresetn) begin
            //m_axi_rready <= 1'b0;
        //end
        //else if (m_axi_rvalid) begin
            //m_axi_rready <= 1'b1;
        //end
        //else if (m_axi_rready) begin
            //m_axi_rready <= 1'b0;
        //end
    //end

endmodule