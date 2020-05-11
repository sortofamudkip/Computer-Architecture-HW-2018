module CPU
(
    clk_i, 
    rst_i,
    start_i,
    //we copy the new signal
    mem_data_i, 
    mem_ack_i,  
    mem_data_o, 
    mem_addr_o,     
    mem_enable_o, 
    mem_write_o
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

// to Data Memory interface     
//
input   [256-1:0]   mem_data_i; 
input               mem_ack_i;  
output  [256-1:0]   mem_data_o; 
output  [32-1:0]    mem_addr_o;     
output              mem_enable_o; 
output              mem_write_o; 

wire [31:0] inst_addr,inst;

// L1 data cache
dcache_top dcache
(
    // System clock, reset and stall
    .clk_i(clk_i), 
    .rst_i(rst_i),
    
    // to Data Memory interface     
    .mem_data_i(mem_data_i), 
    .mem_ack_i(mem_ack_i),  
    .mem_data_o(mem_data_o), 
    .mem_addr_o(mem_addr_o),    
    .mem_enable_o(mem_enable_o), 
    .mem_write_o(mem_write_o), 
    
    // to CPU interface 
    .p1_data_i(EXMEM.data2_o), 
    .p1_addr_i(EXMEM.data1_o),   
    .p1_MemRead_i(EXMEM.MemRead_o), 
    .p1_MemWrite_i(EXMEM.MemWrite_o), 
    .p1_data_o(),    // this goes to MEMWB
    .p1_stall_o()    // THIS IS THE MEMSTALL SIGNAL  
);

Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

Adder Add_notPC(
    .data1_in   (IFID.addnotPC_o),
    .data2_in   (ShiftLeft.data_o),
    .data_o     ()
);
ShiftLeft ShiftLeft(
    .data_i     (Sign_Extend.data_o),
    .data_o     ()
);
PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .stall_i    (dcache.p1_stall_o),
    .pcEnable_i  (Hazard.PCSelect_o),
    .pc_i       (MUX_PC.data_o),
    .pc_o       (inst_addr)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (inst_addr),
    .instr_o    ()
);
IFID IFID(
    .clk_i      (clk_i),
    .stall_i    (dcache.p1_stall_o),
    .pc_i       (PC.pc_o),
    .instr_i    (Instruction_Memory.instr_o),
    .IFflush_i  (AND.data_o),
    .IFIDWrite_i (Hazard.IFID_o),
    .addnotPC_o (),
    .instr_o    ()
);
HDU Hazard(
    .IDEXM_i    (IDEX.MemRead_o),
    .IFID_i     (IFID.instr_o),
    .IDEX_i     (IDEX.Rd_o),
    .PCSelect_o (),
    .IFID_o     (),
    .OR_o       ()
);

EXMEM EXMEM(
    .clk_i      (clk_i),
    .stall_i    (dcache.p1_stall_o),
    .MemToReg_i (IDEX.MemToReg_o),
    .RegWrite_i (IDEX.RegWrite_o),
    .MemWrite_i (IDEX.MemWrite_o),
    .MemRead_i  (IDEX.MemRead_o),
    .ALU_i      (ALU.data_o),
    .MUXdown_i  (MUX4to1down.data_o),
    .IDEX_i     (IDEX.Rd_o),
    .MemToReg_o (),
    .RegWrite_o (),                    
    .data1_o    (),                    
    .data2_o    (),
    .MEMWB_o    (),
    .MemWrite_o (),
    .MemRead_o  ()
);

MEMWB MEMWB(
    .clk_i      (clk_i),
    .stall_i    (dcache.p1_stall_o),
    // control signals
    .MemToReg_i (EXMEM.MemToReg_o),
    .RegWrite_i (EXMEM.RegWrite_o),
    // inputs
    .data1_i    (dcache.p1_data_o),
    .data2_i    (EXMEM.data1_o),
    .data3_i    (EXMEM.MEMWB_o),
    // output signals
    .MemToReg_o (),
    .RegWrite_o (),
    // output data
    .MUX1_o     (),
    .MUX2_o     (),
    .Forward_o  ()
);
Forwarding_Unit Forward(
    .MEMWBRegWrite_i        (MEMWB.RegWrite_o),
    //.MemToReg_i     (MEMWB.MemToReg_o),
    //.RegWrite_i     (MEMWB.RegWrite_o),

    .EXMEMRegWrite_i        (EXMEM.RegWrite_o),
    //.MemWrite_i     (EXMEM.MemWrite_o),
    //.MemRead_i      (EXMEM.MemRead_o),

    .MEMforward_i   (MEMWB.Forward_o),
    .EXMEMforward_i (EXMEM.MEMWB_o),
    .IDEX1_i        (IDEX.Rs1_o),
    .IDEX2_i        (IDEX.Rs2_o),
    .MUXup_o        (),
    .MUXdown_o      ()
);

// RegWrite_i changed, now it comes from MEMWB
Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IFID.instr_o[19:15]),
    .RTaddr_i   (IFID.instr_o[24:20]),
    .RDaddr_i   (MEMWB.Forward_o),
    .RDdata_i   (MUX_final.data_o),
    .RegWrite_i (MEMWB.RegWrite_o),
    .RSdata_o   (), 
    .RTdata_o   () 
);
/*
MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RTdata_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
);*/
MUX32 MUX_PC(
    .data1_i    (Add_notPC.data_o),
    .data2_i    (Add_PC.data_o),
    .select_i   (~AND.data_o), //FIGURE THIS FUCKING THINGS OUT
    .data_o     ()
);
/*
MUX32 MUX_OR(
    .data1_i    (OR.data_o),
    .data2_i    (1'b0),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
);
*/

