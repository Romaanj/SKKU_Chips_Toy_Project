module PADDING
#(
    parameter                                                   INPUT_DATA        = 200,
    parameter                                                   Q_INT_DATA        = 4,
    parameter                                                   Q_FRAC_DATA       = 15
)
(
    input                                                       clk                     ,
    input                                                       rst_n                   ,
    
    input                     [2:0]                             layer_bits               ,

 
    // conv_first line datas
    input signed            [INPUT_DATA - 1:0]                 raw_data_0            ,
    input signed            [INPUT_DATA - 1:0]                 raw_data_1            ,
    input signed            [INPUT_DATA - 1:0]                 raw_data_2            ,
    input signed            [INPUT_DATA - 1:0]                 raw_data_3            ,
    input signed            [INPUT_DATA - 1:0]                 raw_data_4            ,

    

    input                                             raw_data_enable_0,
    input                                             raw_data_enable_1,
    input                                             raw_data_enable_2,
    input                                             raw_data_enable_3,
    input                                             raw_data_enable_4,   
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_0 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_1 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_2 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_3 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_4 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_5 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_6 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_7 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_8 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_9 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_10 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_11 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_12 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_13 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_14 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_15 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_16 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_17 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_18 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_19 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_20 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_21 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_22 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_23 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_24 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_25 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_26 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_27 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_28 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_29 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_30 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_31 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_32 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_33 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_34 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_35 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_36 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_37 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_38 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_39 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_40 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_41 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_42 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_43 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_44 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_45 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_46 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_47 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_48 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_49 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_50 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_51 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_52 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_53 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_54 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_55 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_56 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_57 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_58 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_59 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_60 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_61 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_62 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_63 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_64 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_65 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_66 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_67 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_68 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_69 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_70 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_71 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_72 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_73 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_74 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_75 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_76 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_77 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_78 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_79 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_80 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_81 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_82 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_83 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_84 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_85 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_86 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_87 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_88 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_89 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_90 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_91 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_92 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_93 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_94 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_95 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_96 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_97 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_98 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_99 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_100 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_101 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_102 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_103 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_104 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_105 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_106 ,
    output reg signed [Q_INT_DATA + Q_FRAC_DATA -1:0] pad_data_out_107,

    output reg                                   pad_data_out_enable
              
);

/////////////////////////////////////////////////

 // location variable in 1-dimension, total 7056(84 * 84)

/////////////////////////////////////////////////
//kernel moves from left to right
reg signed [12:0] kernel_loc;              //kernel_loc values are regarded as 1st_dimension values

reg signed [INPUT_DATA-1:0] line_data_0;
reg signed [INPUT_DATA-1:0] line_data_1;
reg signed [INPUT_DATA-1:0] line_data_2;
reg signed [INPUT_DATA-1:0] line_data_3;
reg signed [INPUT_DATA-1:0] line_data_4;

