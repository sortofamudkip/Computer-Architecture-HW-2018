module HDU
(
    IDEXM_i,
    IFID_i,
    IDEX_i,
    PCSelect_o,
    IFID_o,
    OR_o
);

input	IDEXM_i; //IDEX MemRead
input	[31:0] IFID_i;
input	[4:0]	IDEX_i; //IDEX REgisterRd
output	IFID_o, PCSelect_o, OR_o;

reg		IFID_o, PCSelect_o, OR_o;
reg 	[4:0] IFID_rt,IFID_rs;


always @* begin 
	IFID_rs <= IFID_i[24:20]; //IFID Rs1
	IFID_rt <= IFID_i[19:15]; //IFID Rs2
	if((IDEXM_i & ((IDEX_i == IFID_rs) | (IDEX_i == IFID_rt)))) //stall
	begin
		PCSelect_o <= 1'b0;
		IFID_o <= 1'b0;
		OR_o <= 1'b1;
	end
	else //no stall
	begin 
		PCSelect_o <= 1'b1;
		IFID_o <= 1'b1;
		OR_o <= 1'b0;
	end

end

endmodule