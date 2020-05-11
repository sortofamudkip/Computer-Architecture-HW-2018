module MUX32 (data1_i, data2_i, select_i, data_o);

input   [31:0] data1_i, data2_i;
input          select_i;
output  [31:0] data_o;

reg [31:0] data_o;
always @*
begin
	data_o <= select_i ? data2_i : data1_i;
end

endmodule