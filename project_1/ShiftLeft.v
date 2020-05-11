module ShiftLeft (data_i, data_o);

input    [31:0]    data_i;
output    [31:0]     data_o;
reg     [31:0]     data_o;
always @(data_i)
begin
data_o <=0;
data_o[31:1] <= data_i[30:0];
end

endmodule

