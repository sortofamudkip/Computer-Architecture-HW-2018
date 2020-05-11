module ALU (data1_i, data2_i, ALUCtrl_i, data_o, Zero_o);

input  [31:0] data1_i, data2_i;
input  [2:0]  ALUCtrl_i;
output [31:0] data_o;
output        Zero_o;

reg [31:0] out;

always @(data1_i or data2_i or ALUCtrl_i) begin
	case (ALUCtrl_i)
	    3'b000  : out = data1_i | data2_i;
	    3'b001  : out = data1_i & data2_i;
	    3'b010  : out = data1_i + data2_i;
	    3'b011  : out = data1_i - data2_i;
	    3'b101  : out = data1_i * data2_i;
	    3'b100  : out = data1_i + data2_i; // this is the same as 010
	    default : out = 32'bx;
	endcase
end

assign data_o = out;

assign Zero_o = (data_o == 32'd0) ? 1 : 0;

endmodule