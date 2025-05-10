module CONV_FIRST_CALC_TB;

    parameter                                       Q_INT_INPUT         = 2         ;
    parameter                                       Q_FRAC_INPUT        = 13        ;

    parameter                                       Q_INT_WEIGHT        = 1         ;
    parameter                                       Q_FRAC_WEIGHT       = 13        ;

    parameter                                       Q_INT_BIAS          = 1         ;
    parameter                                       Q_FRAC_BIAS         = 13        ;

    parameter                                       Q_INT_SLOPE         = 3         ;
    parameter                                       Q_FRAC_SLOPE        = 13        ;

    parameter                                       Q_INT_INTERIM_1     = 3         ;
    parameter                                       Q_FRAC_INTERIM_1    = 26        ;

    parameter                                       Q_INT_INTERIM_2     = 3         ;
    parameter                                       Q_FRAC_INTERIM_2    = 13        ;

    parameter                                       Q_INT_OUTPUT        = 2         ;
    parameter                                       Q_FRAC_OUTPUT       = 13        ;



    parameter                                       HSIZE = 84                      ;
    parameter                                       VSIZE = 84                      ;

    parameter                                       mem_size = HSIZE * VSIZE        ;
    parameter                                       input_size = 75                 ;

    // -------------------------------------------------------------------------------

    reg                                             clk                             ;
    reg                                             rst_n                           ;

    // -------------------------------------------------------------------------------

    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_0 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_1 [0:mem_size-1]      ;
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              mem_input_2 [0:mem_size-1]      ;

    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            mem_weight  [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                mem_bias    [0:0]               ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              mem_slope   [0:0]               ;

    reg                                             convolution_enable              ;

    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_golden  [0:mem_size-1]      ;

    // -------------------------------------------------------------------------------
    
    reg [Q_INT_INPUT+Q_FRAC_INPUT-1:0]              data_in     [0:input_size-1]    ;
    reg [Q_INT_WEIGHT+Q_FRAC_WEIGHT-1:0]            weight_in   [0:input_size-1]    ;
    reg [Q_INT_BIAS+Q_FRAC_BIAS-1:0]                bias_in                         ;
    reg [Q_INT_SLOPE+Q_FRAC_SLOPE-1:0]              slope_in                        ;

    wire signed [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]    data_out                        ;
    wire                                            data_out_enable                 ;

    reg [Q_INT_OUTPUT+Q_FRAC_OUTPUT-1:0]            mem_output  [0:mem_size-1]      ;
    reg [31:0]                                      cnt_output                      ;

    // -------------------------------------------------------------------------------
    // function definition start
    // -------------------------------------------------------------------------------

    function is_padding
    (
        input integer HSIZE,
        input integer VSIZE,
        input integer row,
        input integer col
    );
        begin
            if (row < 0 || col < 0 || row >= VSIZE || col >= HSIZE) begin
                is_padding = 1'b1;
            end
            else begin
                is_padding = 1'b0;
            end
        end
    endfunction

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

    task automatic READ_INPUT
    (
        input integer output_channel_idx
    );
        reg [8*6-1:0] _weight;
        reg [8*4-1:0] _bias;
        reg [8*5-1:0] _slope;
        reg [8*6-1:0] _output;
        reg [8*1-1:0] _underbar;
        reg [8*4-1:0] _filetype;
        reg [8*1-1:0] _idx_up;
        reg [8*1-1:0] _idx_down;
        begin
            _weight         = "weight";
            _bias           = "bias";
            _slope          = "slope";
            _output         = "output";
            _underbar       = "_";
            _filetype       = ".txt";

            if (output_channel_idx > 9) begin
                _idx_up     = output_channel_idx / 10 + 48;
                _idx_down   = output_channel_idx % 10 + 48;
                $readmemh({_weight  , _underbar, _idx_up, _idx_down, _filetype}, mem_weight );
                $readmemh({_bias    , _underbar, _idx_up, _idx_down, _filetype}, mem_bias   );
                $readmemh({_slope   , _underbar, _idx_up, _idx_down, _filetype}, mem_slope  );
                $readmemh({_output  , _underbar, _idx_up, _idx_down, _filetype}, mem_golden );
            end
            else begin
                _idx_down   = output_channel_idx + 48;
                $readmemh({_weight  , _underbar, _idx_down, _filetype}, mem_weight );
                $readmemh({_bias    , _underbar, _idx_down, _filetype}, mem_bias   );
                $readmemh({_slope   , _underbar, _idx_down, _filetype}, mem_slope  );
                $readmemh({_output  , _underbar, _idx_down, _filetype}, mem_golden );
            end

            $readmemh("input_0.txt", mem_input_0);
            $readmemh("input_1.txt", mem_input_1);
            $readmemh("input_2.txt", mem_input_2);
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

    task automatic DRIVE_INPUT_0;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                        for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                            if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                data_in[((ii - i) * 5 + (jj - j)) + 12] <= 'b0;
                            end
                            else begin
                                data_in[((ii - i) * 5 + (jj - j)) + 12] <= mem_input_0[ii * HSIZE + jj];
                            end
                        end
                    end
                    @(posedge clk);
                end
            end
        end
    endtask
    
    task automatic DRIVE_INPUT_1;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                        for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                            if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                data_in[((ii - i) * 5 + (jj - j)) + 37] <= 1'b0;
                            end
                            else begin
                                data_in[((ii - i) * 5 + (jj - j)) + 37] <= mem_input_1[ii * HSIZE + jj];
                            end
                        end
                    end
                    @(posedge clk);
                end
            end
        end
    endtask

    task automatic DRIVE_INPUT_2;
        integer i;
        integer j;
        integer ii;
        integer jj;
        begin
            for (i = 0; i < VSIZE; i = i + 1) begin
                for (j = 0; j < HSIZE; j  = j + 1) begin
                    for (ii = i - 2; ii <= i + 2; ii = ii + 1) begin
                        for (jj = j - 2; jj <= j + 2; jj = jj + 1) begin
                            if (is_padding(HSIZE, VSIZE, ii, jj)) begin
                                data_in[((ii - i) * 5 + (jj - j)) + 62] <= 1'b0;
                            end
                            else begin
                                data_in[((ii - i) * 5 + (jj - j)) + 62] <= mem_input_2[ii * HSIZE + jj];
                            end
                        end
                    end
                    @(posedge clk);
                end
            end
        end
    endtask

    task DRIVE_INPUT;
        begin
            fork
                DRIVE_INPUT_0;
                DRIVE_INPUT_1;
                DRIVE_INPUT_2;
            join
        end
    endtask

    task automatic DRIVE_WEIGHT;
        integer i;
        begin
            for (i = 0; i < 75; i = i + 1) begin
                weight_in[i] <= mem_weight[i];
            end
            @(posedge clk);
        end
    endtask

    task DRIVE_BIAS;
        begin
            bias_in <= mem_bias[0];
            @(posedge clk);
        end
    endtask

    task DRIVE_SLOPE;
        begin
            slope_in <= mem_slope[0];
            @(posedge clk);
        end
    endtask

    task DRIVE;
        begin
            fork
                DRIVE_INPUT;
                DRIVE_WEIGHT;
                DRIVE_BIAS;
                DRIVE_SLOPE;
                begin
                    convolution_enable <= 1'b1;
                    @(posedge clk);
                end
            join
        end
    endtask

    task automatic PRINT_OUTPUT
    (
        input [31:0] num_output
    );
        integer i;
        begin
            for (i = 0; i < num_output; i = i + 1) begin
                $display("output[%d] = %X", i, mem_output[i]);
            end
        end
    endtask

    task automatic EVAL_ERROR
    (
        input [31:0]	num_output,
        input real		display_error_threshold
    );
        integer i;
        real error;
        real mean_error;
        begin
            mean_error = 0;
            for (i = 0; i < num_output; i = i + 1) begin
                if (mem_golden[i]) begin
                	error = $signed(mem_golden[i]) >= $signed(mem_output[i]) ?
                															$signed(mem_golden[i]) - $signed(mem_output[i]) :
                															$signed(mem_output[i]) - $signed(mem_golden[i]);
                	error = error / mem_golden[i] * 100;
                end
                else begin
                	error = 0;
                end
                if (error > display_error_threshold) begin
                	$display("[%d]: golden = %X, current = %X, difference = %d -> %f %%!!!",
                    i,
                    mem_golden[i],
                    mem_output[i],
                    $signed(mem_golden[i]) - $signed(mem_output[i]),
                    error);
                end
                mean_error = mean_error + error;
            end
            mean_error = mean_error / num_output;
            $display("Mean Error: %f %%", mean_error);
        end
    endtask

	task TEST_CONV_FIRST_SINGLE_IMAGE_SINGLE_CHANNEL
    (
        input integer channel
    );
        begin
                RESET;
                READ_INPUT(channel);
                DRIVE;
                convolution_enable <= 1'b0;
                repeat (20) @(posedge clk);
                $display("Channel %0d finished!", channel);
                $display("Evaluating error in processing channel %0d...", channel);
                EVAL_ERROR(cnt_output, 0.1);
        end
	endtask

    task automatic TEST_CONV_FIRST_SINGLE_IMAGE_ALL_CHANNEL;
        integer i;
        begin
            for (i = 0; i < 56; i = i + 1) begin
                RESET;
                READ_INPUT(i);
                DRIVE;
                convolution_enable <= 1'b0;
                repeat (100) @(posedge clk);
                $display("Channel %0d finished!", i);
                //PRINT_OUTPUT(cnt_output);
                EVAL_ERROR(cnt_output, 1.0);
            end
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
        //TEST_CONV_FIRST_SINGLE_IMAGE_SINGLE_CHANNEL(51);
        TEST_CONV_FIRST_SINGLE_IMAGE_ALL_CHANNEL;
        $finish;
    end

    // dump waveform
//    initial begin
//        $dumpfile("dump.vcd");
//        //$dumpvars(1, );
//    end

    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_output <= 'b0;
        end
        else if (data_out_enable) begin
            cnt_output <= cnt_output + 1;
            mem_output[cnt_output] <= data_out;
        end
    end

    // -------------------------------------------------------------------------------
    // test finish
    // -------------------------------------------------------------------------------

    // -------------------------------------------------------------------------------
    // instantiation start
    // -------------------------------------------------------------------------------

    CONV_FIRST_CALC
    #(
        .Q_INT_INPUT                            (Q_INT_INPUT                ),
        .Q_FRAC_INPUT                           (Q_FRAC_INPUT               ),
        .Q_INT_WEIGHT                           (Q_INT_WEIGHT               ),
        .Q_FRAC_WEIGHT                          (Q_FRAC_WEIGHT              ),
        .Q_INT_BIAS                             (Q_INT_BIAS                 ),
        .Q_FRAC_BIAS                            (Q_FRAC_BIAS                ),
        .Q_INT_SLOPE                            (Q_INT_SLOPE                ),
        .Q_FRAC_SLOPE                           (Q_FRAC_SLOPE               ),
        .Q_INT_INTERIM_1                        (Q_INT_INTERIM_1            ),
        .Q_FRAC_INTERIM_1                       (Q_FRAC_INTERIM_1           ),
        .Q_INT_INTERIM_2                        (Q_INT_INTERIM_2            ),
        .Q_FRAC_INTERIM_2                       (Q_FRAC_INTERIM_2           ),
        .Q_INT_OUTPUT                           (Q_INT_OUTPUT               ),
        .Q_FRAC_OUTPUT                          (Q_FRAC_OUTPUT              )
    )
    conv_first_calc_inst
    (
        .clk                                    (clk                    ),
        .rst_n                                  (rst_n                  ),

        .convolution_enable                     (convolution_enable     ),

        .data_in_0                              (data_in[0 ]            ),
        .data_in_1                              (data_in[1 ]            ),
        .data_in_2                              (data_in[2 ]            ),
        .data_in_3                              (data_in[3 ]            ),
        .data_in_4                              (data_in[4 ]            ),
        .data_in_5                              (data_in[5 ]            ),
        .data_in_6                              (data_in[6 ]            ),
        .data_in_7                              (data_in[7 ]            ),
        .data_in_8                              (data_in[8 ]            ),
        .data_in_9                              (data_in[9 ]            ),
        .data_in_10                             (data_in[10]            ),
        .data_in_11                             (data_in[11]            ),
        .data_in_12                             (data_in[12]            ),
        .data_in_13                             (data_in[13]            ),
        .data_in_14                             (data_in[14]            ),
        .data_in_15                             (data_in[15]            ),
        .data_in_16                             (data_in[16]            ),
        .data_in_17                             (data_in[17]            ),
        .data_in_18                             (data_in[18]            ),
        .data_in_19                             (data_in[19]            ),
        .data_in_20                             (data_in[20]            ),
        .data_in_21                             (data_in[21]            ),
        .data_in_22                             (data_in[22]            ),
        .data_in_23                             (data_in[23]            ),
        .data_in_24                             (data_in[24]            ),
        .data_in_25                             (data_in[25]            ),
        .data_in_26                             (data_in[26]            ),
        .data_in_27                             (data_in[27]            ),
        .data_in_28                             (data_in[28]            ),
        .data_in_29                             (data_in[29]            ),
        .data_in_30                             (data_in[30]            ),
        .data_in_31                             (data_in[31]            ),
        .data_in_32                             (data_in[32]            ),
        .data_in_33                             (data_in[33]            ),
        .data_in_34                             (data_in[34]            ),
        .data_in_35                             (data_in[35]            ),
        .data_in_36                             (data_in[36]            ),
        .data_in_37                             (data_in[37]            ),
        .data_in_38                             (data_in[38]            ),
        .data_in_39                             (data_in[39]            ),
        .data_in_40                             (data_in[40]            ),
        .data_in_41                             (data_in[41]            ),
        .data_in_42                             (data_in[42]            ),
        .data_in_43                             (data_in[43]            ),
        .data_in_44                             (data_in[44]            ),
        .data_in_45                             (data_in[45]            ),
        .data_in_46                             (data_in[46]            ),
        .data_in_47                             (data_in[47]            ),
        .data_in_48                             (data_in[48]            ),
        .data_in_49                             (data_in[49]            ),
        .data_in_50                             (data_in[50]            ),
        .data_in_51                             (data_in[51]            ),
        .data_in_52                             (data_in[52]            ),
        .data_in_53                             (data_in[53]            ),
        .data_in_54                             (data_in[54]            ),
        .data_in_55                             (data_in[55]            ),
        .data_in_56                             (data_in[56]            ),
        .data_in_57                             (data_in[57]            ),
        .data_in_58                             (data_in[58]            ),
        .data_in_59                             (data_in[59]            ),
        .data_in_60                             (data_in[60]            ),
        .data_in_61                             (data_in[61]            ),
        .data_in_62                             (data_in[62]            ),
        .data_in_63                             (data_in[63]            ),
        .data_in_64                             (data_in[64]            ),
        .data_in_65                             (data_in[65]            ),
        .data_in_66                             (data_in[66]            ),
        .data_in_67                             (data_in[67]            ),
        .data_in_68                             (data_in[68]            ),
        .data_in_69                             (data_in[69]            ),
        .data_in_70                             (data_in[70]            ),
        .data_in_71                             (data_in[71]            ),
        .data_in_72                             (data_in[72]            ),
        .data_in_73                             (data_in[73]            ),
        .data_in_74                             (data_in[74]            ),

        .weight_in_0                            (weight_in[0 ]          ),
        .weight_in_1                            (weight_in[1 ]          ),
        .weight_in_2                            (weight_in[2 ]          ),
        .weight_in_3                            (weight_in[3 ]          ),
        .weight_in_4                            (weight_in[4 ]          ),
        .weight_in_5                            (weight_in[5 ]          ),
        .weight_in_6                            (weight_in[6 ]          ),
        .weight_in_7                            (weight_in[7 ]          ),
        .weight_in_8                            (weight_in[8 ]          ),
        .weight_in_9                            (weight_in[9 ]          ),
        .weight_in_10                           (weight_in[10]          ),
        .weight_in_11                           (weight_in[11]          ),
        .weight_in_12                           (weight_in[12]          ),
        .weight_in_13                           (weight_in[13]          ),
        .weight_in_14                           (weight_in[14]          ),
        .weight_in_15                           (weight_in[15]          ),
        .weight_in_16                           (weight_in[16]          ),
        .weight_in_17                           (weight_in[17]          ),
        .weight_in_18                           (weight_in[18]          ),
        .weight_in_19                           (weight_in[19]          ),
        .weight_in_20                           (weight_in[20]          ),
        .weight_in_21                           (weight_in[21]          ),
        .weight_in_22                           (weight_in[22]          ),
        .weight_in_23                           (weight_in[23]          ),
        .weight_in_24                           (weight_in[24]          ),
        .weight_in_25                           (weight_in[25]          ),
        .weight_in_26                           (weight_in[26]          ),
        .weight_in_27                           (weight_in[27]          ),
        .weight_in_28                           (weight_in[28]          ),
        .weight_in_29                           (weight_in[29]          ),
        .weight_in_30                           (weight_in[30]          ),
        .weight_in_31                           (weight_in[31]          ),
        .weight_in_32                           (weight_in[32]          ),
        .weight_in_33                           (weight_in[33]          ),
        .weight_in_34                           (weight_in[34]          ),
        .weight_in_35                           (weight_in[35]          ),
        .weight_in_36                           (weight_in[36]          ),
        .weight_in_37                           (weight_in[37]          ),
        .weight_in_38                           (weight_in[38]          ),
        .weight_in_39                           (weight_in[39]          ),
        .weight_in_40                           (weight_in[40]          ),
        .weight_in_41                           (weight_in[41]          ),
        .weight_in_42                           (weight_in[42]          ),
        .weight_in_43                           (weight_in[43]          ),
        .weight_in_44                           (weight_in[44]          ),
        .weight_in_45                           (weight_in[45]          ),
        .weight_in_46                           (weight_in[46]          ),
        .weight_in_47                           (weight_in[47]          ),
        .weight_in_48                           (weight_in[48]          ),
        .weight_in_49                           (weight_in[49]          ),
        .weight_in_50                           (weight_in[50]          ),
        .weight_in_51                           (weight_in[51]          ),
        .weight_in_52                           (weight_in[52]          ),
        .weight_in_53                           (weight_in[53]          ),
        .weight_in_54                           (weight_in[54]          ),
        .weight_in_55                           (weight_in[55]          ),
        .weight_in_56                           (weight_in[56]          ),
        .weight_in_57                           (weight_in[57]          ),
        .weight_in_58                           (weight_in[58]          ),
        .weight_in_59                           (weight_in[59]          ),
        .weight_in_60                           (weight_in[60]          ),
        .weight_in_61                           (weight_in[61]          ),
        .weight_in_62                           (weight_in[62]          ),
        .weight_in_63                           (weight_in[63]          ),
        .weight_in_64                           (weight_in[64]          ),
        .weight_in_65                           (weight_in[65]          ),
        .weight_in_66                           (weight_in[66]          ),
        .weight_in_67                           (weight_in[67]          ),
        .weight_in_68                           (weight_in[68]          ),
        .weight_in_69                           (weight_in[69]          ),
        .weight_in_70                           (weight_in[70]          ),
        .weight_in_71                           (weight_in[71]          ),
        .weight_in_72                           (weight_in[72]          ),
        .weight_in_73                           (weight_in[73]          ),
        .weight_in_74                           (weight_in[74]          ),

        .bias_in                                (bias_in                ),
        .slope_in                               (slope_in               ),
    
        .data_out                               (data_out               ),
        .data_out_enable                        (data_out_enable        )
    );

    // -------------------------------------------------------------------------------
    // instantiation finish
    // -------------------------------------------------------------------------------

endmodule