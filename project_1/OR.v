module OR (data1_i, data2_i, data_o);
	input 	data1_i, data2_i;
	output	data_o;
	
	wire	data_o;

	assign data_o = data1_i | data2_i;

endmodule
