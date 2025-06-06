module BRAM_ACCESS_CONTROLLER
#(
    parameter                                   LMB_DATA_WIDTH      = 40    ,
    parameter                                   LMB_ADDR_WIDTH      = 12    ,
    parameter                                   LMB_WE_WIDTH        = 5     ,
    parameter                                   Q_INT_INPUT         = 1     ,
    parameter                                   Q_FRAC_INPUT        = 7
)
(
    input wire                                  clk                         ,
    input wire                                  rst_n                       ,

    //input [79:0]                                CORE_data_i,
    //input                                       CORE_data_i_valid,
    //input                                       CORE_first,
    //input                                       CORE_last,
    //input                                       CORE_lastline,
    //output reg [39:0]                           data_to_core_a_n, // from fetcher to core
    //reg [39:0]                                  data_to_core_a, // to send all value at one time
    //reg [39:0]                                  data_to_core_b,
    //output reg [39:0]                           data_to_core_b_n,
    //output reg [39:0]                           CORE_data_o0,
    //output reg [39:0]                           CORE_data_o1,
    //output reg [39:0]                           CORE_data_o2,
    //output reg [39:0]                           CORE_data_o3,
    //output reg [39:0]                           CORE_data_o4,
    //output reg [39:0]                           CORE_data_o5,
    //output reg [39:0]                           CORE_data_o6,
    //output reg [39:0]                           CORE_data_o7,
    //output reg [39:0]                           CORE_data_o8,
    //output reg [39:0]                           CORE_data_o9,
    //output reg [39:0]                           CORE_data_o10,
    //output reg [39:0]                           CORE_data_o11,
    //output reg [39:0]                           CORE_data_o12,
    //output reg [39:0]                           CORE_data_o13,
    //output reg [39:0]                           CORE_data_o14,
    //output reg [39:0]                           CORE_data_o15,
    //output reg [39:0]                           CORE_data_o16,
    //output reg [39:0]                           CORE_data_o17,
    //output reg [39:0]                           CORE_data_o18,
    //output reg [39:0]                           CORE_data_o19,
    //output reg [39:0]                           CORE_data_o20,
    //output reg [39:0]                           CORE_data_o21,
    //output reg [39:0]                           CORE_data_o22,
    //output reg [39:0]                           CORE_data_o23,
    //output reg [39:0]                           CORE_data_o24,
    //output reg [39:0]                           CORE_data_o25,
    //output reg                                  core_data_valid,
    
    input [39:0]                                PIXEL_R             ,
    input [39:0]                                PIXEL_G             ,
    input [39:0]                                PIXEL_B             ,
    
    input                                       PIXEL_valid         ,
    input                                       PIXEL_first         ,
    input                                       PIXEL_last          ,
    input                                       PIXEL_lastline      ,

    // LMB Channel 1
    output reg                                  en_a_1              ,
    output reg                                  en_b_1              ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_1              ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_1              ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_1            ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_1            ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_1             ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_1             ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_1            ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_1            ,

    // LMB Channel 2
    output reg                                  en_a_2              ,
    output reg                                  en_b_2              ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_2              ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_2              ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_2            ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_2            ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_2             ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_2             ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_2            ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_2            ,

    // LMB Channel 3
    output reg                                  en_a_3              ,
    output reg                                  en_b_3              ,
    output reg [LMB_WE_WIDTH-1:0]               we_a_3              ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_3              ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_3            ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_3            ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_3             ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_3             ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_3            ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_3    
);

    // -----------------------------------------------------------------------------
    localparam                                  IDLE                = 4'd0;
    localparam                                  INIT                = 4'd1;
    localparam                                  SETUP_CONV_FIRST    = 4'd2;
    localparam                                  CONV_FIRST          = 4'd3;
    localparam                                  SETUP_CONV_SHRINK   = 4'd4;
    
    reg [3:0]                                   state_n;
    reg [3:0]                                   state;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
        end
        else begin
            state <= state_n;
        end
    end

    always @(*) begin
        state_n                     = state;
        case (state)
            IDLE : begin
                state_n             = INIT;
            end
            INIT : begin
                state_n             = state;
                //if (PIXEL_last) begin // 임시로 해놓음
                    //state_n         = SETUP_CONV_FIRST;
                //end
            end
            //SETUP_CONV_FIRST : begin
                //state_n             = CONV_FIRST;
            //end
        endcase
    end
    // -----------------------------------------------------------------------------

    reg                                         PIXEL_first_buf;
    reg                                         PIXEL_lastline_buf;

    always @ (posedge clk) begin
        if (!rst_n) begin
            PIXEL_first_buf               <= 1'b0;
        end
        else if (PIXEL_first) begin
            PIXEL_first_buf               <= 1'b1;
        end
        else if (bram_transfer_enable) begin
            PIXEL_first_buf               <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            PIXEL_lastline_buf            <= 'b0;
        end
        else if (PIXEL_lastline) begin
            PIXEL_lastline_buf            <= 'b1;
        end 
        else if (PIXEL_last) begin
            PIXEL_lastline_buf            <= 'b0;
        end
    end
    // -----------------------------------------------------------------------------

    reg [1:0]                       num_line_buffer;
    always @(posedge clk) begin
        if (!rst_n) begin
            num_line_buffer <= 0;
        end
        else if(PIXEL_last) begin
            num_line_buffer <= num_line_buffer + 'b01;
        end
    end
    // -----------------------------------------------------------------------------

    localparam                      input_width = Q_INT_INPUT + Q_FRAC_INPUT;
    reg [39:0]                      data_to_core_buf_0;
    reg [39:0]                      data_to_core_buf_1;
    
    always @(posedge clk) begin
        if (!rst_n) begin
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
 
                we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                we_b_1              <= {LMB_WE_WIDTH{1'b1}};
            end
            else begin
            end
        end
        //else if(state == SETUP_CONV_FIRST) begin
            //en_a_1                  <= 'b0;
            //en_b_1                  <= 'b0;
            //we_a_1                  <= 'b0;
            //we_b_1                  <= 'b0;
            //
            //if(addr_a_1 > 1) begin
                //addr_a_1 <= addr_a_1 - 2;
            //end
            //if(addr_b_1 > 1) begin
                //addr_b_1 <= addr_b_1 - 2;
            //end           
           //
        //end
        //else if (state == CONV_FIRST) begin
            //if(PIXEL_first_buf || PIXEL_lastline_buf) begin // line buf : 2
                //if(cnt == 1 || cnt == 6) begin //read
                    //en_a_1                  <= 'b1;
                    //en_b_1                  <= 'b1;
                    //we_a_1                  <= 'b0;
                    //we_b_1                  <= 'b0;
                //end
                //else if(cnt == 9) begin
                    //en_a_1              <= 1'b1;
                    //en_b_1              <= 1'b1;
                    //we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                    //we_b_1              <= {LMB_WE_WIDTH{1'b1}};
                //end
                //else begin
                    //en_a_1              <= 'b0;
                    //en_b_1              <= 'b0;
                //end
                //
                //if(cnt == 0 || cnt == 5) begin
                    //CORE_data_o0 <= dout_a_1;
                    //CORE_data_o1 <= dout_b_1;
                    //core_data_valid <= 'b1;
                //end
            //end
            //else begin // line buf : 3, 4
                //if(cnt == 0 || cnt == 1 || cnt == 5 || cnt == 6) begin //read
                    //en_a_1                  <= 'b1;
                    //en_b_1                  <= 'b1;
                    //we_a_1                  <= 'b0;
                    //we_b_1                  <= 'b0;
                //end
                //else if(cnt == 9) begin
                    //en_a_1              <= 1'b1;
                    //en_b_1              <= 1'b1;
                    //we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                    //we_b_1              <= {LMB_WE_WIDTH{1'b1}};
                //end
                //else begin
                    //en_a_1              <= 'b0;
                    //en_b_1              <= 'b0;
                //end
                //
                //if(cnt == 4) begin
                    //data_to_core_buf_0 <= dout_a_1;
                    //data_to_core_buf_1 <= dout_b_1;
                //end
                //else if(cnt == 5) begin
                    //CORE_data_o0 <= data_to_core_buf_0;
                    //CORE_data_o1 <= data_to_core_buf_1;
                    //CORE_data_o2 <= dout_a_1;
                    //CORE_data_o3 <= dout_b_1;
                //end
            //end
        //end
    end

    //always @(posedge clk) begin
        //if (!rst_n) begin
            //we_a_2                  <= 'b0;
            //we_b_2                  <= 'b0;
            //addr_a_2                <= 'h0;
            //addr_b_2                <= 'h1;
            //din_a_2                 <= 'b0;
            //din_b_2                 <= 'b0;
        //end
        //else if (state == INIT) begin
            //if (bram_transfer_enable) begin
                //addr_a_2        <= addr_a_2 + 'h2;
                //addr_b_2        <= addr_b_2 + 'h2;
 //
                //en_a_2              <= 1'b1;
                //en_b_2              <= 1'b1;
                //we_a_2              <= {LMB_WE_WIDTH{1'b1}};
                //we_b_2              <= {LMB_WE_WIDTH{1'b1}};
            //end
            //else begin
            //end
        //end
        ////else if(state == SETUP_CONV_FIRST) begin
            ////en_a_2                  <= 'b1;
            ////en_b_2                  <= 'b1;
            ////we_a_2                  <= 'b0;
            ////we_b_2                  <= 'b0;
            ////if(addr_a_2 > 1) begin
                ////addr_a_2 <= addr_a_2 - 2;
            ////end
            ////if(addr_b_2 > 1) begin
                ////addr_b_2 <= addr_b_2 - 2;
            ////end           
        ////end
    //end
//
    //always @(posedge clk) begin
        //if (!rst_n) begin
            //we_a_3                  <= 'b0;
            //we_b_3                  <= 'b0;
            //addr_a_3                <= 'h0;
            //addr_b_3                <= 'h1;
            //din_a_3                 <= 'b0;
            //din_b_3                 <= 'b0;
        //end
        //else if (state == INIT) begin
            //if (bram_transfer_enable) begin
                //addr_a_3        <= addr_a_3 + 'h2;
                //addr_b_3        <= addr_b_3 + 'h2;
 //
                //we_a_3              <= {LMB_WE_WIDTH{1'b1}};
                //we_b_3              <= {LMB_WE_WIDTH{1'b1}};
            //end
            //else begin
            //end
        //end
        ////else if(state == SETUP_CONV_FIRST) begin
            ////we_a_3                  <= 'b0;
            ////we_b_3                  <= 'b0;
            ////
            ////if(addr_a_3 > 1) begin
                ////addr_a_3 <= addr_a_3 - 2;
            ////end
            ////if(addr_b_3 > 1) begin
                ////addr_b_3 <= addr_b_3 - 2;
            ////end           
           ////
        ////end
    //end

    // -----------------------------------------------------------------------------

endmodule
