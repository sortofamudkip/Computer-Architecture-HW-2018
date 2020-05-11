module ALU(
    ALUCtrl_i,
    data1_i,
    data2_i,
    data_o,
);

input   [2:0]   ALUCtrl_i;
input   [31:0]  data1_i, data2_i;
output  [31:0]  data_o;

reg [31:0] data_o, C;

always @(data1_i or data2_i or ALUCtrl_i)
    begin
        case (ALUCtrl_i)
            3'b000 :
                data_o = data1_i & data2_i; // AND
            3'b001 :
                data_o = data1_i | data2_i; // OR
            3'b010 :
                data_o = data1_i + data2_i; // ADD
            3'b110 :
                data_o = data1_i - data2_i; // SUBTRACT
            3'b011:
                data_o = data1_i * data2_i; //MULTIPLICATION
        endcase
    end
endmodule

