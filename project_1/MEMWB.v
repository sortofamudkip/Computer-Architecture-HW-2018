module MEMWB (
	clk_i,
	MemToReg_i,
	RegWrite_i,
	data1_i,
	data2_i,
	data3_i,
	MemToReg_o,
	RegWrite_o,
	MUX1_o,
	MUX2_o,
	Forward_o
);

input           clk_i;
// control signals
input           MemToReg_i;
input           RegWrite_i;
// data
input   [31:0]  data1_i;    // Data Memory's read data
input   [31:0]  data2_i;    // EXMEM's ALU result (data1_o)
input   [4:0]  data3_i;    // EXMEM's MEMWB_o (forwarded from IDEX)

// control signals
output          MemToReg_o; 
output          RegWrite_o;
// data
output  [31:0]  MUX1_o;
output  [31:0]  MUX2_o;
output  [4:0]  Forward_o;
// control 
reg          MemToReg_o; 
reg          RegWrite_o;
// data
reg  [31:0]  MUX1_o;
reg  [31:0]  MUX2_o;
reg  [4:0]  Forward_o;
initial begin
	MemToReg_o <= 1'b0;
	RegWrite_o <= 1'b0;
	MUX1_o		<= 32'd0;
	MUX2_o		<= 32'd0;
	Forward_o	<= 5'd0;

end
// literally just passes everything along without modifying anything signals
// always @(posedge clk_i & (MemToReg_i | RegWrite_i | data1_i | data2_i | data3_i))
always @(posedge clk_i)
begin
	// control signals
	MemToReg_o <= MemToReg_i;
	RegWrite_o <= RegWrite_i;
	// data
	MUX1_o     <= data1_i;
	MUX2_o     <= data2_i;
	Forward_o  <= data3_i;
end

endmodule