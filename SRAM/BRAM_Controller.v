`timescale 1ns / 1ps
// BRAM testbench by HS
module BRAM_CONTROLLER #(
parameter AXI_DATA_WIDTH       = 64,
parameter AXI_ADDR_WIDTH       = 32,
parameter LMB_DATA_WIDTH       = 40,
parameter LMB_ADDR_WIDTH       = 32,
parameter LMB_WE_WIDTH         = 5,
parameter Q_INT_INPUT          = 2,
parameter Q_FRAC_INPUT         = 15
)
(

    input wire clk,
    input wire rst_n,

    input  wire [AXI_ADDR_WIDTH-1:0]awaddr_i,
    input  wire [3:0]               awlen_i,
    input  wire [2:0]               awsize_i,
    input  wire [1:0]               awburst_i,
    input  wire                     awvalid_i,
    output wire                     awready_o,

 // AXI Write Data Channel
    input  wire [AXI_DATA_WIDTH-1:0]wdata_i,
    input  wire [3:0]               wstrb_i,
    input  wire                     wlast_i,
    input  wire                     wvalid_i,
    output wire                     wready_o,

    // AXI Write Response Channel
    output wire [1:0]               bresp_o,
    output wire                     bvalid_o,
    input  wire                     bready_i,

    output reg                      en_a_1,
    output reg                      en_b_1,
    output reg [LMB_WE_WIDTH-1:0]   we_a_1,
    output reg [LMB_WE_WIDTH-1:0]   we_b_1,
    output reg [LMB_ADDR_WIDTH-1:0] addr_a_1,
    output reg [LMB_ADDR_WIDTH-1:0] addr_b_1,
    output reg [LMB_DATA_WIDTH-1:0] din_a_1,
    output reg [LMB_DATA_WIDTH-1:0] din_b_1,
    input wire [LMB_DATA_WIDTH-1:0] dout_a_1,
    input wire [LMB_DATA_WIDTH-1:0] dout_b_1,

    output reg                      en_a_2,
    output reg                      en_b_2,
    output reg [LMB_WE_WIDTH-1:0]   we_a_2,
    output reg [LMB_WE_WIDTH-1:0]   we_b_2,
    output reg [LMB_ADDR_WIDTH-1:0] addr_a_2,
    output reg [LMB_ADDR_WIDTH-1:0] addr_b_2,
    output reg [LMB_DATA_WIDTH-1:0] din_a_2,
    output reg [LMB_DATA_WIDTH-1:0] din_b_2,
    input wire [LMB_DATA_WIDTH-1:0] dout_a_2,
    input wire [LMB_DATA_WIDTH-1:0] dout_b_2,
    
    output reg                      en_a_3,
    output reg                      en_b_3,
    output reg [LMB_WE_WIDTH-1:0]   we_a_3,
    output reg [LMB_WE_WIDTH-1:0]   we_b_3,
    output reg [LMB_ADDR_WIDTH-1:0] addr_a_3,
    output reg [LMB_ADDR_WIDTH-1:0] addr_b_3,
    output reg [LMB_DATA_WIDTH-1:0] din_a_3,
    output reg [LMB_DATA_WIDTH-1:0] din_b_3,
    input wire [LMB_DATA_WIDTH-1:0] dout_a_3,
    input wire [LMB_DATA_WIDTH-1:0] dout_b_3    
);
    localparam                      IDLE = 3'b000;
    localparam                      INIT = 3'b001;
    localparam                      input_width = Q_INT_INPUT + Q_FRAC_INPUT;

    reg [2:0]                       state_n;
    reg [2:0]                       state;

    always @ (posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= state_n;
        end
    end

    always @ (*) begin
        state_n =                   state;
        case (state)
            IDLE : begin
                state_n = INIT;
            end
        endcase
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_1                  <= 'b0;
            we_a_1                  <= 'b0;
            addr_a_1                <= 'b0;
            din_a_1                 <= 'b0;
        end
        else if (state == INIT) begin
            en_a_1                  <= 1'b1;
            we_a_1                  <= {LMB_WE_WIDTH{1'b1}};
            addr_a_1                <= addr_a_1 + (LMB_DATA_WIDTH / 8);
            din_a_1                 <= temp[63 - input_width * 0 -: input_width];
        end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_2                  <= 'b0;
            we_a_2                  <= 'b0;
            addr_a_2                <= 'b0;
            din_a_2                 <= 'b0;
        end
        else if (state == INIT) begin
            en_a_2                  <= 1'b1;
            we_a_2                  <= {LMB_WE_WIDTH{1'b1}};
            addr_a_2                <= addr_a_2 + (LMB_DATA_WIDTH / 8);
            din_a_2                 <= temp[63 - input_width * 1 -: input_width];
        end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_3                  <= 'b0;
            we_a_3                  <= 'b0;
            addr_a_3                <= 'b0;
            din_a_3                 <= 'b0;
        end
        else if (state == INIT) begin
            en_a_3                  <= 1'b1;
            we_a_3                  <= {LMB_WE_WIDTH{1'b1}};
            addr_a_3                <= addr_a_3 + (LMB_DATA_WIDTH / 8);
            din_a_3                 <= temp[63 - input_width * 2 -: input_width];
        end
    end

endmodule
