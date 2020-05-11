module Control (Op_i, RegDst_o, ALUOp_o, ALUSrc_o, RegWrite_o);

input [6:0]     Op_i;
output [1:0]    ALUOp_o;
output          RegDst_o, ALUSrc_o, RegWrite_o;

assign ALUOp_o    = Op_i[5:4];
assign RegDst_o   = 1'b0;
assign ALUSrc_o   = ~Op_i[5];
assign RegWrite_o = 1'b1; // always true

endmodule