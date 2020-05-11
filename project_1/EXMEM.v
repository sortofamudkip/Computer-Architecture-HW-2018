module EXMEM (
    clk_i           ,
    MemToReg_i      ,
    RegWrite_i      ,
    MemRead_i       ,
    MemWrite_i      ,
    ALU_i           ,
    MUXdown_i       ,
    IDEX_i          ,
    MemToReg_o      ,
    RegWrite_o      ,
    data1_o         ,
    data2_o         ,
    MEMWB_o         ,
    MemWrite_o      ,
    MemRead_o          
);
input     clk_i;
input     MemWrite_i,MemRead_i;
input     [31:0]    ALU_i,MUXdown_i;
input     [4:0]     IDEX_i;

input     MemToReg_i, RegWrite_i;


output     MemWrite_o,MemRead_o,MemToReg_o,RegWrite_o;
output     [31:0]   data1_o,data2_o;
output     [4:0]    MEMWB_o;

reg     MemWrite_o,MemRead_o,MemToReg_o,RegWrite_o;
reg     [31:0]   data1_o,data2_o;
reg     [4:0]   MEMWB_o;

initial begin
    MemToReg_o  <= 1'd0;
    RegWrite_o  <= 1'd0;
    MemWrite_o  <= 1'd0;
    MemRead_o   <= 1'd0;
    data1_o     <= 32'd0;
    data2_o     <= 32'd0;
    MEMWB_o     <= 5'd0;
end

// always@(posedge clk_i & (MemToReg_i | RegWrite_i | MemRead_i | MemWrite_i | ALU_i | MUXdown_i | IDEX_i))
always @(posedge clk_i)
    begin
        MemToReg_o      <= MemToReg_i;
        RegWrite_o      <= RegWrite_i;
        MemWrite_o      <= MemWrite_i;
        MemRead_o       <= MemRead_i;
        data1_o         <= ALU_i;
        data2_o         <= MUXdown_i;
        MEMWB_o         <= IDEX_i;
    end
endmodule
