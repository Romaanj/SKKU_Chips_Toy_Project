`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/06/02 20:16:27
// Design Name: 
// Module Name: fetcher
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

module FETCHER
(
    input               clk             ,
    input				clken			,
    input               rst_n           ,
    input               interrupt       ,

    output reg          enable          ,
    output [3:0]        write_enable    ,
    output reg [31:0]   address         ,
    input [31:0]        dout            ,

    output reg          clk_disable     ,

    output reg          PARAMETER_valid ,
    output reg [2:0]    PARAMETER_layer ,
    output reg [1:0]    PARAMETER_type  ,

    output reg [31:0]   PARAMETER       ,

    output reg          PIXEL_valid     ,
    output reg          PIXEL_first     ,
    output reg          PIXEL_last      ,
    output reg          PIXEL_lastline  ,

    output reg [39:0]   PIXEL_R         ,
    output reg [39:0]   PIXEL_G         ,
    output reg [39:0]   PIXEL_B

    //output reg [7:0]    test_out
);

    always @(posedge clk) begin
        if (!rst_n) begin
            enable <= 1'b0;
        end
        else if (clken && interrupt) begin
            enable <= 1'b1;
        end
    end

    assign write_enable = 4'b0000;

    always @(posedge clk) begin
        if (!rst_n) begin
            clk_disable <= 1'b0;
        end
        else if (
                        address_delay_2 == 'd32536
                    ||  address_delay_2 == 'd33232
                    ||  address_delay_2 == 'd34540
                    ||  address_delay_2 == 'd35848
                    ||  address_delay_2 == 'd37156
                    ||  address_delay_2 == 'd38476
                    ||  address_delay_2 == 'd39260
                ) begin
            clk_disable <= 1'b1;
        end
        else if (clk_disable) begin
            clk_disable <= 1'b0;
        end
    end

    reg clken_delayed_1;
    reg clken_delayed_2;
    always @(posedge clk) begin
        clken_delayed_1 <= clken;
        clken_delayed_2 <= clken_delayed_1;
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            address <= 'd0;
        end
        else if (clken) begin
            if (~enable & interrupt) begin
                address <= (7056 << 2);
            end
            else if (enable) begin
                if (address == (7056 + 1077) << 2) begin
                    address <= 'd0;
                end
                else if (address == (7055 << 2)) begin
                    address <= (7056 + 1078) << 2;
                end
                else if (address == 'd39256) begin
                    address <= 'd52868; // the last address for parameter: conv_last_bias
                end
                //else if (address == 'd52872) begin
                    //address <= 'd39264; //  the first address of conv_last_weight_0
                //end
                else begin
                    address <= address + 'd4;
                end
            end
        end
    end

    reg [31:0] address_delay_1;
    reg [31:0] address_delay_2;
    always @(posedge clk) begin
        if (clken) begin
            address_delay_1 <= address;
            address_delay_2 <= address_delay_1;
        end
    end

    reg valid_1;
    reg valid_2;
    always @(posedge clk) begin
        if (!rst_n) begin
            valid_1 <= 'b0;
            valid_2 <= 'b0;
        end
        else if (clken) begin
            valid_1 <= enable;
            valid_2 <= valid_1;
        end
    end

    // if valid_2 == HIGH,
    // bram32[WEIGHT_START_ADDR + parameter_idx] was read
    wire is_address_in_param_range = !is_address_in_pixel_range;

    //reg [31:0] parameter_idx;
    //always @(posedge clk) begin
        //if (!rst_n) begin
            //parameter_idx <= 'd0;
        //end
        //else if (is_address_in_param_range && valid_2) begin
            //parameter_idx <= parameter_idx + 'd1;
        //end
    //end

    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER <= 'd0;
        end
        else if (clken && ~clken_delayed_1) begin
            PARAMETER <= PARAMETER_buf[0];
        end
        else if (clken_delayed_1 && ~clken_delayed_2) begin
            PARAMETER <= PARAMETER_buf[1];
        end
        else if (clken && is_address_in_param_range && valid_2) begin
            PARAMETER <= dout;
        end
    end

    reg [31:0]  PARAMETER_buf [0:1];
    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER_buf[0] <= 'd0;
            PARAMETER_buf[1] <= 'd0;
        end
        else if (~clken && clken_delayed_1 && is_address_in_param_range && valid_2) begin
            PARAMETER_buf[0] <= dout;
        end
        else if (~clken_delayed_1 && clken_delayed_2 && is_address_in_param_range && valid_2) begin
            PARAMETER_buf[1] <= dout;
        end
    end


    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER_valid <= 'd0;
        end
        else if (clken) begin
            if (is_address_in_param_range && valid_2) begin
                PARAMETER_valid <= 'd1;
            end
            else if (is_address_in_pixel_range && PARAMETER_valid) begin
                PARAMETER_valid <= 'd0;
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER_layer <= 'd0; // CONV_FIRST
        end
        else if (clken) begin
            if (address_delay_2 == 'd32536) begin
                PARAMETER_layer <= 'd1; // CONV_SHRINK
            end
            else if (address_delay_2 == 'd33232) begin
                PARAMETER_layer <= 'd2; // CONV_MAPPING_0
            end
            else if (address_delay_2 == 'd34540) begin
                PARAMETER_layer <= 'd3; // CONV_MAPPING_1
            end
            else if (address_delay_2 == 'd35848) begin
                PARAMETER_layer <= 'd4; // CONV_MAPPING_2
            end
            else if (address_delay_2 == 'd37156) begin
                PARAMETER_layer <= 'd5; // CONV_MAPPING_3
            end
            else if (address_delay_2 == 'd38476) begin
                PARAMETER_layer <= 'd6; // CONV_EXPANDING
            end
            else if (address_delay_2 == 'd39260) begin
                PARAMETER_layer <= 'd7; // CONV_LAST
            end
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER_type <= 'd0; // weight
        end
        else if (clken) begin
            if  (
                        address_delay_2 == (7056 + 1049) << 2
                    ||  address_delay_2 == 'd33208
                    ||  address_delay_2 == 'd34528
                    ||  address_delay_2 == 'd35836
                    ||  address_delay_2 == 'd37144
                    ||  address_delay_2 == 'd38452
                    ||  address_delay_2 == 'd39148
                    //||  address_delay_2 == 'd39260
                ) begin
                PARAMETER_type <= 'd1; // bias
            end
            else if (
                            address_delay_2 == (7056 + 1063) << 2
                        ||  address_delay_2 == 'd33220
                        ||  address_delay_2 == 'd38464
                        ||  address_delay_2 == 'd39204
                    ) begin
                PARAMETER_type <= 'd2; // slope
            end
            else if (PARAMETER_valid & ~is_address_in_param_range) begin
                PARAMETER_type <= 'd0;
            end
            else if (
                            address_delay_2 == 'd33232
                        ||  address_delay_2 == 'd34540
                        ||  address_delay_2 == 'd35848
                        ||  address_delay_2 == 'd37156
                        ||  address_delay_2 == 'd38476
                        ||  address_delay_2 == 'd39260
                    ) begin
                PARAMETER_type <= 'd0;
            end
        end
    end

    //always @(posedge clk) begin
        //if (!rst_n) begin
            //test_out <= 'd0;
        //end
        //else if (parameter_idx == 100 && valid_2) begin
            //test_out <= dout[7:0];
        //end
    //end

    // RGB RGB RGB RGB RGB -> RRRRR GGGGG BBBBB
    wire is_address_in_pixel_range = address_delay_2 <= (7055 << 2);
    reg [6:0] cnt_pixel_data_input;
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_pixel_data_input    <= 'b0;
        end
        else if (valid_1) begin
            if (cnt_pixel_data_input == 'd84) begin
                cnt_pixel_data_input <= 'd1;
            end
            else if (is_address_in_pixel_range) begin
                cnt_pixel_data_input <= cnt_pixel_data_input + 'd1;
            end
        end
    end

    reg flag_pixel_out;
    always @(posedge clk) begin
        if (!rst_n) begin
            flag_pixel_out <= 1'b0;
        end
        else if (address_delay_2 == 'd28220) begin
            flag_pixel_out <= 1'b0;
        end
        else if ((address_delay_2 < 'd28220) && (cnt_pixel_data_input % 'd5 == 'd1 && !flag_pixel_out)) begin
            flag_pixel_out <= 1'b1;
        end
        else if (address_delay_2 == 'd32536) begin
            flag_pixel_out <= 1'b1;
        end
        else if (address_delay_2 == 'd32540) begin
            flag_pixel_out <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_valid <= 1'b0;
        end
        else if (pixel_buffer_full) begin
            PIXEL_valid <= 1'b1;
        end
        else if (PIXEL_valid) begin
            PIXEL_valid <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_first <= 1'b0;
        end
        else if (cnt_pixel_data_input == 'd6) begin
            PIXEL_first <= 1'b1;
        end
        else if (PIXEL_first) begin
            PIXEL_first <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_last <= 1'b0;
        end
        else if (flag_pixel_out && cnt_pixel_data_input == 'd1) begin
            PIXEL_last <= 1'b1;
        end
        else if (PIXEL_last) begin
            PIXEL_last <= 1'b0;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_lastline <= 1'b0;
        end
        else if (cnt_pixel_last == 'd83 && cnt_pixel_data_input == 'd6) begin
            PIXEL_lastline <= 1'b1;
        end
        else if (PIXEL_lastline) begin
            PIXEL_lastline <= 1'b0;
        end
    end

    reg [6:0] cnt_pixel_last;
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_pixel_last <= 1'b0;
        end
        else if (PIXEL_last) begin
            cnt_pixel_last <= cnt_pixel_last + 'b1;
        end
    end

    wire pixel_buffer_full = (cnt_pixel_data_input % 'd5 == 'd1) && flag_pixel_out ? 1'b1 : 1'b0;

    reg [31:0] pixel_buffer [1:5];
    always @(posedge clk) begin
        if (!rst_n) begin
            pixel_buffer[1] <= 'd0;
            pixel_buffer[2] <= 'd0;
            pixel_buffer[3] <= 'd0;
            pixel_buffer[4] <= 'd0;
            pixel_buffer[5] <= 'd0;
        end
        else if (is_address_in_pixel_range) begin
            case(cnt_pixel_data_input % 'd5)
                'd0: pixel_buffer[5] <= dout;
                'd1: pixel_buffer[1] <= dout;
                'd2: pixel_buffer[2] <= dout;
                'd3: pixel_buffer[3] <= dout;
                'd4: pixel_buffer[4] <= dout;
            endcase
        end
    end


    always @(posedge clk) begin
        if (!rst_n) begin
            PIXEL_R <= 'b0;
            PIXEL_G <= 'b0;
            PIXEL_B <= 'b0;
        end
        else if (pixel_buffer_full) begin
            PIXEL_R <=  {
                            pixel_buffer[1][31 -: 8],
                            pixel_buffer[2][31 -: 8],
                            pixel_buffer[3][31 -: 8],
                            pixel_buffer[4][31 -: 8],
                            pixel_buffer[5][31 -: 8]
                        };

            PIXEL_G <=  {
                            pixel_buffer[1][23 -: 8],
                            pixel_buffer[2][23 -: 8],
                            pixel_buffer[3][23 -: 8],
                            pixel_buffer[4][23 -: 8],
                            pixel_buffer[5][23 -: 8]
                        };

            PIXEL_B <=  {
                            pixel_buffer[1][15 -: 8],
                            pixel_buffer[2][15 -: 8],
                            pixel_buffer[3][15 -: 8],
                            pixel_buffer[4][15 -: 8],
                            pixel_buffer[5][15 -: 8]
                        };
        end
    end

endmodule