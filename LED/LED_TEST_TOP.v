`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 21:15:28
// Design Name: 
// Module Name: LED_TEST_TOP
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


module LED_TEST_TOP
(
	input clk,
	input rst,
	
	output reg [16:1] led
);

	always @(posedge clk) begin
		if (!rst) begin
			led <= 0;
		end
		else begin
			led <= 16'hFFFF;
		end
	end

endmodule
