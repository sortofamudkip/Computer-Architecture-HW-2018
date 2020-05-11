module Forwarding_Unit(
    MEMWBRegWrite_i, //the blue line
    EXMEMRegWrite_i, //the blue line
    MEMforward_i, //the blackline from MEMWB
    EXMEMforward_i, // theblack line from EXMEM
    IDEX1_i,
    IDEX2_i,
    MUXup_o,
    MUXdown_o
);
input [4:0] IDEX1_i,IDEX2_i,MEMforward_i, EXMEMforward_i;
input MEMWBRegWrite_i,EXMEMRegWrite_i;
output [1:0] MUXup_o,MUXdown_o;
reg [1:0] MUXup_o,MUXdown_o;
//MUXup for ForwardA, MUXdown for ForwardB

//ForwardA
    // always@(IDEX1_i or IDEX2_i or MEMforward_i or EXMEMforward_i or MEMWBRegWrite_i or EXMEMRegWrite_i)
    always @*
    begin
        if((EXMEMRegWrite_i) &&(EXMEMforward_i!=1'b0) &&(EXMEMforward_i == IDEX1_i) )
            MUXup_o <= 2'b10;
        else if((MEMWBRegWrite_i) && (MEMforward_i!=1'b0) &&(MEMforward_i == IDEX1_i))
            MUXup_o <= 2'b01;
        else
            MUXup_o <= 2'b00;
    // end
//ForwardB
    // always@(IDEX1_i or IDEX2_i or MEMforward_i or EXMEMforward_i or MEMWBRegWrite_i or EXMEMRegWrite_i)
    // begin
        if((EXMEMRegWrite_i) &&(EXMEMforward_i!=1'b0) &&(EXMEMforward_i == IDEX2_i) )
            MUXdown_o <= 2'b10;
        else if((MEMWBRegWrite_i) && (MEMforward_i!=1'b0) &&(MEMforward_i == IDEX2_i))
            MUXdown_o <= 2'b01;
        else
            MUXdown_o <= 2'b00;
    end
endmodule