////////////////////////////////// kernel is approaching starting from the outside of the image
always @(posedge clk) begin
  if(!rst_n) begin
    pad_data_out_enable <= 'b0;
  end
  else if(kernel_loc % 86 > 1 && layer_bits == 3'd0) begin
    pad_data_out_enable <= 'b1;
  end
  else if(kernel_loc % 85 > 0 && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
    pad_data_out_enable <= 'b1;
  end
  else if (kernel_loc % 87 > 3 && laye_bits == 3'd7) begin
    pad_data_out_enable <= 'b1;
  end

end

////////////////////////// activates padding when datas are inserted
always @(posedge clk) begin
  if(!rst_n) begin
    padding_enable <= 'b0;
  end
  else if(raw_data_enable_0 || raw_data_enable_1 || raw_data_enable_2 || raw_data_enable_3 || raw_data_enable_4) begin
    padding_enable <= 'b1;
  end
end


////////////////////////// controlling kernel movements
always @(posedge clk) begin
  if(!rst_n) begin
      kernel_loc <= 'b0;
  end
  else if(kernel_loc == 'd7223 && layer_bits == 3'd0) begin
    kernel_loc <= 'b0 ;
    padding_enable <= 'b0;
  end
  else if(kernel_loc == 'd7139 && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5) ) begin
    kernel_loc <= 'b0 ;
    padding_enable <= 'b0;
  end
  else if(kernel_loc == 'd7727 && layer_bits = 3'd7) begin
      kernel_loc <= 'b0 ;   
      padding_enable <= 'b0;
  end
  else if(padding_enable) begin
    kernel_loc <= kernel_loc + 'b1  ;
  end
end

////////////////////////// connecting raw_data
always @(posedge clk) begin
  if (!rst_n) begin
    line_data_0 <= 'b0;
    line_data_1 <= 'b0;
    line_data_2 <= 'b0;
    line_data_3 <= 'b0;
    line_data_4 <= 'b0;
  end
  else begin
    if (raw_data_enable_0)
      line_data_0 <= raw_data_0;
    else if (padding_enable)
      line_data_0 <= line_data_0 << 8;

    if (raw_data_enable_1)
      line_data_1 <= raw_data_1;
    else if (padding_enable)
      line_data_1 <= line_data_1 << 8;

    if (raw_data_enable_2)
      line_data_2 <= raw_data_2;
    else if (padding_enable)
      line_data_2 <= line_data_2 << 8;

    if (raw_data_enable_3)
      line_data_3 <= raw_data_3;
    else if (padding_enable)
      line_data_3 <= line_data_3 << 8;

    if (raw_data_enable_4)
      line_data_4 <= raw_data_4;
    else if (padding_enable)
      line_data_4 <= line_data_4 << 8;
  end
end

////////////////////////////////////////////////////
//conv_first//
always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_75 <= 'b0;
    pad_data_out_76 <= 'b0;
    pad_data_out_77 <= 'b0;
    pad_data_out_78 <= 'b0;
    pad_data_out_79 <= 'b0;
    pad_data_out_80 <= 'b0;
    pad_data_out_81 <= 'b0;
    pad_data_out_82 <= 'b0;
    pad_data_out_83 <= 'b0;
    pad_data_out_84 <= 'b0;
    pad_data_out_85 <= 'b0;
    pad_data_out_86 <= 'b0;
    pad_data_out_87 <= 'b0;
    pad_data_out_88 <= 'b0;
    pad_data_out_89 <= 'b0;
    pad_data_out_90 <= 'b0;
    pad_data_out_91 <= 'b0;
    pad_data_out_92 <= 'b0;
    pad_data_out_93 <= 'b0;
    pad_data_out_94 <= 'b0;
    pad_data_out_95 <= 'b0;
    pad_data_out_96 <= 'b0;
    pad_data_out_97 <= 'b0;
    pad_data_out_98 <= 'b0;
    pad_data_out_99 <= 'b0;
    pad_data_out_100 <= 'b0;
    pad_data_out_101 <= 'b0;
    pad_data_out_102 <= 'b0;
    pad_data_out_103 <= 'b0;
    pad_data_out_104 <= 'b0;
    pad_data_out_105 <= 'b0;
    pad_data_out_106 <= 'b0;
    pad_data_out_107 <= 'b0;
  end
end



////////////////////////////////////// row0


always @(posedge clk) begin
  if (!rst_n) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_50 <= 'b0;
  end
  else if (padding_enable && layer_bits == 3'd0) begin
    if (kernel_loc < 172) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_50 <= 'b0;
    end
    else if (kernel_loc % 86 < 4) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_50 <= 'b0;
    end
    else begin
      pad_data_out_0 <= pad_data_out_1 ;
      pad_data_out_25 <= pad_data_out_26 ;
      pad_data_out_50 <= pad_data_out_51 ;
    end
end      
end


always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_1 <= 'b0;
    pad_data_out_26 <= 'b0;
    pad_data_out_51 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 172) begin
        pad_data_out_1 <= 'b0;
        pad_data_out_26 <= 'b0;
        pad_data_out_51 <= 'b0;
    end
    else if (kernel_loc % 86 < 3) begin
        pad_data_out_1 <= 'b0;
        pad_data_out_26 <= 'b0;
        pad_data_out_51 <= 'b0;
    end
    else begin
      pad_data_out_1  <= pad_data_out_2;
      pad_data_out_26 <= pad_data_out_27;
      pad_data_out_51 <= pad_data_out_52;
    end
  end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_2 <= 'b0;
    pad_data_out_27 <= 'b0;
    pad_data_out_52 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 172) begin
      pad_data_out_2 <= 'b0;
      pad_data_out_27 <= 'b0;
      pad_data_out_52 <= 'b0;
    end
    else if(kernel_loc % 86 < 2) begin 
      pad_data_out_2 <= 'b0;
      pad_data_out_27 <= 'b0;
      pad_data_out_52 <= 'b0;
    end
    else begin
      pad_data_out_2 <= pad_data_out_3;
      pad_data_out_27 <= pad_data_out_28;
      pad_data_out_52 <= pad_data_out_53;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_3 <= 'b0;
    pad_data_out_28 <= 'b0;
    pad_data_out_53 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 172) begin
        pad_data_out_3 <= 'b0;
        pad_data_out_28 <= 'b0;
        pad_data_out_53 <= 'b0;
    end
    else if(kernel_loc % 86 == 0 || kernel_loc % 86 == 85) begin
        pad_data_out_3 <= 'b0;
        pad_data_out_28 <= 'b0;
        pad_data_out_53 <= 'b0;
    end
    else begin
        pad_data_out_3 <= pad_data_out_4;
        pad_data_out_28 <= pad_data_out_29;
        pad_data_out_53 <= pad_data_out_54;
    end
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_4 <= 'b0;
    pad_data_out_29 <= 'b0;
    pad_data_out_54 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 172) begin
      pad_data_out_4 <= 'b0;
      pad_data_out_29 <= 'b0;
      pad_data_out_54 <= 'b0;
    end
    else if(kernel_loc % 86 == 84 && kernel_loc % 86 == 85) begin
      pad_data_out_4 <= 'b0;
      pad_data_out_29 <= 'b0;
      pad_data_out_54 <= 'b0;
    end
    else begin
        pad_data_out_4 <= line_data_0[119:112] << 8;
        pad_data_out_29 <= line_data_0[79:72] << 8;
        pad_data_out_54 <= line_data_0[39:32] << 8;
    end
end
end
/////////////////////////////////////////////////////////////////////////// row1
always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_5 <= 'b0;
    pad_data_out_30 <= 'b0;
    pad_data_out_55 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 86) begin
        pad_data_out_5 <= 'b0;
        pad_data_out_30 <= 'b0;
        pad_data_out_55 <= 'b0;
    end
    else if (kernel_loc % 86 < 4) begin
      pad_data_out_5 <= 'b0;
      pad_data_out_30 <= 'b0;
      pad_data_out_55 <= 'b0;
    end
    else begin
      pad_data_out_5 <= pad_data_out_6;
      pad_data_out_30 <= pad_data_out_31;
      pad_data_out_55 <= pad_data_out_56;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_6 <= 'b0;
    pad_data_out_31 <= 'b0; 
    pad_data_out_56 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 86) begin
        pad_data_out_6 <= 'b0;
        pad_data_out_31 <= 'b0;
        pad_data_out_56 <= 'b0;
    end
    else if (kernel_loc % 86 < 3) begin
        pad_data_out_6 <= 'b0;
        pad_data_out_31 <= 'b0;
        pad_data_out_56 <= 'b0; 
    end
    else begin
      pad_data_out_6 <= pad_data_out_7;
      pad_data_out_31 <= pad_data_out_32;
      pad_data_out_56 <= pad_data_out_57;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_7 <= 'b0;
    pad_data_out_32 <= 'b0;
    pad_data_out_57 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 86) begin
        pad_data_out_7 <= 'b0;
        pad_data_out_32 <= 'b0;
        pad_data_out_57 <= 'b0;
    end
    else if(kernel_loc % 86 < 2) begin
        pad_data_out_7 <= 'b0;
        pad_data_out_32 <= 'b0;
        pad_data_out_57 <= 'b0;
    end
    else begin
        pad_data_out_7 <= pad_data_out_8;
        pad_data_out_32 <= pad_data_out_33;
        pad_data_out_57 <= pad_data_out_58;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_8 <= 'b0;
    pad_data_out_33 <= 'b0;
    pad_data_out_58 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 86) begin
      pad_data_out_8 <= 'b0;
      pad_data_out_33 <= 'b0;
      pad_data_out_58 <= 'b0;
    end
    else if(kernel_loc % 86 == 0 || kernel_loc % 86 == 85) begin
        pad_data_out_8 <= 'b0;
        pad_data_out_33 <= 'b0;
        pad_data_out_58 <= 'b0;
    end
    else begin
        pad_data_out_8 <= pad_data_out_9;
        pad_data_out_33 <= pad_data_out_34;
        pad_data_out_58 <= pad_data_out_59;
    end
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_9 <= 'b0;
    pad_data_out_34 <= 'b0;
    pad_data_out_59 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc < 86) begin
        pad_data_out_9 <= 'b0;
        pad_data_out_34 <= 'b0;
        pad_data_out_59 <= 'b0;
    end
    else if(kernel_loc % 86 == 84 || kernel_loc % 86 == 85) begin
        pad_data_out_9 <= 'b0;
        pad_data_out_34 <= 'b0;
        pad_data_out_59 <= 'b0;
    end
    else if(kernel_loc < 168) begin
        pad_data_out_9 <= line_data_0[119:112] << 8;
        pad_data_out_3 <= line_data_0[79:72] << 8;
        pad_data_out_58 <= line_data_0[39:32] << 8;
    end
    else begin
        pad_data_out_9 <= line_data_1[119:112] << 8;
        pad_data_out_34 <= line_data_1[79:72] << 8;
        pad_data_out_59 <= line_data_1[39:32] << 8;

