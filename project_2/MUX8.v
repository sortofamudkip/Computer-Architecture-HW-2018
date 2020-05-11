module MUX8 (
	IsHazard_i,

	//for EX
	RegDst_i,
	ALUOp_i,
	ALUSrc_i,

	// for WB
	RegWrite_i, 
	MemToReg_i,

	// for M
	MemRead_i, 
	MemWrite_i,
    isBranch_i,


	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemToReg_o,
    isBranch_o
	
);
input IsHazard_i;
	
input RegDst_i; 
input [1:0] ALUOp_i; 
input ALUSrc_i; 
input RegWrite_i; 
input MemToReg_i; 
input MemRead_i; 
input MemWrite_i;
input isBranch_i;

output RegDst_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output MemRead_o;
output MemWrite_o;
output RegWrite_o;
output MemToReg_o;
output isBranch_o;

assign RegDst_o   = (IsHazard_i)? 1'b0 : RegDst_i;
assign ALUOp_o    = (IsHazard_i)? 2'b00 : ALUOp_i;
assign ALUSrc_o   = (IsHazard_i)? 1'b0 : ALUSrc_i;
assign MemRead_o  = (IsHazard_i)? 1'b0 : MemRead_i;
assign MemWrite_o = (IsHazard_i)? 1'b0 : MemWrite_i;
assign RegWrite_o = (IsHazard_i)? 1'b0 : RegWrite_i;
assign MemToReg_o = (IsHazard_i)? 1'b0 : MemToReg_i;
assign isBranch_o = (IsHazard_i)? 1'b0 : isBranch_i;

endmodule

