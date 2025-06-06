`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/01 23:23:11
// Design Name: 
// Module Name: bram_wrapper
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


module bram_write_monitor #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter TARGET_ADDR = 16'hD000,  // 모니터링할 주소 16'h3400
    parameter TARGET_PATTERN = 32'hFFFFFFFF  // 감지할 패턴
)(
    // AXI BRAM Controller B 포트 신호들
    input  wire                    BRAM_Clk_B,
    input  wire                    BRAM_Rst_B,
    input  wire                    BRAM_EN_B,
    input  wire [3:0]              BRAM_WE_B,
    input  wire [15:0]             BRAM_Addr_B,
    input  wire [DATA_WIDTH-1:0]   BRAM_WrData_B,
    output wire [DATA_WIDTH-1:0]   BRAM_RdData_B,
    
    // BRAM 포트 B 연결 신호들
    output wire                    BRAM_Clk_B_out,
    output wire                    BRAM_Rst_B_out,
    output wire                    BRAM_EN_B_out,
    output wire [3:0]              BRAM_WE_B_out,
    output wire [31:0]             BRAM_Addr_B_out,
    output wire [DATA_WIDTH-1:0]   BRAM_WrData_B_out,
    input  wire [DATA_WIDTH-1:0]   BRAM_RdData_B_in,
    
    // Interrupt 출력
    output reg                     interrupt_out
);

    // 신호들을 그대로 통과시킴 (패스스루)
    assign BRAM_Clk_B_out = BRAM_Clk_B;
    assign BRAM_Rst_B_out = BRAM_Rst_B;
    assign BRAM_EN_B_out = BRAM_EN_B;
    assign BRAM_WE_B_out = BRAM_WE_B;
    assign BRAM_Addr_B_out = BRAM_Addr_B;
    assign BRAM_WrData_B_out = BRAM_WrData_B;
    assign BRAM_RdData_B = BRAM_RdData_B_in;
    
    reg pattern_seen;

    // Write 동작 감지 및 패턴 매칭
    always @(posedge BRAM_Clk_B) begin
        if (BRAM_Rst_B) begin
            pattern_seen <= 1'b0;
            interrupt_out <= 1'b0;
        end else begin
            // Write Enable이 활성화되고, 타겟 주소에 타겟 패턴이 쓰여질 때
            if (BRAM_EN_B && (|BRAM_WE_B) && 
                (BRAM_Addr_B == TARGET_ADDR) && 
                (BRAM_WrData_B == TARGET_PATTERN)) begin
                pattern_seen <= 1'b1;
            end
            
            if (pattern_seen) begin
                interrupt_out <= 1'b1;
            end else begin
                interrupt_out <= 1'b0;  // 한 클럭만 펄스
            end
        end
    end

endmodule