end
end
end
////////////////////////////////// row2
always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_10 <= 'b0;
    pad_data_out_35 <= 'b0;
    pad_data_out_60 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc % 86 < 4) begin
        pad_data_out_10 <= 'b0;
        pad_data_out_35 <= 'b0;
        pad_data_out_60 <= 'b0;
    end
    else begin
      pad_data_out_10 <= pad_data_out_11;
      pad_data_out_35 <= pad_data_out_36;
      pad_data_out_60 <= pad_data_out_61;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_11 <= 'b0;
    pad_data_out_36 <= 'b0;
    pad_data_out_61 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc % 86 < 3 ) begin
      pad_data_out_11 <= 'b0;
      pad_data_out_36 <= 'b0;
      pad_data_out_61 <= 'b0;
    end
    else begin
      pad_data_out_11 <= pad_data_out_12;
      pad_data_out_36 <= pad_data_out_37;
      pad_data_out_61 <= pad_data_out_62;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_12 <= 'b0;
    pad_data_out_37 <= 'b0;
    pad_data_out_62 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc % 86 < 2 ) begin
      pad_data_out_12 <= 'b0;
      pad_data_out_37 <= 'b0;
      pad_data_out_62 <= 'b0;
    end
    else begin
      pad_data_out_12 <= pad_data_out_13;
      pad_data_out_37 <= pad_data_out_38;
      pad_data_out_62 <= pad_data_out_63;
    end
    
end
end


always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_13 <= 'b0;
    pad_data_out_38 <= 'b0;
    pad_data_out_63 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc % 86 == 0 || kernel_loc % 86 == 85) begin
        pad_data_out_13 <= 'b0;
        pad_data_out_38 <= 'b0;
        pad_data_out_63 <= 'b0;
    end
    else begin
      pad_data_out_13 <= pad_data_out_14;
      pad_data_out_38 <= pad_data_out_39;
      pad_data_out_63 <= pad_data_out_64;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_14 <= 'b0;
    pad_data_out_39 <= 'b0;
    pad_data_out_64 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if(kernel_loc % 86 == 84 || kernel_loc % 86 == 85) begin
          pad_data_out_14 <= 'b0;
          pad_data_out_39 <= 'b0;
          pad_data_out_64 <= 'b0;
    end
    else if (kernel_loc < 86) begin
      pad_data_out_14 <= line_data_0[119:112] << 8 ;
      pad_data_out_39 <= line_data_0[79:72] << 8;
      pad_data_out_64 <= line_data_0[39:32] << 8;
    end
    else if(kernel_loc < 172) begin
      pad_data_out_14 <= line_data_1[119:112] << 8;
      pad_data_out_39 <= line_data_1[79:72] << 8;
      pad_data_out_64 <= line_data_1[39:32] << 8;
    end
    else begin
      pad_data_out_14 <= line_data_2[119:112] << 8;
      pad_data_out_39 <= line_data_2[79:72] << 8;
      pad_data_out_64 <= line_data_2[39:32] << 8;
    end
    
