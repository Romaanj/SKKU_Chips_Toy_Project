module BRAM_ACCESS_CONTROLLER_TB;

    parameter                                       Q_INT_INPUT         = 2         ;
    parameter                                       Q_FRAC_INPUT        = 15        ;

    parameter                                       HSIZE = 84                      ;
    parameter                                       VSIZE = 84                      ;

    parameter                                       mem_size = HSIZE * VSIZE        ;

    // -------------------------------------------------------------------------------

    reg                                             clk                             ;
    reg                                             rst_n                           ;

    // -------------------------------------------------------------------------------

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_0 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_1 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_2 [0:mem_size-1]      ;

    // -------------------------------------------------------------------------------

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              data_i_0                        ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              data_i_1                        ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              data_i_2                        ;
    
    wire [3*(Q_INT_INPUT+Q_FRAC_INPUT)-1:0]         data_i                          ;
    
    assign                                          data_i = {data_i_0, data_i_1, data_i_2};

    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // function definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // task definition start
    // -------------------------------------------------------------------------------

    task INIT;
        begin
            clk     = 1'b0;
            rst_n   = 1'b1;
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

    task automatic READ_INPUT;
        begin
            $readmemh("input_0.txt", mem_input_0);
            $readmemh("input_1.txt", mem_input_1);
            $readmemh("input_2.txt", mem_input_2);
        end
    endtask

    task automatic DRIVE_INPUT;
        integer i;
        integer j;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j = j + 1) begin

                    data_i_0            <= mem_input_0[i * HSIZE + j];
                    data_i_1            <= mem_input_1[i * HSIZE + j];
                    data_i_2            <= mem_input_2[i * HSIZE + j];

                    data_i_valid        <= 1'b1;

                    if (j == 0) begin
                        first           <= 1'b1;
                        if (i == VSIZE - 1) begin
                            lastline    <= 1'b1;
                        end
                    end
                    else begin
                        first           <= 1'b0;
                        lastline        <= 1'b0;
                    end

                    if (j == HSIZE - 1) begin
                        last            <= 1'b1;
                    end
                    else begin
                        last            <= 1'b0;
                    end

                    @(posedge clk);
                end
            end
        end
    endtask
    
	task TEST_BRAM_INIT;
        begin
            RESET;
            READ_INPUT;
            DRIVE_INPUT;
        end
	endtask

    // -------------------------------------------------------------------------------
    // task definition finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // test start
    // -------------------------------------------------------------------------------

    // clock generation
    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end

    // scenario of test
    initial begin
        INIT;
        repeat (5) @(posedge clk);
        RESET;
        TEST_BRAM_INIT;
        $finish;
    end

    // -------------------------------------------------------------------------------
    // test finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    BRAM_TOP
    #(
        .LMB_DATA_WIDTH                 (LMB_DATA_WIDTH )   ,
        .LMB_ADDR_WIDTH                 (LMB_ADDR_WIDTH )   ,
        .LMB_WE_WIDTH                   (LMB_WE_WIDTH   )   ,
        .Q_INT_INPUT                    (Q_INT_INPUT    )   ,
        .Q_FRAC_INPUT                   (Q_FRAC_INPUT   )
    )
    bram_top_inst
    (
        .clk                            (clk            )   ,
        .rst_n                          (rst_n          )   ,

        .data_i                         (data_i         )   ,
        .data_i_valid                   (data_i_valid   )   ,
        .first                          (first          )   ,
        .last                           (last           )   ,
        .lastline                       (lastline       )   ,
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule