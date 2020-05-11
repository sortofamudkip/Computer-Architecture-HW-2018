module Sign_Extend (data_i, data_o);

input   [31:0]  data_i;
output  [31:0]  data_o;

wire [11:0] imm; 

assign imm = data_i[31:20];

assign data_o = {{20{imm[11]}}, imm};

endmodule