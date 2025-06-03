module TB_FETCHER;

    reg clk;
	reg rst_n;
    reg clken;
    reg interrupt;
    reg outside_signal;

    wire            PIXEL_valid;
    wire            PIXEL_first;
    wire            PIXEL_last;
    wire            PIXEL_lastline;
    
    wire [2:0]      PARAMETER_layer;
    wire [1:0]      PARAMETER_type;
    wire [31:0]     PARAMETER;
    wire [39:0]     PIXEL_R, PIXEL_G, PIXEL_B;

	task INIT;
        begin
            clk                 = 1'b0;
            rst_n               = 1'b1;
            clken               = 1'b1;
            interrupt           = 1'b0;
        end
    endtask

	task RESET;
        begin
            rst_n <= 1'b0;
            repeat (5) @(posedge clk);
            rst_n <= 1'b1;
            @(posedge clk);
        end
    endtask

	initial begin
		forever begin
			#5 clk = ~clk;
		end
	end

    initial begin
        INIT;
        repeat (5) @(posedge clk);
        RESET;
        repeat (10) @(posedge clk);
        interrupt <= 'b1;
        repeat (8200) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (200) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);

        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
       repeat (400) @(posedge clk);
        
        outside_signal <= 'b1;
        @(posedge clk);
        outside_signal <= 'b0;
        @(posedge clk);
        repeat (400) @(posedge clk);

        repeat (5000) @(posedge clk);
        $finish;
    end

    always @(posedge clk) begin
        if (clk_disable) begin
            clken <= 1'b0;
        end
        else if(outside_signal) begin
            clken <= 1'b1;
        end
    end

    assign we_a = 0;
    assign addr_a = 0;
    assign din_a = 0;

    FETCHER_TOP DUT
    (
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .clken              (clken              ),
        .interrupt          (interrupt          ),

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

endmodule