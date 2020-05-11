module IFID
(
	clk_i,
    pc_i,
    stall_i,
    instr_i,
    IFflush_i,
    IFIDWrite_i,
    addnotPC_o,
    instr_o
);

input	clk_i, IFflush_i;
input IFIDWrite_i;
input stall_i;
input	[31:0]	pc_i; 
input   [31:0]  instr_i;
output	[31:0]	instr_o;
output	[31:0] 	addnotPC_o;

reg 	[31:0] 	instr_o;
reg		[31:0] 	addnotPC_o;

initial
begin
	instr_o = 32'd0;
	addnotPC_o = 32'd0;
end 

// always @(posedge clk_i & (pc_i | instr_i))
always @(posedge clk_i)
 begin
 	if(~stall_i) begin
 		if(IFIDWrite_i) begin 
			if(~IFflush_i)
				begin
					// instr_o <= instr_i;
					instr_o <= instr_i;
					addnotPC_o <= pc_i; 
				end
			else
				begin
					instr_o <= 32'd0;
					addnotPC_o <= pc_i;
				end
		end
	end
end
endmodule