module TB_FETCHER
(
//	input clk,
//	input rst_n,
	//output [8:1] led
);

	reg clk;
	reg rst_n;

	task INIT;
        begin
            clk                 = 1'b0;
            rst_n               = 1'b1;
        end
    endtask
	
	initial begin
		forever begin
			#5 clk = ~clk;
		end
	end
	
	task RESET;
        begin
            rst_n <= 1'b0;
            repeat (5) @(posedge clk);
            rst_n <= 1'b1;
            @(posedge clk);
        end
    endtask
    
    reg interrupt;
    initial begin
        INIT;
        repeat (5) @(posedge clk);
        RESET;
        repeat (10) @(posedge clk);
        interrupt <= 'b1;
        repeat (10000) @(posedge clk);
        $finish;
    end

	reg [31:0] count;
	always @(posedge clk) begin
		if (!rst_n) begin
			count <= 'd0;
		end
		else begin
			count <= count + 'd1;
		end
	end

//    reg interrupt;
//    always @(posedge clk) begin
//    	if (!rst_n) begin
//    		interrupt <= 'b0;
//    	end
//    	else if (count >= 'd12345678) begin
//    		interrupt <= 'b1;
//    	end
//    end
    
    wire [8:1] test_out;
    
//    //assign led[8] = test_out[8];
//    assign led[7] = test_out[7];
//    assign led[6] = test_out[6];
//    assign led[5] = test_out[5];
//    assign led[4] = test_out[4];
//    assign led[3] = test_out[3];
//    assign led[2] = test_out[2];
//    assign led[1] = test_out[1];
    
    
    wire			en_b;
    wire [3:0]		we_a, we_b;
    wire [31:0]		addr_a, addr_b;
    wire [31:0]		din_a, din_b;
    wire [31:0]		dout_a, dout_b;
    wire [31:0]		PARAMETER;
    
    FETCHER DUT
    (
        .clk            (clk            ),
        .rst_n          (rst_n          ),
        .interrupt      (interrupt      ),
        .enable         (en_b			),
        .write_enable   (we_b			),
        .address        (addr_b			),
        .dout           (dout_b         ),

        .fetcher_valid  (fetcher_valid  ),
        .PARAMETER      (PARAMETER      )//,
        //.test_out       (test_out       )
    );
    
    assign we_a = 0;
    assign addr_a = 0;
    assign din_a = 0;

    blk_mem_gen_0 bram_inst
    (
		// Port A
        .clka                                   (clk            )   ,
        .wea                                    (we_a			)   ,
        .addra                                  (addr_a			)   ,
        .dina                                   (din_a			)   ,
        .douta                                  (dout_a			)   ,
        // Port B
        .clkb                                   (clk            )   ,
        .enb                                    (en_b			)   ,
        .web                                    (we_b			)   ,
        .addrb                                  (addr_b			)   ,
        .dinb                                   (din_b			)   ,
        .doutb                                  (dout_b			)
    );

endmodule