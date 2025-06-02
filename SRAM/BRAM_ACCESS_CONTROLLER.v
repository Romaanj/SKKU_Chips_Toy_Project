module BRAM_ACCESS_CONTROLLER
#(
    //parameter                                 AXI_DATA_WIDTH      = 64    ,
    //parameter                                 AXI_STRB_WIDTH      = 8     ,
    //parameter                                 AXI_ADDR_WIDTH      = 32    ,
    parameter                                   LMB_DATA_WIDTH      = 40    ,
    parameter                                   LMB_ADDR_WIDTH      = 12    ,
    parameter                                   LMB_WE_WIDTH        = 5     ,
    parameter                                   Q_INT_INPUT         = 1     ,
    parameter                                   Q_FRAC_INPUT        = 7
)
(
    input wire                                  clk         ,
    input wire                                  rst_n       ,

    input [79:0]                                CORE_data_i,
    input                                       CORE_data_i_valid,
    input                                       CORE_first,
    input                                       CORE_last,
    input                                       CORE_lastline,
    output reg [39:0]                           data_to_core_a_n,
    reg [39:0]                           data_to_core_a,
    reg [39:0]                           data_to_core_b,
    output reg [39:0]                           data_to_core_b_n,
    output reg [39:0]                           CORE_data_o0,
    output reg [39:0]                           CORE_data_o1,
    output reg [39:0]                           CORE_data_o2,
    output reg [39:0]                           CORE_data_o3,
    output reg [39:0]                           CORE_data_o4,
    output reg [39:0]                           CORE_data_o5,
    output reg [39:0]                           CORE_data_o6,
    output reg [39:0]                           CORE_data_o7,
    output reg [39:0]                           CORE_data_o8,
    output reg [39:0]                           CORE_data_o9,
    output reg [39:0]                           CORE_data_o10,
    output reg [39:0]                           CORE_data_o11,
    output reg [39:0]                           CORE_data_o12,
    output reg [39:0]                           CORE_data_o13,
    output reg [39:0]                           CORE_data_o14,
    output reg [39:0]                           CORE_data_o15,
    output reg [39:0]                           CORE_data_o16,
    output reg [39:0]                           CORE_data_o17,
    output reg [39:0]                           CORE_data_o18,
    output reg [39:0]                           CORE_data_o19,
    output reg [39:0]                           CORE_data_o20,
    output reg [39:0]                           CORE_data_o21,
    output reg [39:0]                           CORE_data_o22,
    output reg [39:0]                           CORE_data_o23,
    output reg [39:0]                           CORE_data_o24,
    output reg [39:0]                           CORE_data_o25,
    output reg                                  core_data_valid,
    
    
    input [31:0]                                AXI_data_i,
    input                                       AXI_data_i_valid,
    input                                       AXI_first,
    input                                       AXI_last,
    input                                       AXI_lastline,
    
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
    localparam                      SETUP_CONV_SHRINK   = 4'd4;
    
    reg [3:0]                       state_n;
    reg [3:0]                       state;
    reg                             AXI_lastline_buf;
    reg [31:0]                      AXI_data_i_buf;
    reg [1:0]                       line_buffer;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            line_buffer <= 0;
        end
        else if(AXI_last) begin
            line_buffer <= line_buffer + 'b01;
        end
    end
    
    always @(posedge clk) begin
        if (!rst_n) begin
            AXI_data_i_buf <= 0;
        end
        else begin
            AXI_data_i_buf <= AXI_data_i;
        end
    end
    
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
            AXI_lastline_buf            <= 'b0;
        end
        else if (AXI_lastline) begin
            AXI_lastline_buf            <= 'b1;
        end 
        else if (AXI_last) begin
            AXI_lastline_buf            <= 'b0;
        end
    end
    always @(*) begin
        state_n                     = state;
        case (state)
            IDLE : begin
                state_n             = INIT;
            end
            INIT : begin
                if (AXI_last) begin // 임시로 해놓음
                    state_n         = SETUP_CONV_FIRST;
                end
            end
            SETUP_CONV_FIRST : begin
                state_n             = CONV_FIRST;
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
    reg                             AXI_first_buf;
    reg [3:0]                       data_i_cnt;
    reg [3:0]                       cnt;
    reg [39:0]                  core_data_temp_0;
    reg [39:0]                  core_data_temp_1;
    always @ (posedge clk) begin
    
        if (!rst_n) begin
            data_i_cnt              <= 4'b0000;
        end
        else if (state == INIT) begin
            if(AXI_data_i_valid) begin
                if(data_i_cnt >= 9) begin
                    data_i_cnt      <= 4'b0000;
                end
                else begin
                    data_i_cnt      <= data_i_cnt + 4'b0001;
                end
            end
        end
        
    end
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            cnt          <= 4'b0000;
        end
        else if (state == CONV_FIRST) begin
            if(cnt >= 9) begin
                cnt      <= 4'b0000;
            end
            else begin
                cnt      <= cnt + 4'b0001;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            bram_transfer_enable    <= 1'b0;
        end
        else if (data_i_cnt == 4'b1000) begin
            bram_transfer_enable    <= 1'b1;
        end 
        else if (data_i_cnt == 4'b1001) begin
            bram_transfer_enable    <= 1'b0;
        end
    end
    
    always @ (posedge clk) begin
        if (!rst_n) begin
            AXI_first_buf               <= 1'b0;
        end
        else if (AXI_first) begin
            AXI_first_buf               <= 1'b1;
        end
        else if (bram_transfer_enable) begin
            AXI_first_buf               <= 1'b0;
        end
    end
    
    
    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_1                  <= 'b0;
            en_b_1                  <= 'b0;
            we_a_1                  <= 'b0;
            we_b_1                  <= 'b0;
            addr_a_1                <= 'h0;
            addr_b_1                <= 'h1;
            din_a_1                 <= 'b0;
            din_b_1                 <= 'b0;

        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                addr_a_1        <= addr_a_1 + 'h2;
                addr_b_1        <= addr_b_1 + 'h2;
 
                en_a_1              <= 1'b1;
                en_b_1              <= 1'b1;
                we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                we_b_1              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin
                en_a_1              <= 'b0;
                en_b_1              <= 'b0;
            end
            
            if(data_i_cnt == 4'b0000)       begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];    
            end
            else if (data_i_cnt == 4'b0001) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0010) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0011) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0100) begin
                din_a_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            
            if(data_i_cnt == 4'b0101)       begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];    
            end
            else if (data_i_cnt == 4'b0110) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0111) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1000) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1001) begin
                din_b_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_1                  <= 'b0;
            en_b_1                  <= 'b0;
            we_a_1                  <= 'b0;
            we_b_1                  <= 'b0;
            
            if(addr_a_1 > 1) begin
                addr_a_1 <= addr_a_1 - 2;
            end
            if(addr_b_1 > 1) begin
                addr_b_1 <= addr_b_1 - 2;
            end           
           
        end
        else if (state == CONV_FIRST) begin
            if(AXI_first_buf || AXI_lastline_buf) begin // line buf : 2
                if(cnt == 1 || cnt == 6) begin //read
                    en_a_1                  <= 'b1;
                    en_b_1                  <= 'b1;
                    we_a_1                  <= 'b0;
                    we_b_1                  <= 'b0;
                end
                else if(cnt == 9) begin
                    en_a_1              <= 1'b1;
                    en_b_1              <= 1'b1;
                    we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                    we_b_1              <= {LMB_WE_WIDTH{1'b1}};
                end
                else begin
                    en_a_1              <= 'b0;
                    en_b_1              <= 'b0;
                end
                
                if(cnt == 0 || cnt == 5) begin
                    CORE_data_o0 <= dout_a_1;
                    CORE_data_o1 <= dout_b_1;
                    core_data_valid <= 'b1;
                end
                
                if(data_i_cnt == 4'b0000)       begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];  
                end
                else if (data_i_cnt == 4'b0001) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0010) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0011) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0100) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                    data_to_core_a_n <= data_to_core_a; 
                end
                
                if(data_i_cnt == 4'b0101)       begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];  
                end
                else if (data_i_cnt == 4'b0110) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0111) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                end
                else if (data_i_cnt == 4'b1000) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                end
                else if (data_i_cnt == 4'b1001) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                    data_to_core_b_n <= data_to_core_b;
                end 
            end
            else begin // line buf : 3, 4
                if(cnt == 0 || cnt == 1 || cnt == 5 || cnt == 6) begin //read
                    en_a_1                  <= 'b1;
                    en_b_1                  <= 'b1;
                    we_a_1                  <= 'b0;
                    we_b_1                  <= 'b0;
                end
                else if(cnt == 9) begin
                    en_a_1              <= 1'b1;
                    en_b_1              <= 1'b1;
                    we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                    we_b_1              <= {LMB_WE_WIDTH{1'b1}};
                end
                else begin
                    en_a_1              <= 'b0;
                    en_b_1              <= 'b0;
                end
                
                if(cnt == 4) begin
                    core_data_temp_0 <= dout_a_1;
                    core_data_temp_1 <= dout_b_1;
                end
                else if(cnt == 5) begin
                    CORE_data_o0 <= core_data_temp_0;
                    CORE_data_o1 <= core_data_temp_1;
                    CORE_data_o2 <= dout_a_1;
                    CORE_data_o3 <= dout_b_1;
                end
                
                if(data_i_cnt == 4'b0000)       begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];  
                end
                else if (data_i_cnt == 4'b0001) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0010) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0011) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0100) begin
                    din_a_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_a[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                
                if(data_i_cnt == 4'b0101)       begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];  
                end
                else if (data_i_cnt == 4'b0110) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width]; 
                end
                else if (data_i_cnt == 4'b0111) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                end
                else if (data_i_cnt == 4'b1000) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                end
                else if (data_i_cnt == 4'b1001) begin
                    din_b_1[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width]        <= AXI_data_i[31 - input_width * 0  -: input_width];  
                    data_to_core_b[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 0  -: input_width];
                end
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_2                  <= 'b0;
            en_b_2                  <= 'b0;
            we_a_2                  <= 'b0;
            we_b_2                  <= 'b0;
            addr_a_2                <= 'h0;
            addr_b_2                <= 'h1;
            din_a_2                 <= 'b0;
            din_b_2                 <= 'b0;

        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                addr_a_2        <= addr_a_2 + 'h2;
                addr_b_2        <= addr_b_2 + 'h2;
 
                en_a_2              <= 1'b1;
                en_b_2              <= 1'b1;
                we_a_2              <= {LMB_WE_WIDTH{1'b1}};
                we_b_2              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin
                en_a_2              <= 'b0;
                en_b_2              <= 'b0;
            end
            
            if(data_i_cnt == 4'b0000)       begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width];    
            end
            else if (data_i_cnt == 4'b0001) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0010) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0011) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0100) begin
                din_a_2[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            
            if(data_i_cnt == 4'b0101)       begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width];    
            end
            else if (data_i_cnt == 4'b0110) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0111) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1000) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1001) begin
                din_b_2[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 1  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_2                  <= 'b1;
            en_b_2                  <= 'b1;
            we_a_2                  <= 'b0;
            we_b_2                  <= 'b0;
            
            if(addr_a_2 > 1) begin
                addr_a_2 <= addr_a_2 - 2;
            end
            if(addr_b_2 > 1) begin
                addr_b_2 <= addr_b_2 - 2;
            end           
           
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            en_a_3                  <= 'b0;
            en_b_3                  <= 'b0;
            we_a_3                  <= 'b0;
            we_b_3                  <= 'b0;
            addr_a_3                <= 'h0;
            addr_b_3                <= 'h1;
            din_a_3                 <= 'b0;
            din_b_3                 <= 'b0;

        end
        else if (state == INIT) begin
            if (bram_transfer_enable) begin
                addr_a_3        <= addr_a_3 + 'h2;
                addr_b_3        <= addr_b_3 + 'h2;
 
                en_a_3              <= 1'b1;
                en_b_3              <= 1'b1;
                we_a_3              <= {LMB_WE_WIDTH{1'b1}};
                we_b_3              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin
                en_a_3              <= 'b0;
                en_b_3              <= 'b0;
            end
            
            if(data_i_cnt == 4'b0000)       begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width];    
            end
            else if (data_i_cnt == 4'b0001) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0010) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0011) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0100) begin
                din_a_3[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            
            if(data_i_cnt == 4'b0101)       begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 0 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width];    
            end
            else if (data_i_cnt == 4'b0110) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 1 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b0111) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 2 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1000) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 3 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
            else if (data_i_cnt == 4'b1001) begin
                din_b_3[LMB_DATA_WIDTH-1 - input_width * 4 -: input_width] <= AXI_data_i[31 - input_width * 2  -: input_width]; 
            end
        end
        else if(state == SETUP_CONV_FIRST) begin
            en_a_3                  <= 'b1;
            en_b_3                  <= 'b1;
            we_a_3                  <= 'b0;
            we_b_3                  <= 'b0;
            
            if(addr_a_3 > 1) begin
                addr_a_3 <= addr_a_3 - 2;
            end
            if(addr_b_3 > 1) begin
                addr_b_3 <= addr_b_3 - 2;
            end           
           
        end
    end

    // -----------------------------------------------------------------------------

endmodule
