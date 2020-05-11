module IDEX (
	clk_i, 
	inst_i, 
	//pc_i,
	RSData_i, 
	RTData_i,
	SignExtended_i,
	Rs1_i,
	Rs2_i,
	Rd_i,

	inst_o, 
	//pc_o, 
	Rs1_o,
	Rs2_o,
	Rd_o,
// 	stall_i,
	RSData_o, 
	RTData_o,
	SignExtended_o,

	RegDst_i,
	ALUOp_i,
	ALUSrc_i,
	MemRead_i,
	MemWrite_i,
	RegWrite_i,
	MemToReg_i,
	RegDst_o,
	ALUOp_o,
	ALUSrc_o,
	MemRead_o,
	MemWrite_o,
	RegWrite_o,
	MemToReg_o
);

input 	     	clk_i;
input [31:0]    inst_i;
//input [31:0]    pc_i;
input [4:0]		Rs1_i,Rs2_i,Rd_i;
input [31:0]    RSData_i;
input [31:0]    RTData_i;
input [31:0]    SignExtended_i;

// input 			stall_i;
output [31:0] 	RSData_o;
output [31:0] 	RTData_o;
output [31:0] 	SignExtended_o;
output [31:0] 	inst_o;
//output [31:0] 	pc_o;	//SEPC
output [4:0]		Rs1_o,Rs2_o,Rd_o;

//control
input RegDst_i;
input ALUSrc_i;
input RegWrite_i;
input MemToReg_i;
input MemRead_i;
input MemWrite_i;
input [1:0]	 ALUOp_i;

output 	     RegDst_o, ALUSrc_o, RegWrite_o, MemToReg_o, MemRead_o, MemWrite_o;
output [1:0] ALUOp_o;


reg [31:0] 	RSData_o;
reg [31:0] 	RTData_o;
reg [31:0] 	SignExtended_o;
reg [4:0]	Rs1_o,Rs2_o,Rd_o;
reg [31:0] 	inst_o;
//reg [31:0] 	pc_o 			= 32'd0;

reg 	    RegDst_o;
reg 		ALUSrc_o;
reg 		RegWrite_o; 
reg 		MemToReg_o; 
reg 		MemRead_o; 
reg 		MemWrite_o;
reg [1:0]   ALUOp_o;

initial begin 
    RSData_o 		    <= 32'd0;
    RTData_o 		    <= 32'd0;
    SignExtended_o 	    <= 32'd0;
    Rs1_o               <= 5'd0;
    Rs2_o               <= 5'd0;
    Rd_o                <= 5'd0;
    inst_o 			    <= 32'd0;
  
    RegDst_o            <= 1'd0;
   	ALUSrc_o            <= 1'd0;
    RegWrite_o          <= 1'd0; 
   	MemToReg_o          <= 1'd0; 
    MemRead_o           <= 1'd0; 
    MemWrite_o          <= 1'd0;
    ALUOp_o             <= 2'd0;


end

//always @(posedge clk_i & (inst_i | Rs1_i | Rs2_i | Rd_i | RSData_i | RTData_i | SignExtended_i | RegDst_i | ALUSrc_i | RegWrite_i | MemToReg_i | MemRead_i| MemWrite_i |ALUOp_i))
 always @(posedge clk_i) 
begin
	// if(~stall_i) 
	inst_o			<=	inst_i;	//the bottom part
	//pc_o			<=	pc_i;
	Rs1_o			<=  Rs1_i;
	Rs2_o			<=  Rs2_i;
	Rd_o			<=  Rd_i;
	RSData_o		<=	RSData_i;
	RTData_o		<=	RTData_i;
	SignExtended_o	<=	SignExtended_i;

	//control
	ALUSrc_o		<= ALUSrc_i;
	RegDst_o 		<= RegDst_i;
	ALUOp_o			<= ALUOp_i;
	
	MemRead_o		<= MemRead_i;
	MemWrite_o		<= MemWrite_i;
	RegWrite_o		<= RegWrite_i;
	MemToReg_o		<= MemToReg_i;
end

endmodule


