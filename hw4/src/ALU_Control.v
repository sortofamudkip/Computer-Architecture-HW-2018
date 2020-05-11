module ALU_Control (funct_i, ALUOp_i, ALUCtrl_o);

input  [9:0]  funct_i;
input  [1:0]  ALUOp_i;
output [2:0]  ALUCtrl_o;

wire [6:0] funct7;
wire [2:0] funct3;
reg [2:0] ALUCtrl_o;

assign funct7 = funct_i[9:3];
assign funct3 = funct_i[2:0];

always @*
begin
	if (ALUOp_i == 2'b11) begin // r-type, i.e. or, and, add, sub, mul
		if (funct7 == 7'b0000000) begin
			if (funct3 == 3'b110) 
				ALUCtrl_o = 3'b000; // or
			else if (funct3 == 3'b111) 
				ALUCtrl_o = 3'b001; // and
			else if (funct3 == 3'b000) 
				ALUCtrl_o = 3'b010; // add
		end 
		else if (funct7 == 7'b0100000) 
			ALUCtrl_o = 3'b011;     // sub
		else if (funct7 == 7'b0000001)
			ALUCtrl_o = 3'b101;     // mul
	end
	else // imm
		ALUCtrl_o = 3'b100;         // addi
end

endmodule