end
end

//////////////////////////////////// row 3
always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_15 <= 'b0;
    pad_data_out_40 <= 'b0;
    pad_data_out_65 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7137) begin
        pad_data_out_15 <= 'b0;
        pad_data_out_40 <= 'b0;
        pad_data_out_65 <= 'b0;
    end
    else if (kernel_loc % 86 < 4 ) begin
        pad_data_out_15 <= 'b0;
        pad_data_out_40 <= 'b0;
        pad_data_out_65 <= 'b0;
    end
    else begin
      pad_data_out_15 <= pad_data_out_16;
      pad_data_out_40 <= pad_data_out_41;
      pad_data_out_65 <= pad_data_out_66;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_16 <= 'b0;
    pad_data_out_41 <= 'b0;
    pad_data_out_66 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7137) begin
        pad_data_out_16 <= 'b0;
        pad_data_out_41 <= 'b0;
        pad_data_out_66 <= 'b0;
    end
    else if ( kernel_loc % 86 < 3) begin
        pad_data_out_16 <= 'b0;
        pad_data_out_41 <= 'b0;
        pad_data_out_66 <= 'b0;
    end
    else begin
        pad_data_out_16 <= pad_data_out_17;
        pad_data_out_41 <= pad_data_out_42;
        pad_data_out_66 <= pad_data_out_67;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_17 <= 'b0;
    pad_data_out_42 <= 'b0;
    pad_data_out_67 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7137) begin
        pad_data_out_17 <= 'b0;
        pad_data_out_42 <= 'b0;
        pad_data_out_67 <= 'b0;
    end
    else if (kernel_loc % 86 < 2) begin
        pad_data_out_17 <= line_data_3[119:72];
        pad_data_out_42 <= line_data_3[79:72];
        pad_data_out_67 <= line_data_3[39:32];
    end
    else begin
        pad_data_out_17 <= pad_data_out_18;
        pad_data_out_42 <= pad_data_out_43;
        pad_data_out_67 <= pad_data_out_68;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_18 <= 'b0;
    pad_data_out_43 <= 'b0;
    pad_data_out_68 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7137) begin
        pad_data_out_18 <= 'b0;
        pad_data_out_43 <= 'b0;
        pad_data_out_68 <= 'b0;
    end
    else if (kernel_loc % 86 == 0 || kernel_loc % 86 == 85 ) begin
        pad_data_out_18 <= 'b0;
        pad_data_out_43 <= 'b0;
        pad_data_out_68 <= 'b0;
    end
    else begin
        pad_data_out_18 <= pad_data_out_19;
        pad_data_out_43 <= pad_data_out_44;
        pad_data_out_68 <= pad_data_out_69;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_19 <= 'b0;
    pad_data_out_44 <= 'b0;
    pad_data_out_69 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7137) begin
          pad_data_out_19 <= 'b0;
          pad_data_out_44 <= 'b0;
          pad_data_out_69 <= 'b0;
    end
    else if (kernel_loc % 86 == 84 || kernel_loc % 86 == 85 ) begin
        pad_data_out_19 <= 'b0;
        pad_data_out_44 <= 'b0;
        pad_data_out_69 <= 'b0;
    end
    else if (kernel_loc < 86) begin
        pad_data_out_19 <= line_data_1[119:112] << 8;
        pad_data_out_44 <= line_data_1[79:72] << 8;
        pad_data_out_69 <= line_data_1[39:32] << 8;
    end
    else if (kernel_loc < 172 ) begin
        pad_data_out_19 <= line_data_2[119:112] << 8;
        pad_data_out_44 <= line_data_2[79:72] << 8;
        pad_data_out_69 <= line_data_2[39:32] << 8;
    end
    else begin
        pad_data_out_19 <= line_data_3[119:112] << 8;
        pad_data_out_44 <= line_data_3[79:72] << 8;
        pad_data_out_69 <= line_data_3[39:32] << 8;
    end
    
end
end

