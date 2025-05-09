module BRAM_ACCESS_CONTROLLER
#(
    //parameter                                 AXI_DATA_WIDTH      = 64    ,
    //parameter                                 AXI_STRB_WIDTH      = 8     ,
    //parameter                                 AXI_ADDR_WIDTH      = 32    ,
    parameter                                   LMB_DATA_WIDTH      = 40    ,
    parameter                                   LMB_ADDR_WIDTH      = 32    ,
    parameter                                   LMB_WE_WIDTH        = 5     ,
    parameter                                   Q_INT_INPUT         = 2     ,
    parameter                                   Q_FRAC_INPUT        = 15
)
(
    input wire                                  clk         ,
    input wire                                  rst_n       ,

    input [3*(Q_INT_INPUT + Q_FRAC_INPUT)-1:0]  data_i      ,
    input                                       data_i_valid,
    input                                       first       ,
    input                                       last        ,
    input                                       lastline    ,

    // LMB Channel 1
    output reg                                  en_a_1      ,
    output reg                                  en_b_1      ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_1      ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_1      ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_1    ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_1    ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_1     ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_1     ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_1    ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_1    ,

    // LMB Channel 2
    output reg                                  en_a_2      ,
    output reg                                  en_b_2      ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_2      ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_2      ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_2    ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_2    ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_2     ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_2     ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_2    ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_2    ,

    // LMB Channel 3
    output reg                                  en_a_3      ,
    output reg                                  en_b_3      ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_3      ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_3      ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_3    ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_3    ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_3     ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_3     ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_3    ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_3    

    // No detail provided; Couldn't implement AXI interface
    // Real AXI interface might be moved to other module

    // Needed:
    // (1) Size of the image
    // (2) Size of the pixel
    // (3) Which channel to access to 'shared BRAM' ?
    // (4) Address range of 'shared BRAM'

    // AXI Write Address Channel
    //input  wire [AXI_ADDR_WIDTH-1:0]    awaddr_i    ,
    //input  wire [3:0]                   awlen_i     ,
    //input  wire [2:0]                   awsize_i    ,
    //input  wire [1:0]                   awburst_i   ,
    //input  wire                         awvalid_i   ,
    //output wire                         awready_o   ,

    // AXI Write Data Channel
    //input  wire [AXI_DATA_WIDTH-1:0]    wdata_i     ,
    //input  wire [AXI_STRB_WIDTH-1:0]    wstrb_i     ,
    //input  wire                         wlast_i     ,
    //input  wire                         wvalid_i    ,
    //output wire                         wready_o    ,

    // AXI Write Response Channel
    //output wire [1:0]                   bresp_o     ,
    //output wire                         bvalid_o    ,
    //input  wire                         bready_i    ,

    // AXI Read Address Channel
    //input  wire                         arready_i   ,
    //output wire [AXI_ADDR_WIDTH-1:0]    araddr_o    ,
    //output wire [3:0]                   arlen_o     ,
    //output wire [2:0]                   arsize_o    ,
    //output wire [1:0]                   arburst_o   ,
    //output wire                         arvalid_o   ,

    // AXI Read Data Channel
    //input  wire [AXI_DATA_WIDTH-1:0]    rdata_i     ,
    //input  wire                         rvalid_i    ,
    //input  wire                         rlast_i     ,
    //input  wire [AXI_STRB_WIDTH-1:0]    rresp_i     ,
    //output wire                         rready_o    ,
);

    // -----------------------------------------------------------------------------
    localparam                      IDLE                = 4'd0;
    localparam                      INIT                = 4'd1;
    localparam                      SETUP_CONV_FIRST    = 4'd2;
    localparam                      CONV_FIRST          = 4'd3;
    reg [3:0]                       state_n;
    reg [3:0]                       state;
    reg                             lastline_buf;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= state_n;
        end
    end
    
    always @(posedge clk) begin
        if(!rst_n) begin
            lastline_buf            <= 'b0;
        end
        else if (lastline) begin
            lastline_buf            <= 'b1;
        end 
        else if (last) begin
            lastline_buf            <= 'b0;
        end
    end
    always @(*) begin
        state_n                     = state;
        case (state)
            IDLE : begin
                state_n             = INIT;
            end
            INIT : begin
                if (lastline_buf & last) begin
                    state_n         = SETUP_CONV_FIRST;
                end
            end
            
        endcase
    end
    
    // -----------------------------------------------------------------------------
    //wire                                shift_enable;
    //reg [AXI_DATA_WIDTH-1:0]            buffer;
//
    //reg [AXI_ADDR_WIDTH-1:0]            araddr;
    //reg [3:0]                           arlen;
    //reg [2:0]                           arsize;
    //reg [1:0]                           arburst;
    //reg                                 arvalid;
//
    //always @(posedge clk) begin
        //if (state == INIT) begin
            //arvalid     <= 1'b1;
            //araddr      <=
        //end
    //end
//
    //assign araddr_o     = araddr;
    //assign arlen_o      = arlen;
    //assign arsize_o     = arsize;
    //assign arburst_o    = arburst;
    //assign arvalid_o    = arvalid;
//
    //// -----------------------------------------------------------------------------
    //localparam                          shift_register_size     = 4;
//
    //reg [AXI_DATA_WIDTH-1:0]            shift_register [0:shift_register_size-1];
