module Control (
	Op_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemToReg_o,
 	IsBranch_o,
	IF_Flush_o
// 	ID_Flush_o,
// 	EX_Flush_o
);

input [6:0] Op_i;
output RegDst_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output MemRead_o;
output MemWrite_o;
output RegWrite_o;
output MemToReg_o;
output IsBranch_o;
output IF_Flush_o;
output ID_Flush_o;
output EX_Flush_o;

reg [1:0] ALUOp_o;
reg RegDst_o;
reg ALUSrc_o, MemRead_o, MemWrite_o, RegWrite_o, MemToReg_o, IsBranch_o, IF_Flush_o, ID_Flush_o, EX_Flush_o;

initial begin
	RegDst_o <=1'b0;
	ALUOp_o  <= 2'd0;
	ALUSrc_o <= 1'b0;
	MemRead_o <= 1'b0;
	MemWrite_o <= 1'b0;
	RegWrite_o <= 1'b0;
	MemToReg_o <= 1'b0;
	IsBranch_o <= 1'b0;
	IF_Flush_o <= 1'b0;
end
always @(Op_i) begin

	case(Op_i)

		//R-type
		7'b0110011: 
		begin
			RegDst_o 	= 1'b1;
			ALUOp_o 	= 2'b10;
			ALUSrc_o 	= 1'b0; 
			MemRead_o	= 1'b0;
			MemWrite_o	= 1'b0;
			RegWrite_o	= 1'b1;
			MemToReg_o	= 1'b0;
 			IsBranch_o	= 1'b0;
			IF_Flush_o 	= 1'b0;
// 			ID_Flush_o	= 1'b0;
// 			EX_Flush_o	= 1'b0;
		end
		//Immediate -type
		7'b0010011: 
		begin
			RegDst_o 	= 1'b0;
			ALUOp_o 	= 2'b00;
			ALUSrc_o 	= 1'b1; 
			MemRead_o	= 1'b0;
			MemWrite_o	= 1'b0;
			RegWrite_o	= 1'b1;
			MemToReg_o	= 1'b0;
 			IsBranch_o	= 1'b0;
			IF_Flush_o 	= 1'b0;
// 			ID_Flush_o	= 1'b0;
// 			EX_Flush_o	= 1'b0;
		end
		// I-type for lw
        7'b0000011: 
        begin
        	RegDst_o 	= 1'b0;
        	ALUOp_o 	= 2'b00;
			ALUSrc_o 	= 1'b1; 
			MemRead_o	= 1'b1;
			MemWrite_o	= 1'b0;
			RegWrite_o	= 1'b1;
			MemToReg_o	= 1'b1;
			IsBranch_o	= 1'b0;
			IF_Flush_o 	= 1'b0;
// 			ID_Flush_o	= 1'b0;
// 			EX_Flush_o	= 1'b0;
        end

        // I-type for sw
        7'b0100011: 
        begin
            RegDst_o = 1'b0;
            ALUOp_o 	= 2'b00;
			ALUSrc_o 	= 1'b1; 
			MemRead_o	= 1'b0;
			MemWrite_o	= 1'b1;
			RegWrite_o	= 1'b0;
			MemToReg_o	= 1'b0;
 			IsBranch_o	= 1'b0;
			IF_Flush_o 	= 1'b0;
// 			ID_Flush_o	= 1'b0;
// 			EX_Flush_o	= 1'b0;
        end

        // I-type for beq
        7'b1100011: 
        begin
        	RegDst_o = 1'b0;
        	ALUOp_o 	= 2'b01;
			ALUSrc_o 	= 1'b0; 
			MemRead_o	= 1'b0;
			MemWrite_o	= 1'b0;
			RegWrite_o	= 1'b0;
			MemToReg_o	= 1'b0;
 			IsBranch_o	= 1'b1;
			IF_Flush_o 	= 1'b1;
// 			ID_Flush_o	= 1'b1;
// 			EX_Flush_o	= 1'b1;
        end
       	7'd0: //flush
       	begin
       		RegDst_o = 1'b0;
        	ALUOp_o 	= 2'b00;
			ALUSrc_o 	= 1'b0; 
			MemRead_o	= 1'b0;
			MemWrite_o	= 1'b0;
			RegWrite_o	= 1'b0;
			MemToReg_o	= 1'b0;
 			IsBranch_o	= 1'b0;
			IF_Flush_o 	= 1'b0;
       	end
    endcase   
end

endmodule