/////////////////////////////////////////// row_4
always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_20 <= 'b0;
    pad_data_out_45 <= 'b0;
    pad_data_out_70 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7051) begin
        pad_data_out_20 <= 'b0;
        pad_data_out_45 <= 'b0;
        pad_data_out_70 <= 'b0;
    end
    else if (kernel_loc % 86 < 4 ) begin
        pad_data_out_20 <= 'b0;
        pad_data_out_45 <= 'b0;
        pad_data_out_70 <= 'b0;
    end
    else begin
      pad_data_out_20 <= pad_data_out_21;
      pad_data_out_45 <= pad_data_out_46;
      pad_data_out_70 <= pad_data_out_71;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_21 <= 'b0;
    pad_data_out_46 <= 'b0;
    pad_data_out_71 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7051) begin
      pad_data_out_21 <= 'b0;
      pad_data_out_46 <= 'b0;
      pad_data_out_71 <= 'b0;
    end
    else if ( kernel_loc % 86 < 3 ) begin
      pad_data_out_21 <= 'b0;
      pad_data_out_46 <= 'b0;
      pad_data_out_71 <= 'b0;
    end
    else begin
        pad_data_out_21 <= pad_data_out_22;
        pad_data_out_46 <= pad_data_out_47;
        pad_data_out_71 <= pad_data_out_72;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_22 <= 'b0;
    pad_data_out_47 <= 'b0;
    pad_data_out_72 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7051) begin
      pad_data_out_22 <= 'b0;
      pad_data_out_47 <= 'b0;
      pad_data_out_72 <= 'b0;
    end
    else if (kernel_loc % 86 < 2) begin
      pad_data_out_22 <= 'b0;
      pad_data_out_47 <= 'b0;
      pad_data_out_72 <= 'b0;
    end
    else begin
        pad_data_out_22 <= pad_data_out_23;
        pad_data_out_47 <= pad_data_out_48;
        pad_data_out_72 <= pad_data_out_73;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_23 <= 'b0;
    pad_data_out_48 <= 'b0;
    pad_data_out_73 <= 'b0;
  end
  else if (padding_enable & layer_bits == 3'd0) begin
    if (kernel_loc > 7051) begin
      pad_data_out_23 <= 'b0;
      pad_data_out_48 <= 'b0;
      pad_data_out_73 <= 'b0;
    end
    else if (kernel_loc % 86 == 0 || kernel_loc % 86 == 85) begin
      pad_data_out_23 <= 'b0;
      pad_data_out_48 <= 'b0;
      pad_data_out_73 <= 'b0;
    end
    else begin
        pad_data_out_23 <= pad_data_out_24;
        pad_data_out_48 <= pad_data_out_49;
        pad_data_out_73 <= pad_data_out_74;
    end
    
end
end

always @(posedge clk) begin
  if (!rst_n) begin
    pad_data_out_24 <= 'b0;
    pad_data_out_49 <= 'b0;
    pad_data_out_74 <= 'b0;
  end
  else if (padding_enable && layer_bits == 3'd0) begin
    if (kernel_loc > 7051) begin
      pad_data_out_24 <= 'b0;
      pad_data_out_49 <= 'b0;
      pad_data_out_74 <= 'b0;
    end
    else if(kernel_loc < 84) begin
      pad_data_out_24 <= line_data_2[119:112] << 8;
      pad_data_out_49 <= line_data_2[79:72] << 8;
      pad_data_out_74 <= line_data_2[39:32] << 8;
    end
    else if(kernel_loc < 168) begin
      pad_data_out_24 <= line_data_3[119:112] << 8;
      pad_data_out_49 <= line_data_3[79:72] << 8;
      pad_data_out_74 <= line_data_3[39:32] << 8;
    end
    else begin
        pad_data_out_24 <= line_data_4[119:112] << 8;
        pad_data_out_49 <= line_data_4[79:72] << 8;
        pad_data_out_74 <= line_data_4[39:32] << 8;
    end
    
end
end


/////////////////////////////////conv_map///////

///////////////////////////////////////// row_0
always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_0 <= 'b0;
   pad_data_out_9 <= 'b0;
   pad_data_out_18 <= 'b0;
   pad_data_out_27 <= 'b0;
   pad_data_out_36 <= 'b0;
   pad_data_out_45 <= 'b0;
   pad_data_out_54 <= 'b0;
   pad_data_out_63 <= 'b0;
   pad_data_out_72 <= 'b0;
   pad_data_out_81 <= 'b0;
   pad_data_out_90 <= 'b0;
   pad_data_out_99 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc < 85) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_9 <= 'b0;
      pad_data_out_18 <= 'b0;
      pad_data_out_27 <= 'b0;
      pad_data_out_36 <= 'b0;
      pad_data_out_45 <= 'b0;
      pad_data_out_54 <= 'b0;
      pad_data_out_63 <= 'b0;
      pad_data_out_72 <= 'b0;
      pad_data_out_81 <= 'b0;
      pad_data_out_90 <= 'b0;
      pad_data_out_99 <= 'b0;
   end
   else if(kernel_loc % 85 == 0 || kernel_loc % 85 == 1) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_9 <= 'b0;
      pad_data_out_18 <= 'b0;
      pad_data_out_27 <= 'b0;
      pad_data_out_36 <= 'b0;
      pad_data_out_45 <= 'b0;
      pad_data_out_54 <= 'b0;
      pad_data_out_63 <= 'b0;
      pad_data_out_72 <= 'b0;
      pad_data_out_81 <= 'b0;
      pad_data_out_90 <= 'b0;
      pad_data_out_99 <= 'b0;
   end
   else begin
       pad_data_out_0 <= pad_data_out_1;
       pad_data_out_9 <= pad_data_out_10;
       pad_data_out_18 <= pad_data_out_19;
       pad_data_out_27 <= pad_data_out_28;
       pad_data_out_36 <= pad_data_out_37;
       pad_data_out_45 <= pad_data_out_46;
       pad_data_out_54 <= pad_data_out_55;
       pad_data_out_63 <= pad_data_out_64;
       pad_data_out_72 <= pad_data_out_73;
       pad_data_out_81 <= pad_data_out_82;
       pad_data_out_90 <= pad_data_out_91;
       pad_data_out_99 <= pad_data_out_100;
   end
 end
end

always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_1 <= 'b0;
   pad_data_out_10 <= 'b0;
   pad_data_out_19 <= 'b0;
   pad_data_out_28 <= 'b0;
   pad_data_out_37 <= 'b0;
   pad_data_out_46 <= 'b0;
   pad_data_out_55 <= 'b0;
   pad_data_out_64 <= 'b0;
   pad_data_out_73 <= 'b0;
   pad_data_out_82 <= 'b0;
   pad_data_out_91 <= 'b0;
   pad_data_out_100 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc < 85) begin
      pad_data_out_1 <= 'b0;
      pad_data_out_10 <= 'b0;
      pad_data_out_19 <= 'b0;
      pad_data_out_28 <= 'b0;
      pad_data_out_37 <= 'b0;
      pad_data_out_46 <= 'b0;
      pad_data_out_55 <= 'b0;
      pad_data_out_64 <= 'b0;
      pad_data_out_73 <= 'b0;
      pad_data_out_82 <= 'b0;
      pad_data_out_91 <= 'b0;
      pad_data_out_100 <= 'b0;
   end
   else if(kernel_loc % 84 == 0) begin
      pad_data_out_1 <= 'b0;
      pad_data_out_10 <= 'b0;
      pad_data_out_19 <= 'b0;
      pad_data_out_28 <= 'b0;
      pad_data_out_37 <= 'b0;
      pad_data_out_46 <= 'b0;
      pad_data_out_55 <= 'b0;
      pad_data_out_64 <= 'b0;
      pad_data_out_73 <= 'b0;
      pad_data_out_82 <= 'b0;
      pad_data_out_91 <= 'b0;
      pad_data_out_100 <= 'b0;
   end
   else begin
       pad_data_out_1 <= pad_data_out_2;
       pad_data_out_10 <= pad_data_out_11;
       pad_data_out_19 <= pad_data_out_20;
       pad_data_out_28 <= pad_data_out_29;
       pad_data_out_37 <= pad_data_out_38;
       pad_data_out_46 <= pad_data_out_47;
       pad_data_out_55 <= pad_data_out_56;
       pad_data_out_64 <= pad_data_out_65;
       pad_data_out_73 <= pad_data_out_74;
       pad_data_out_82 <= pad_data_out_83;
       pad_data_out_91 <= pad_data_out_92;
       pad_data_out_100 <= pad_data_out_101;
 end
