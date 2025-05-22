module CORE_LAST_ACC
#(
    parameter                                               Q_INT_INPUT     = 19                                ,
    parameter                                               Q_FRAC_INPUT    = 15                                ,

    parameter                                               Q_INT_OUTPUT    = 25                                ,
    parameter                                               Q_FRAC_OUTPUT   = 15
)
(
    input                                                   clk                                                 ,
    input                                                   rst_n                                               ,

    input                                                   last_acc_enable                                     ,
    input signed [Q_INT_INPUT + Q_FRAC_INPUT - 1:0]         addend                                              ,

    output reg                                              last_acc_result_enable                              ,
    output signed reg [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0]  last_acc_result
);

  reg [5:0] cnt_acc;
  always @(posedge clk) begin
      if (!rst_n) begin
        cnt_acc <= 'b0;
      end
      else if (cnt_acc == 'd55) begin
        cnt_acc <= 'b0;
      end
      else if (last_acc_enable) begin
        cnt_acc <= cnt_acc + 'b1;
      end
  end 

  wire signed [Q_INT_OUTPUT + Q_FRAC_OUTPUT - 1:0] internal_addend = addend;
  always @(posedge clk) begin
      if (!rst_n) begin
        last_acc_result <= 'b0;
      end
      else if (last_acc_enable) begin
        if (cnt_acc == 'b0) begin
          last_acc_result <= internal_addend;
        end
        else begin
          last_acc_result <= last_acc_result + internal_addend;
        end
      end
  end

  always @(posedge clk) begin
      if (!rst_n) begin
          last_acc_result_enable <= 1'b0;
      end
      else if (cnt_acc == 'd55) begin
          last_acc_result_enable <= 1'b1;
      end
      else if (last_acc_result_enable) begin
          last_acc_result_enable <= 1'b0;
      end
  end

endmodule