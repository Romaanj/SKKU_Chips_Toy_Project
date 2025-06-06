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

    input                                       PIXEL_START                 ,
    input                                       PIXEL_valid                 ,
    input                                       PIXEL_first                 ,
    input                                       PIXEL_last                  ,
    input                                       PIXEL_lastline              ,

    input [39:0]                                PIXEL_R                     ,
    input [39:0]                                PIXEL_G                     ,
    input [39:0]                                PIXEL_B                     ,
    

    // LMB Channel 1
    output reg [LMB_WE_WIDTH-1:0]               we_a_1                      ,
    output reg [LMB_WE_WIDTH-1:0]               we_b_1                      ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_a_1                    ,
    output reg [LMB_ADDR_WIDTH-1:0]             addr_b_1                    ,
    output reg [LMB_DATA_WIDTH-1:0]             din_a_1                     ,
    output reg [LMB_DATA_WIDTH-1:0]             din_b_1                     ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_a_1                    ,
    input wire [LMB_DATA_WIDTH-1:0]             dout_b_1

    // LMB Channel 2
    //output reg [LMB_WE_WIDTH-1:0]               we_a_2                      ,
    //output reg [LMB_WE_WIDTH-1:0]               we_b_2                      ,
    //output reg [LMB_ADDR_WIDTH-1:0]             addr_a_2                    ,
    //output reg [LMB_ADDR_WIDTH-1:0]             addr_b_2                    ,
    //output reg [LMB_DATA_WIDTH-1:0]             din_a_2                     ,
    //output reg [LMB_DATA_WIDTH-1:0]             din_b_2                     ,
    //input wire [LMB_DATA_WIDTH-1:0]             dout_a_2                    ,
    //input wire [LMB_DATA_WIDTH-1:0]             dout_b_2                    ,

    // LMB Channel 3
    //output reg [LMB_WE_WIDTH-1:0]               we_a_3                      ,
    //output reg [LMB_WE_WIDTH-1:0]               we_b_3                      ,
    //output reg [LMB_ADDR_WIDTH-1:0]             addr_a_3                    ,
    //output reg [LMB_ADDR_WIDTH-1:0]             addr_b_3                    ,
    //output reg [LMB_DATA_WIDTH-1:0]             din_a_3                     ,
    //output reg [LMB_DATA_WIDTH-1:0]             din_b_3                     ,
    //input wire [LMB_DATA_WIDTH-1:0]             dout_a_3                    ,
    //input wire [LMB_DATA_WIDTH-1:0]             dout_b_3    
);

    // -----------------------------------------------------------------------------
    localparam                                  IDLE                = 4'd0;
    localparam                                  INIT                = 4'd1;
    localparam                                  CONV_FIRST          = 4'd2;

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
                if (PIXEL_START) begin
                    state_n         = CONV_FIRST;
                end
            end
            //CONV_FIRST : begin
                //state_n             = CONV_FIRST;
            //end
        endcase
    end
    // -----------------------------------------------------------------------------
    reg                                         PIXEL_valid_delay_1;
    reg                                         PIXEL_last_delay_1;
    always @(posedge clk) begin
        PIXEL_valid_delay_1 <= PIXEL_valid;
        PIXEL_last_delay_1 <= PIXEL_last;
    end

    reg [6:0]                                   cnt_PIXEL_last;
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_PIXEL_last <= 'd0;
        end
        else if (PIXEL_last) begin
            if (cnt_PIXEL_last == 'd83) begin
                cnt_PIXEL_last <= 'd0;
            end
            else begin
                cnt_PIXEL_last <= cnt_PIXEL_last + 'd1;
            end
        end
    end

    reg                                         PIXEL_lastline_buf;
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

    reg                             PIXEL_even;
    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_even <= 1'b0;
        end
        else if (PIXEL_valid) begin
            PIXEL_even <= ~PIXEL_even;
        end
    end

    reg [39:0]                      data_to_core_buf_0;
    reg [39:0]                      data_to_core_buf_1;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            we_a_1                  <= 'b0;
            we_b_1                  <= 'b0;
            din_a_1                 <= 'b0;
            din_b_1                 <= 'b0;
        end
        else if (state == CONV_FIRST) begin
            if (PIXEL_valid) begin
                if (PIXEL_even) begin
                    if (PIXEL_last) begin
                        we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                        din_a_1             <= {PIXEL_R[39 -: 32], 8'b0};
                    end
                    else begin
                        we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                        we_b_1              <= {LMB_WE_WIDTH{1'b1}};
                        din_b_1             <= PIXEL_R;
                    end
                end
                else if (PIXEL_last) begin
                    we_a_1              <= {LMB_WE_WIDTH{1'b1}};
                    din_a_1             <= {PIXEL_R[39 -: 32], 8'b0};
                end
                else begin
                    din_a_1             <= PIXEL_R;
                end
            end
            else begin
                we_a_1              <= 'b0;
                we_b_1              <= 'b0;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            addr_a_1 <= 'h0;
            addr_b_1 <= 'h0;
        end
        else if (state == INIT) begin
            addr_b_1 <= 'h1;
        end
        else if (state == CONV_FIRST && PIXEL_valid_delay_1) begin
            if (PIXEL_last_delay_1) begin
                addr_a_1 <= addr_b_1;
                addr_b_1 <= addr_b_1 + 'h1;
            end
            else if (~PIXEL_even) begin
                addr_a_1 <= addr_a_1 + 'h2;
                addr_b_1 <= addr_b_1 + 'h2;
            end
        end
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