end
end

always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_2 <= 'b0;
   pad_data_out_11 <= 'b0;
   pad_data_out_20 <= 'b0;
   pad_data_out_29 <= 'b0;
   pad_data_out_38 <= 'b0;
   pad_data_out_47 <= 'b0;
   pad_data_out_56 <= 'b0;
   pad_data_out_65 <= 'b0;
   pad_data_out_74 <= 'b0;
   pad_data_out_83 <= 'b0;
   pad_data_out_92 <= 'b0;
   pad_data_out_101 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc < 85) begin
      pad_data_out_2 <= 'b0;
      pad_data_out_11 <= 'b0;
      pad_data_out_20 <= 'b0;
      pad_data_out_29 <= 'b0;
      pad_data_out_38 <= 'b0;
      pad_data_out_47 <= 'b0;
      pad_data_out_56 <= 'b0;
      pad_data_out_65 <= 'b0;
      pad_data_out_74 <= 'b0;
      pad_data_out_83 <= 'b0;
      pad_data_out_92 <= 'b0;
      pad_data_out_101 <= 'b0;
   end
   else if(kernel_loc % 85 == 84) begin
      pad_data_out_2 <= 'b0;
      pad_data_out_11 <= 'b0;
      pad_data_out_20 <= 'b0;
      pad_data_out_29 <= 'b0;
      pad_data_out_38 <= 'b0;
      pad_data_out_47 <= 'b0;
      pad_data_out_56 <= 'b0;
      pad_data_out_65 <= 'b0;
      pad_data_out_74 <= 'b0;
      pad_data_out_83 <= 'b0;
      pad_data_out_92 <= 'b0;
      pad_data_out_101 <= 'b0;
   end
   else begin
       pad_data_out_2 <= 
       pad_data_out_11 <= 
       pad_data_out_20 <= 
       pad_data_out_29 <= 
       pad_data_out_38 <= 
       pad_data_out_47 <= 
       pad_data_out_56 <= 
       pad_data_out_65 <= 
       pad_data_out_74 <= 
       pad_data_out_83 <= 
       pad_data_out_92 <= 
       pad_data_out_101 <= 
   end
 end
end

/////////////////////////////////////////////// row_1
always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_3 <= 'b0;
   pad_data_out_12 <= 'b0;
   pad_data_out_21 <= 'b0;
   pad_data_out_30 <= 'b0;
   pad_data_out_39 <= 'b0;
   pad_data_out_48 <= 'b0;
   pad_data_out_57 <= 'b0;
   pad_data_out_66 <= 'b0;
   pad_data_out_75 <= 'b0;
   pad_data_out_84 <= 'b0;
   pad_data_out_93 <= 'b0;
   pad_data_out_102 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc % 85 == 0 || kernel_loc % 85 == 1) begin
      pad_data_out_3 <= 'b0;
      pad_data_out_12 <= 'b0;
      pad_data_out_21 <= 'b0;
      pad_data_out_30 <= 'b0;
      pad_data_out_39 <= 'b0;
      pad_data_out_48 <= 'b0;
      pad_data_out_57 <= 'b0;
      pad_data_out_66 <= 'b0;
      pad_data_out_75 <= 'b0;
      pad_data_out_84 <= 'b0;
      pad_data_out_93 <= 'b0;
      pad_data_out_102 <= 'b0;
   end
   else begin
       pad_data_out_3 <= pad_data_out_4;
       pad_data_out_12 <= pad_data_out_13;
       pad_data_out_21 <= pad_data_out_22;
       pad_data_out_30 <= pad_data_out_31;
       pad_data_out_39 <= pad_data_out_40;
       pad_data_out_48 <= pad_data_out_49;
       pad_data_out_57 <= pad_data_out_58;
       pad_data_out_66 <= pad_data_out_67;
       pad_data_out_75 <= pad_data_out_76;
       pad_data_out_84 <= pad_data_out_85;
       pad_data_out_93 <= pad_data_out_94;
       pad_data_out_102 <= pad_data_out_103;
   end
 end
