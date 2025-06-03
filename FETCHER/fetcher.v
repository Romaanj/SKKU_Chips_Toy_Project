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
    input               rst_n           ,
    input               interrupt       ,

    output reg          enable          ,
    output [3:0]        write_enable    ,
    output reg [31:0]   address         ,
    input [31:0]        dout            ,

    output              fetcher_valid   ,

    output reg [31:0]   PARAMETER       ,
    output reg [39:0]   PIXEL_R         ,
    output reg [39:0]   PIXEL_G         ,
    output reg [39:0]   PIXEL_B//         ,

    //output reg [7:0]    test_out
);

    always @(posedge clk) begin
        if (!rst_n) begin
            enable <= 1'b0;
        end
        else if (interrupt) begin
            enable <= 1'b1;
        end
    end

    assign write_enable = 4'b0000;

    always @(posedge clk) begin
        if (!rst_n) begin
            address <= 'd0;
        end
        else if (enable) begin
            if (address == (7056 + 6162) << 2) begin
                address <= 'd0;
            end
            else begin
                address <= address + 'd4;
            end
        end
    end

    reg [31:0] address_delay_1;
    reg [31:0] address_delay_2;
    always @(posedge clk) begin
        address_delay_1 <= address;
        address_delay_2 <= address_delay_1;
    end


    reg valid_1;
    reg valid_2;
    always @(posedge clk) begin
        if (!rst_n) begin
            valid_1 <= 'b0;
            valid_2 <= 'b0;
        end
        else begin
            valid_1 <= enable;
            valid_2 <= valid_1;
        end
    end
    assign fetcher_valid = valid_2;

    // if fetcher_valid == HIGH,
    // bram32[WEIGHT_START_ADDR + parameter_idx] was read
    wire is_address_in_param_range = !is_address_in_pixel_range;

    reg [31:0] parameter_idx;
    always @(posedge clk) begin
        if (!rst_n) begin
            parameter_idx <= 'd0;
        end
        else if (is_address_in_param_range && fetcher_valid) begin
            parameter_idx <= parameter_idx + 'd1;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            PARAMETER <= 'd0;
        end
        else if (is_address_in_param_range && fetcher_valid) begin
            PARAMETER <= dout;
        end
    end

    //always @(posedge clk) begin
        //if (!rst_n) begin
            //test_out <= 'd0;
        //end
        //else if (parameter_idx == 100 && fetcher_valid) begin
            //test_out <= dout[7:0];
        //end
    //end

    // RGB RGB RGB RGB RGB -> RRRRR GGGGG BBBBB
    wire is_address_in_pixel_range = address_delay_2 <= (7055 << 2);
    reg [2:0] cnt_pixel_data_input;
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt_pixel_data_input    <= 'b0;
        end
        else if (valid_1) begin
            if (address_delay_2 == 7055 << 2) begin
                cnt_pixel_data_input <= 3'd1;
            end
            else if (cnt_pixel_data_input == 3'd5) begin
                cnt_pixel_data_input <= 3'd1;
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
        else if (cnt_pixel_data_input == 1'b1 && !flag_pixel_out) begin
            flag_pixel_out <= 1'b1;
        end
    end

    wire pixel_buffer_full = (cnt_pixel_data_input == 3'd1) && flag_pixel_out ? 1'b1 : 1'b0;

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
            pixel_buffer[cnt_pixel_data_input] <= dout;
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