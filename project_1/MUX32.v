module MUX32(
    data1_i,
    data2_i,
    select_i,
    data_o
);

input [31:0] data1_i;
input [31:0] data2_i;
input select_i;
output [31:0] data_o;
reg [31:0] data_o;

always @*
    if (select_i)
        data_o <= data2_i;
    else
        data_o <= data1_i;

endmodule