end

always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_4 <= 'b0;
   pad_data_out_13 <= 'b0;
   pad_data_out_22 <= 'b0;
   pad_data_out_31 <= 'b0;
   pad_data_out_40 <= 'b0;
   pad_data_out_49 <= 'b0;
   pad_data_out_58 <= 'b0;
   pad_data_out_67 <= 'b0;
   pad_data_out_76 <= 'b0;
   pad_data_out_85 <= 'b0;
   pad_data_out_94 <= 'b0;
   pad_data_out_103 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc % 85 == 0) begin
      pad_data_out_4 <= 'b0;
      pad_data_out_13 <= 'b0;
      pad_data_out_22 <= 'b0;
      pad_data_out_31 <= 'b0;
      pad_data_out_40 <= 'b0;
      pad_data_out_49 <= 'b0;
      pad_data_out_58 <= 'b0;
      pad_data_out_67 <= 'b0;
      pad_data_out_76 <= 'b0;
      pad_data_out_85 <= 'b0;
      pad_data_out_94 <= 'b0;
      pad_data_out_103 <= 'b0;
 end
   end
   else begin
     pad_data_out_4 <= pad_data_out_5;
     pad_data_out_13 <= pad_data_out_14;
     pad_data_out_22 <= pad_data_out_23;
     pad_data_out_31 <= pad_data_out_32;
     pad_data_out_40 <= pad_data_out_41;
     pad_data_out_49 <= pad_data_out_50;
     pad_data_out_58 <= pad_data_out_59;
     pad_data_out_67 <= pad_data_out_68;
     pad_data_out_76 <= pad_data_out_77;
     pad_data_out_85 <= pad_data_out_86;
     pad_data_out_94 <= pad_data_out_95;
     pad_data_out_103 <= pad_data_out_104;
   end
end



always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_5 <= 'b0;
   pad_data_out_14 <= 'b0;
   pad_data_out_23 <= 'b0;
   pad_data_out_32 <= 'b0;
   pad_data_out_41 <= 'b0;
   pad_data_out_50 <= 'b0;
   pad_data_out_59 <= 'b0;
   pad_data_out_68 <= 'b0;
   pad_data_out_77 <= 'b0;
   pad_data_out_86 <= 'b0;
   pad_data_out_95 <= 'b0;
   pad_data_out_104 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc % 85 == 84) begin
      pad_data_out_5 <= 'b0;
      pad_data_out_14 <= 'b0;
      pad_data_out_23 <= 'b0;
      pad_data_out_32 <= 'b0;
      pad_data_out_41 <= 'b0;
      pad_data_out_50 <= 'b0;
      pad_data_out_59 <= 'b0;
      pad_data_out_68 <= 'b0;
      pad_data_out_77 <= 'b0;
      pad_data_out_86 <= 'b0;
      pad_data_out_95 <= 'b0;
      pad_data_out_104 <= 'b0;
   end
   else begin
       pad_data_out_5 <= 
       pad_data_out_14 <= 
       pad_data_out_23 <= 
       pad_data_out_32 <= 
       pad_data_out_41 <= 
       pad_data_out_50 <= 
       pad_data_out_59 <= 
       pad_data_out_68 <= 
       pad_data_out_77 <= 
       pad_data_out_86 <= 
       pad_data_out_95 <= 
       pad_data_out_104 <= 
   end
 end
end

//////////////////////////////////////////////////////////////// row_2
always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_6 <= 'b0;
   pad_data_out_15 <= 'b0;
   pad_data_out_24 <= 'b0;
   pad_data_out_33 <= 'b0;
   pad_data_out_42 <= 'b0;
   pad_data_out_51 <= 'b0;
   pad_data_out_60 <= 'b0;
   pad_data_out_69 <= 'b0;
   pad_data_out_78 <= 'b0;
   pad_data_out_87 <= 'b0;
   pad_data_out_96 <= 'b0;
   pad_data_out_105 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc > 7054) begin
      pad_data_out_6 <= 'b0;
      pad_data_out_15 <= 'b0;
      pad_data_out_24 <= 'b0;
      pad_data_out_33 <= 'b0;
      pad_data_out_42 <= 'b0;
      pad_data_out_51 <= 'b0;
      pad_data_out_60 <= 'b0;
      pad_data_out_69 <= 'b0;
      pad_data_out_78 <= 'b0;
      pad_data_out_87 <= 'b0;
      pad_data_out_96 <= 'b0;
      pad_data_out_105 <= 'b0;
   end
   else if(kernel_loc % 85 == 0 || kernel_loc % 85 == 1) begin
      pad_data_out_6 <= 'b0;
      pad_data_out_15 <= 'b0;
      pad_data_out_24 <= 'b0;
      pad_data_out_33 <= 'b0;
      pad_data_out_42 <= 'b0;
      pad_data_out_51 <= 'b0;
      pad_data_out_60 <= 'b0;
      pad_data_out_69 <= 'b0;
      pad_data_out_78 <= 'b0;
      pad_data_out_87 <= 'b0;
      pad_data_out_96 <= 'b0;
      pad_data_out_105 <= 'b0;
   end
   else begin
       pad_data_out_6 <= pad_data_out_7;
       pad_data_out_15 <= pad_data_out_16;
       pad_data_out_24 <= pad_data_out_25;
       pad_data_out_33 <= pad_data_out_34;
       pad_data_out_42 <= pad_data_out_43;
       pad_data_out_51 <= pad_data_out_52;
       pad_data_out_60 <= pad_data_out_61;
       pad_data_out_69 <= pad_data_out_70;
       pad_data_out_78 <= pad_data_out_79;
       pad_data_out_87 <= pad_data_out_88;
       pad_data_out_96 <= pad_data_out_97;
       pad_data_out_105 <= pad_data_out_106;
   end
 end
