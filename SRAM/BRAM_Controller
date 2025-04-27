`timescale 1ns / 1ps
// BRAM testbench by HS
module BRAM_Controller();

// Parameters
parameter DATA_WIDTH = 24; // 임시 비트
parameter ADDR_WIDTH = 11; // 1920 위치를 표현하기 위해 11비트 필요 (log2(1920) ≈ 10.906)

// Signals for Port A
reg clk;

reg en_a;
reg we_a;
reg [ADDR_WIDTH-1:0] addr_a;
reg [DATA_WIDTH-1:0] din_a;
wire [DATA_WIDTH-1:0] dout_a;

// Signals for Port B
reg en_b;
reg we_b;
reg [ADDR_WIDTH-1:0] addr_b;
reg [DATA_WIDTH-1:0] din_b;
wire [DATA_WIDTH-1:0] dout_b;

// Clock generation
always #5 clk = ~clk; // 100 MHz for Port A




// Test sequence
initial begin
    // Initialize signals
    clk <= 0;
    en_a <= 0;
    en_b <= 0;
    we_a <= 0;
    we_b <= 0;
    addr_a <= 0;
    addr_b <= 0;
    din_a <= 0;
    din_b <= 0;

    // wait
    repeat (3) @ (posedge clk);

    // memory enable
    en_a = 1;
    en_b = 1;

    // Port A: write in addr 0
    we_a = 1; // write
    addr_a = 0;
    din_a = 24'hAABBCC; // 24bit data
    repeat (1) @ (posedge clk);
    
    we_b = 1; // write
    addr_b = 0;
    din_b = 24'h112233; // 24bit data
    repeat (3) @ (posedge clk);

    // Port A: read in addr 0
    we_a = 0; // read
    addr_a = 0;
    repeat (1) @ (posedge clk);

    // Port B: read in addr 1
    we_b = 0; // read
    addr_b = 1;
repeat (1) @ (posedge clk);

    addr_a = 2;
    addr_b = 2;
    we_a = 1; // Port A write
    we_b = 0; // Port B read
    repeat (10) begin
        din_a <= $urandom;
        @(posedge clk);
    end
    $display("___Port B - read data in addr 2 (Read first test): %h", dout_a);
#100;
    $finish;
end

// Instantiate the True Dual Port BRAM IP
blk_mem_gen_1 u_bram (
    // Port A
    .clka(clk),
    .ena(en_a),
    .wea(we_a),
    .addra(addr_a),
    .dina(din_a),
    .douta(dout_a),
    // Port B
    .clkb(clk),
    .enb(en_b),
    .web(we_b),
    .addrb(addr_b),
    .dinb(din_b),
    .doutb(dout_b)
);
endmodule