//
    //always @(posedge clk) begin
        //if (!rst_n) begin
            //shift_register <= 'b0;
        //end
        //else if (shift_enable) begin
            //shift_register[0] <= buffer;
            //for (i = 0; i < shift_register_size - 1; i = i + 1) begin
                //shift_register[i + 1] <= shift_register[i];
            //end
        //end
    //end

    // -----------------------------------------------------------------------------
    localparam                      input_width = Q_INT_INPUT + Q_FRAC_INPUT;
    reg                             bram_transfer_enable;
    reg                             first_buf;
    reg [1:0]                       data_i_cnt;
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            data_i_cnt              <= 2'b00;
        end
        else if (state == INIT) begin
            if(data_i_valid) begin
                data_i_cnt          <= data_i_cnt + 2'b01;
            end
        end
        
    end
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            bram_transfer_enable    <= 1'b0;
        end
        else if (data_i_cnt == 2'b01) begin
            bram_transfer_enable    <= 1'b1;
        end 
        else if (data_i_cnt == 2'b11) begin
            bram_transfer_enable    <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            first_buf               <= 1'b0;
        end
        else if (first) begin
            first_buf               <= 1'b1;
        end
        else if (bram_transfer_enable) begin
            first_buf               <= 1'b0;
        end
    end
    
    
    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_1                  <= 'b0;
            en_b_1                  <= 'b0;
            we_a_1                  <= 'b0;
            we_b_1                  <= 'b0;
            addr_a_1                <= 'h0;
            addr_b_1                <= 'h0;
            din_a_1                 <= 'b0;
            din_b_1                 <= 'b0;
        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                if(first_buf) begin
                    addr_a_1        <= 'h0;
                    addr_b_1        <= 'h5;
                end
                else begin
                    addr_a_1        <= addr_a_1 + (LMB_DATA_WIDTH / 8);
                    addr_b_1        <= addr_b_1 + (LMB_DATA_WIDTH / 8);
                end
                en_a_1              <= 1'b1;
                en_b_1              <= 1'b1;
                we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                we_b_1              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin
                en_a_1              <= 'b0;
                en_b_1              <= 'b0;
            end
            
            if(data_i_cnt == 2'b00) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 0  -: input_width];    
            end
            else if (data_i_cnt == 2'b01) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 0  -: input_width]; 
            end
            
            if(data_i_cnt == 2'b10) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 0  -: input_width];    
            end
            else if (data_i_cnt == 2'b11) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 0  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_1                  <= 'b0;
            en_b_1                  <= 'b0;
            we_a_1                  <= 'b0;
            we_b_1                  <= 'b0;
            addr_a_1                <= 'h0;
            addr_b_1                <= 'h0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_2                  <= 'b0;
            en_b_2                  <= 'b0;
            we_a_2                  <= 'b0;
            we_b_2                  <= 'b0;
            addr_a_2                <= 'h0;
            addr_b_2                <= 'h0;
            din_a_2                 <= 'b0;
            din_b_2                 <= 'b0;
        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                if(first_buf) begin
                    addr_a_2        <= 'h0;
                    addr_b_2        <= 'h5;
                end
                else begin
                    addr_a_2        <= addr_a_2 + (LMB_DATA_WIDTH / 8);
                    addr_b_2        <= addr_b_2 + (LMB_DATA_WIDTH / 8);
                end
                en_a_2              <= 1'b1;
                en_b_2              <= 1'b1;
                we_a_2              <= {LMB_WE_WIDTH{1'b1}};
                we_b_2              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin     
                en_a_2              <= 'b0;
                en_b_2              <= 'b0;
            end
            
            if(data_i_cnt == 2'b00) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 1  -: input_width];    
            end
            else if (data_i_cnt == 2'b01) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 1  -: input_width]; 
            end
            
            if(data_i_cnt == 2'b10) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 1  -: input_width];    
            end
            else if (data_i_cnt == 2'b11) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 1  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_2                  <= 'b0;
            en_b_2                  <= 'b0;
            we_a_2                  <= 'b0;
            we_b_2                  <= 'b0;
            addr_a_2                <= 'h0;
            addr_b_2                <= 'h0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_3                  <= 'b0;
            en_b_3                  <= 'b0;
            we_a_3                  <= 'b0;
            we_b_3                  <= 'b0;
            addr_a_3                <= 'h0;
            addr_b_3                <= 'h0;
            din_a_3                 <= 'b0;
            din_b_3                 <= 'b0;
        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                if(first_buf) begin
                    addr_a_3        <= 'h0;
                    addr_b_3        <= 'h5;
                end
                else begin
                    addr_a_3        <= addr_a_3 + (LMB_DATA_WIDTH / 8);
                    addr_b_3        <= addr_b_3 + (LMB_DATA_WIDTH / 8);
                end
                en_a_3              <= 1'b1;
                en_b_3              <= 1'b1;
                we_a_3              <= {LMB_WE_WIDTH{1'b1}};
                we_b_3              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin     
                en_a_3              <= 'b0;
                en_b_3              <= 'b0;
            end
            
            if(data_i_cnt == 2'b00) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 2  -: input_width];    
            end
            else if (data_i_cnt == 2'b01) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 2  -: input_width]; 
            end
            
            if(data_i_cnt == 2'b10) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= data_i[3*input_width-1 - input_width * 2  -: input_width];    
            end
            else if (data_i_cnt == 2'b11) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= data_i[3*input_width-1 - input_width * 2  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_3                  <= 'b0;
            en_b_3                  <= 'b0;
            we_a_3                  <= 'b0;
            we_b_3                  <= 'b0;
            addr_a_3                <= 'h0;
            addr_b_3                <= 'h0;
        end
    end

    // -----------------------------------------------------------------------------

endmodule