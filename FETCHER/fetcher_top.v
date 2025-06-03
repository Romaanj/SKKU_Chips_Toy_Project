module FETCHER_TOP
(
	input               clk,
	input               rst_n,
    input               clken,
    input               interrupt,

    output              clk_disable     ,

    output              PARAMETER_valid ,
    output [2:0]        PARAMETER_layer ,
    output [1:0]        PARAMETER_type  ,

    output [31:0]       PARAMETER       ,

    output              PIXEL_valid     ,
    output              PIXEL_first     ,
    output              PIXEL_last      ,
    output              PIXEL_lastline  ,

    output [39:0]       PIXEL_R         ,
    output [39:0]       PIXEL_G         ,
    output [39:0]       PIXEL_B
);

    wire			en_b;
    wire [3:0]		we_a, we_b;
    wire [31:0]		addr_a, addr_b;
    wire [31:0]		din_a, din_b;
    wire [31:0]		dout_a, dout_b;

    FETCHER fetcher_inst
    (
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .clken              (clken              ),
        .interrupt          (interrupt          ),

        .enable             (en_b               ),
        .write_enable       (we_b			    ),
        .address            (addr_b			    ),
        .dout               (dout_b             ),

        .clk_disable        (clk_disable        ),

        .PARAMETER_valid    (PARAMETER_valid    ),
        .PARAMETER_layer    (PARAMETER_layer    ),
        .PARAMETER_type     (PARAMETER_type     ),

        .PARAMETER          (PARAMETER          ),

        .PIXEL_valid        (PIXEL_valid        ),
        .PIXEL_first        (PIXEL_first        ),
        .PIXEL_last         (PIXEL_last         ),
        .PIXEL_lastline     (PIXEL_lastline     ),

        .PIXEL_R            (PIXEL_R            ),
        .PIXEL_G            (PIXEL_G            ),
        .PIXEL_B            (PIXEL_B            )
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