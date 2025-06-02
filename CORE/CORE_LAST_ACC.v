module CORE_LAST_ACC
#(
    parameter                                               Q_INT_INPUT     = 19                                ,
    parameter                                               Q_FRAC_INPUT    = 15                                ,
   
	parameter												Q_INT_BIAS		= 8									,
	parameter												Q_FRAC_BIAS		= 0									,

    parameter                                               Q_INT_OUTPUT    = 25                                ,
    parameter                                               Q_FRAC_OUTPUT   = 15
)
(
    input                                                   clk                                                 ,
    input                                                   rst_n                                               ,

	input [2:0]												layer_bits											,
    input                                                   last_acc_enable                                     ,
	input signed [Q_INT_BIAS + Q_FRAC_BIAS - 1:0]			bias												,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend                                              ,

    output reg                                              last_acc_result_enable                              ,
    output reg signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]  last_acc_result
);

	reg [5:0] cnt_acc;
	always @(posedge clk) begin
		if (!rst_n) begin
			cnt_acc <= 'b0;
		end
		else if (layer_bits == 3'd7 && cnt_acc == 'd55) begin
			cnt_acc <= 'b0;
		end
		else if (layer_bits == 3'd7 && last_acc_enable) begin
			cnt_acc <= cnt_acc + 'b1;
		end
	end

	wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_bias		= bias << (Q_FRAC_OUTPUT - Q_FRAC_BIAS)	;
	wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_addend	= addend								;
	wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_operand	= internal_addend - internal_bias		;

	always @(posedge clk) begin
		if (!rst_n) begin
			last_acc_result <= 'b0;
		end
		else if (layer_bits == 3'd7 && last_acc_enable) begin
			if (cnt_acc == 'b0) begin
				last_acc_result <= internal_operand										;
			end
			else if (cnt_acc == 'd55) begin
				last_acc_result <= last_acc_result + internal_operand + internal_bias	;
			end
			else begin
				last_acc_result <= last_acc_result + internal_operand					;
			end
		end
	end

	always @(posedge clk) begin
		if (!rst_n) begin
			last_acc_result_enable <= 1'b0;
		end
		else if (layer_bits == 3'd7 && cnt_acc == 'd55) begin
			last_acc_result_enable <= 1'b1;
		end
		else if (layer_bits == 3'd7 && last_acc_result_enable) begin
			last_acc_result_enable <= 1'b0;
		end
	end

endmodule