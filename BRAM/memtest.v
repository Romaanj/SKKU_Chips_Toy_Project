`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/13 10:55:29
// Design Name: 
// Module Name: mem_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_test
#(
 parameter DATA_WIDTH         = 8            ,
 parameter ADDR_WIDTH         = 16           ,
 parameter DATA_NUM           = 128
)
(
/*****************************************************
** Input Signal Define                              **
*****************************************************/
input  wire                   clk            ,
input  wire                   rstb           ,
input  wire [DATA_WIDTH-1:0]  data_read      ,
input  wire                   write_done     ,
input  wire                   read_done      ,
input  wire                   test_start     ,
/*****************************************************
** Output Signal Define                             **
*****************************************************/ 
output wire [DATA_WIDTH-1:0]  data_write     ,
output wire [ADDR_WIDTH-1:0]  data_addr      ,
output reg                    write_valid    ,
output reg                    read_valid     ,
output reg                    test_end       ,
output reg                    test_error    ,
output reg       [8:0]               test_buf);
reg  [ADDR_WIDTH-1:0]  test_error_cnt;
/*****************************************************
** Parameter Definition                            **
*****************************************************/
localparam IDLE           = 6'b000001;
localparam WRITE         = 6'b000010;
localparam INIT_READ     = 6'b000100;
localparam READ          = 6'b001000;
localparam TEST_DONE    = 6'b010000;
localparam RESTART_TEST = 6'b100000;
/*****************************************************
** Wire Definition                                  **
*****************************************************/
wire                       test_start_r   ;
/*****************************************************
** Reg Definition                                  **
*****************************************************/
reg   [05:0]               cs, ns         ;
reg   [01:0]               test_start_d   ;
reg   [ADDR_WIDTH-1:0]     data_cnt       ;
reg   [ADDR_WIDTH-1:0]     data_cnt_buf   ;
reg   [DATA_WIDTH-1:0]     data_read_buf  ;
reg                        write_done_buf ;
reg                        read_done_buf  ;
/**********************************************************************
-- Test Start Edge Detect
**********************************************************************/
always @(posedge clk or negedge rstb) begin
   if (!rstb) begin
      test_start_d   <= 2'd0;
   end
   else begin
      test_start_d   <= {test_start_d[0], test_start};
   end
end

assign test_start_r  = (test_start_d == 2'b01);

/**********************************************************************
-- Done Signal Buffering
**********************************************************************/
always @(posedge clk or negedge rstb) begin
   if (!rstb) begin
      write_done_buf <= 1'b0;
      read_done_buf  <= 1'b0;
   end
   else begin
      write_done_buf <= write_done;
      read_done_buf  <= read_done;
   end
end

/**********************************************************************
-- Memory Test COM FSM
**********************************************************************/
always @( * ) begin
   case ( cs )
      IDLE   : if (test_start_r) begin  
                  ns = WRITE;
               end
               else begin  
                  ns = IDLE;
                end      /****************************************************************/                    
      WRITE: if ((data_cnt == DATA_NUM-1) && write_done_buf) begin
      	         ns = INIT_READ;
      	        end
               else begin
                    ns = WRITE;
                end      /****************************************************************/                    
      INIT_READ   : ns = READ;
/****************************************************************/                    
      READ : if ((data_cnt == DATA_NUM-1) && read_done_buf) begin
                 ns = TEST_DONE;
               end
               else begin
                    ns = READ;
               end 
      /****************************************************************/                    
      TEST_DONE : if (test_start_r) begin  
                     ns = RESTART_TEST;
                    end
                    else begin  
                    ns = TEST_DONE;
                    end 
/****************************************************************/                    
      RESTART_TEST: ns = WRITE; 
/****************************************************************/                    
      default  : ns = IDLE;
   endcase
end
/********************************************************************
// Memory Test SEQ FSM   
**********************************************************************/
always @(posedge clk or negedge rstb) begin
   if (!rstb) begin
      cs             <= IDLE;
      data_cnt       <= 'd0;
      data_cnt_buf   <= 'd0;
      data_read_buf  <= 'd0;
      test_error     <= 1'b0;
      test_error_cnt <= 'd0;
   end
   else begin
      cs <= ns;
/****************************************************************/                    
   case ( ns ) 
IDLE : begin test_end <= 1'b0; write_valid <= 1'b0; read_valid <= 1'b0; end
   WRITE: begin test_end <= 1'b0; write_valid <= 1'b1; read_valid <= 1'b0; end
INIT_READ : begin test_end <= 1'b0; write_valid <= 1'b0; read_valid <= 1'b0; end
    READ : begin test_end <= 1'b0; write_valid <= 1'b0; read_valid <= 1'b1; end
   TEST_DONE : begin test_end <= 1'b1; write_valid <= 1'b0; read_valid <= 1'b0; end
   default : begin test_end <= 1'b0; write_valid <= 1'b0; read_valid <= 1'b0; end
    endcase      
/****************************************************************/
     if ((ns == INIT_READ) || (ns == IDLE) || (ns == RESTART_TEST)) begin
         data_cnt    <= 'd0;
      end
      else if (write_done_buf || read_done_buf) begin
         data_cnt    <= data_cnt + 'd1;
      end      
      data_cnt_buf   <= data_cnt;
      data_read_buf  <= data_read;
      
      // Error Check
      if ((cs == INIT_READ) || (cs == RESTART_TEST)) begin
         test_error     <= 1'b0;
         test_error_cnt <= 'd0;
      end
      else if ((cs == READ) && read_done_buf) begin
         if (data_cnt_buf[DATA_WIDTH-1:0] != data_read_buf) begin
           /* test_buf[7]        <= data_cnt_buf[DATA_WIDTH-1:0] == 8'd255;
            test_buf[6]        <= data_cnt_buf[DATA_WIDTH-1:0] == 8'd254;
            test_buf[5]        <= data_cnt_buf[DATA_WIDTH-1:0] == 8'd253;
            test_buf[4]        <= data_cnt_buf[DATA_WIDTH-1:0] == 8'd252;
            test_buf[3]        <= data_read_buf[DATA_WIDTH-1:0] == 8'd255;
            test_buf[2]        <= data_read_buf[DATA_WIDTH-1:0] == 8'd254;
            test_buf[1]        <= data_read_buf[DATA_WIDTH-1:0] == 8'd253;
            test_buf[0]        <= data_read_buf[DATA_WIDTH-1:0] == 8'd252; */
            
            test_error     <= 1'b1;
            test_error_cnt <= test_error_cnt + 1;
         end
      end
   end
end 
always @(posedge clk or negedge rstb) begin
    if(!rstb) begin
    test_buf <= 0;
    end
    else if ((cs == READ) && read_done_buf) begin
         if (data_cnt_buf[DATA_WIDTH-1:0] != data_read_buf) begin
         if(data_cnt_buf == 17'd256) begin
         test_buf <= {1'b0, data_read_buf};
         end 
         end
      end
end
/****************************************************************/
assign data_write = data_cnt[DATA_WIDTH-1:0];
assign data_addr  = data_cnt;

endmodule

