module ALU_Control(
    funct_i,
    ALUOp_i,
    ALUCtrl_o
);

input   [31:0]   funct_i;
input   [1:0]   ALUOp_i;
output  [2:0]   ALUCtrl_o;
reg     [2:0]   ALUCtrl_o;
wire [6:0] funct7;
wire [2:0] funct3;
assign funct7 = funct_i[31:25];
assign funct3 = funct_i[15:12];
always@*
begin
    if(ALUOp_i == 2'b10)      //R type
        begin
            case(funct7)
                7'b0000000: begin
                    case(funct3)
                        3'b110: ALUCtrl_o <= 3'b001; // OR
                        3'b111: ALUCtrl_o <= 3'b000; // AND
                        3'b000: ALUCtrl_o <= 3'b010; // ADD
                    endcase
                end
                7'b0100000: ALUCtrl_o <= 3'b110; //SUB
                7'b0000001: ALUCtrl_o <= 3'b011; //MUL
            endcase
        end
    else if(ALUOp_i==2'b00)
        begin
            ALUCtrl_o <= 3'b010;
        end
    else if(ALUOp_i==2'b01)
    begin
        ALUCtrl_o <=3'b110;
    end
end

endmodule