end

always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_7 <= 'b0;
   pad_data_out_16 <= 'b0;
   pad_data_out_25 <= 'b0;
   pad_data_out_34 <= 'b0;
   pad_data_out_43 <= 'b0;
   pad_data_out_52 <= 'b0;
   pad_data_out_61 <= 'b0;
   pad_data_out_70 <= 'b0;
   pad_data_out_79 <= 'b0;
   pad_data_out_88 <= 'b0;
   pad_data_out_97 <= 'b0;
   pad_data_out_106 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc > 7054) begin
      pad_data_out_7 <= 'b0;
      pad_data_out_16 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_34 <= 'b0;
      pad_data_out_43 <= 'b0;
      pad_data_out_52 <= 'b0;
      pad_data_out_61 <= 'b0;
      pad_data_out_70 <= 'b0;
      pad_data_out_79 <= 'b0;
      pad_data_out_88 <= 'b0;
      pad_data_out_97 <= 'b0;
      pad_data_out_106 <= 'b0;
   end
   else if(kernel_loc % 85 == 0) begin
      pad_data_out_7 <= 'b0;
      pad_data_out_16 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_34 <= 'b0;
      pad_data_out_43 <= 'b0;
      pad_data_out_52 <= 'b0;
      pad_data_out_61 <= 'b0;
      pad_data_out_70 <= 'b0;
      pad_data_out_79 <= 'b0;
      pad_data_out_88 <= 'b0;
      pad_data_out_97 <= 'b0;
      pad_data_out_106 <= 'b0;
   end
   else begin
       pad_data_out_7 <= pad_data_out_8;
       pad_data_out_16 <= pad_data_out_17;
       pad_data_out_25 <= pad_data_out_26;
       pad_data_out_34 <= pad_data_out_35;
       pad_data_out_43 <= pad_data_out_44;
       pad_data_out_52 <= pad_data_out_53;
       pad_data_out_61 <= pad_data_out_62;
       pad_data_out_70 <= pad_data_out_71;
       pad_data_out_79 <= pad_data_out_80;
       pad_data_out_88 <= pad_data_out_89;
       pad_data_out_97 <= pad_data_out_98;
       pad_data_out_106 <= pad_data_out_107;
   end
end
end

always @(posedge clk) begin
 if (!rst_n) begin
   pad_data_out_8 <= 'b0;
   pad_data_out_17 <= 'b0;
   pad_data_out_26 <= 'b0;
   pad_data_out_35 <= 'b0;
   pad_data_out_44 <= 'b0;
   pad_data_out_53 <= 'b0;
   pad_data_out_62 <= 'b0;
   pad_data_out_71 <= 'b0;
   pad_data_out_80 <= 'b0;
   pad_data_out_89 <= 'b0;
   pad_data_out_98 <= 'b0;
   pad_data_out_107 <= 'b0;
 end
 else if (padding_enable && (layer_bits == 3'd2 || layer_bits == 3'd3 || layer_bits == 3'd4 || layer_bits == 3'd5)) begin
   if(kernel_loc > 7054) begin
      pad_data_out_8 <= 'b0;
      pad_data_out_17 <= 'b0;
      pad_data_out_26 <= 'b0;
      pad_data_out_35 <= 'b0;
      pad_data_out_44 <= 'b0;
      pad_data_out_53 <= 'b0;
      pad_data_out_62 <= 'b0;
      pad_data_out_71 <= 'b0;
      pad_data_out_80 <= 'b0;
      pad_data_out_89 <= 'b0;
      pad_data_out_98 <= 'b0;
      pad_data_out_107 <= 'b0;
   end
   else if(kernel_loc % 85 == 84) begin
      pad_data_out_8 <= 'b0;
      pad_data_out_17 <= 'b0;
      pad_data_out_26 <= 'b0;
      pad_data_out_35 <= 'b0;
      pad_data_out_44 <= 'b0;
      pad_data_out_53 <= 'b0;
      pad_data_out_62 <= 'b0;
      pad_data_out_71 <= 'b0;
      pad_data_out_80 <= 'b0;
      pad_data_out_89 <= 'b0;
      pad_data_out_98 <= 'b0;
      pad_data_out_107 <= 'b0;
   end
   else begin
       pad_data_out_8 <= 
       pad_data_out_17 <= 
       pad_data_out_26 <= 
       pad_data_out_35 <= 
       pad_data_out_44 <= 
       pad_data_out_53 <= 
       pad_data_out_62 <= 
       pad_data_out_71 <= 
       pad_data_out_80 <= 
       pad_data_out_89 <= 
       pad_data_out_98 <= 
       pad_data_out_107 <= 
   end
 end
end


///////////////////////////////////////////////////

/// conv_last
always @(posedge clk) begin
  if (!rst_n) begin
      pad_data_out_0 <= 'b0;
  end
  else if (padding_enable && layer_bits == 3'd7) begin
    if (kernel_loc < 172) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_50 <= 'b0;
    end
    else if (kernel_loc % 86 < 4) begin
      pad_data_out_0 <= 'b0;
      pad_data_out_25 <= 'b0;
      pad_data_out_50 <= 'b0;
    end
    else begin
      pad_data_out_0 <= pad_data_out_1 ;
      pad_data_out_25 <= pad_data_out_26 ;
      pad_data_out_50 <= pad_data_out_51 ;
    end
end      
end







endmodule
