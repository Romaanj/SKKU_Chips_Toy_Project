module TOP_TB;

    reg     clk;
    reg     rst_n;
    reg     interrupt;

    task INIT;
        begin
            clk                 = 1'b0;
            rst_n               = 1'b1;
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

    task INTERRUPT;
        begin
            interrupt <= 1'b1;
            repeat (100) @(posedge clk);
            interrupt <= 1'b0;
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
        repeat (5) @(posedge clk);
        INTERRUPT;
        repeat (10000) @(posedge clk);
        $finish;
    end

    ACCELERATOR_TOP
    accelerator_top_inst
    (
        .clk                (clk                ),
        .rst_n              (rst_n              ),
        .interrupt          (interrupt          )
    );

endmodule