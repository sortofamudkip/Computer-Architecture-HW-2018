module CPU( clk_i,  rst_i, start_i);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] inst_addr, inst; // where the instruction is (PC) + the actual instruction
wire meh1, meh2, meh3, meh4, always_true; // doesn't actually do anything
wire [9:0] funct;

wire [6:0] fseven;
wire [2:0] fthree;


assign always_true = 1'b1;

// HOW DO YOU DO THIS
Control Control(
    .Op_i       (inst[6:0]),
    .RegDst_o   (meh2), // doesn't matter
    .ALUOp_o    (/*ALU_Control.ALUOp_i*/), // the 5th and 4th bits
    .ALUSrc_o   (meh3), // doesn't matter
    .RegWrite_o (always_true)  // always 1
);


// move the PC; DONE
Adder Add_PC(
    .data1_in   (inst_addr),
    .data2_in   (32'd4),
    .data_o     (PC.pc_i)
);

// does... something; correct
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (inst_addr)
);

// fetches the instruction; correct
Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr), 
    .instr_o    (inst)
);

// does registery stuff
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (inst[19:15]),
    .RTaddr_i   (inst[24:20]),
    .RDaddr_i   (inst[11:7]), 
    .RDdata_i   (ALU.data_o),
    .RegWrite_i (Control.RegWrite_o), 
    .RSdata_o   (/*ALU.data1_i*/), 
    .RTdata_o   (/*ALU.data2_i*/) 
);

/* we don't need this??
MUX5 MUX_RegDst(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     ()
);
*/

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     (/*ALU.data_o*/)
);


// DONE
Sign_Extend Sign_Extend(
    .data_i     (inst),
    .data_o     (/*MUX_ALUSrc.data2_i*/)
);

  

ALU ALU(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (/*Registers.RDdata_i*/),
    .Zero_o     (meh1)
);


// funct7, funct3
assign fseven = inst[31:25];
assign fthree = inst[15:12];
assign funct = {fseven,fthree};

ALU_Control ALU_Control( // correct
    .funct_i    (funct),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  (ALU.ALUCtrl_i)
);


endmodule