// MUX32 MUX_WB(
//     .data1_i    (IDEX.WB_o),
//     .data2_i    (1'b0),
//     .select_i   (Control.Exflush_o),
//     .data_o     ()
// );
// MUX32 MUX_M(
//     .data1_i    (IDEX.M_o),
//     .data2_i    (1'b0),
//     .select_i   (Control.Exflush_o),
//     .data_o     ()
// );
MUX32 MUX_final(
    .data1_i    (MEMWB.MUX1_o),
    .data2_i    (MEMWB.MUX2_o),
    .select_i   (~MEMWB.MemToReg_o), 
    .data_o     ()
);
MUX4to1 MUX4to1up(
    .data1_i    (IDEX.RSData_o),
    .data2_i    (MUX_final.data_o),
    .data3_i    (EXMEM.data1_o),
    .select_i   (Forward.MUXup_o),
    .data_o     ()
);
MUX4to1 MUX4to1down(
    .data1_i    (IDEX.RTData_o),
    .data2_i    (MUX_final.data_o),
    .data3_i    (EXMEM.data1_o),
    .select_i   (Forward.MUXdown_o),
    .data_o     ()
);

MUX32 MUX_immediate(
    .data1_i    (MUX4to1down.data_o),
    .data2_i    (IDEX.SignExtended_o),
    .select_i   (IDEX.ALUSrc_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .data_i     (IFID.instr_o),
    .memwrite_i (Control.MemWrite_o),
    .isflush_i  (Control.IF_Flush_o),
    .data_o     ()
);
Equal Equal(
    .data1_i    (Registers.RSdata_o),
    .data2_i    (Registers.RTdata_o),
    .data_o     ()
);
/*
Data_Memory Data(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .addr_i,    (),
    .data_i,    (),
    .enable_i,  (),
    .write_i,   (),
    .ack_o,     (),
    .data_o     ()
);*/
AND AND(
    .data1_i    (Equal.data_o), 
    .data2_i    (Control.IsBranch_o), 
    .data_o     ()
);
/*
OR OR (
    data1_i     (), 
    data2_i     (), 
    data_o      ()
);*/
ALU ALU(
    .data1_i    (MUX4to1up.data_o),
    .data2_i    (MUX_immediate.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     ()
);

// Syenny's updates 

Control Control (
    .Op_i           (IFID.instr_o[6:0]),
    .RegDst_o       (),
    .ALUOp_o        (),
    .ALUSrc_o       (),
    .MemRead_o      (),
    .MemWrite_o     (),
    .RegWrite_o     (),
    .MemToReg_o     (),
    .IsBranch_o     (),
    .IF_Flush_o     ()
    // .ID_Flush_o     (),
    // .EX_Flush_o     ()
);

IDEX IDEX (
    .clk_i           (clk_i), 
    .stall_i         (dcache.p1_stall_o),
    .inst_i          (IFID.instr_o), 
    //.pc_i            (IFID.pc_o),
    .RSData_i        (Registers.RSdata_o), 
    .RTData_i        (Registers.RTdata_o),
    .SignExtended_i  (Sign_Extend.data_o),
    .Rs1_i           (IFID.instr_o[19:15]),
    .Rs2_i           (IFID.instr_o[24:20]),
    .Rd_i            (IFID.instr_o[11:7]),

    .inst_o          (), 
    //.pc_o            (), 
    // .stall_i         (),
    .RSData_o        (), 
    .RTData_o        (),
    .SignExtended_o  (),
    .Rs1_o           (),
    .Rs2_o           (),
    .Rd_o            (),

    //Control Signals
    .RegDst_i        (MUX8.RegDst_o),
    .ALUOp_i         (MUX8.ALUOp_o),
    .ALUSrc_i        (MUX8.ALUSrc_o),
    .MemRead_i       (MUX8.MemRead_o),
    .MemWrite_i      (MUX8.MemWrite_o),
    .RegWrite_i      (MUX8.RegWrite_o),
    .MemToReg_i      (MUX8.MemToReg_o),
    .RegDst_o        (),
    .ALUOp_o         (),
    .ALUSrc_o        (),
    .MemRead_o       (),
    .MemWrite_o      (),
    .RegWrite_o      (),
    .MemToReg_o      ()
);


MUX8 MUX8 (
  .IsHazard_i  (Hazard.OR_o),

  .RegDst_i     (Control.RegDst_o),
  .ALUOp_i      (Control.ALUOp_o),
  .ALUSrc_i     (Control.ALUSrc_o),
  .RegWrite_i   (Control.RegWrite_o),
  .MemToReg_i   (Control.MemToReg_o),
  .MemRead_i    (Control.MemRead_o),
  .MemWrite_i   (Control.MemWrite_o),

  .RegDst_o     (),
  .ALUOp_o      (),
  .ALUSrc_o     (),
  .RegWrite_o   (),
  .MemToReg_o   (),
  .MemRead_o    (),
  .MemWrite_o   ()
);

ALU_Control ALU_Control(
    .funct_i    (IDEX.inst_o[31:0]),
    .ALUOp_i    (IDEX.ALUOp_o),
    .ALUCtrl_o  ()
);


endmodule

