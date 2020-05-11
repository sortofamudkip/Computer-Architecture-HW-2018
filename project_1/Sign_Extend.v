module Sign_Extend
(
    data_i,
    memwrite_i,
    isflush_i,
    data_o
);

input [31:0] data_i;
input memwrite_i,isflush_i;
output [31:0] data_o;
reg [11:0] imm;
reg [31:0] data_o;
// assign imm = data_i[31:20];
// 	assign data_o = {{20{imm[11]}}, imm};
always @*
begin 
	if (memwrite_i) begin //SW
		imm <= {data_i[31:25], data_i[11:7]};
		data_o<= {{20{imm[11]}}, imm};
	end
	else if (isflush_i) begin
		// imm<= {data_i[31],data_i[7],data_i[30:25],data_i[11:8]};
		imm[11] <= data_i[31];
		imm[10] <= data_i[7];
		imm[9:4]<= data_i[30:25];
		imm[3:0] <= data_i[11:8];
		data_o<= {{20{imm[11]}}, imm};
	end
	else begin
		imm <= data_i[31:20];
		data_o<= {{20{imm[11]}}, imm};
	end
end 
endmodule
