module Data_Memory
(
    clk_i,     // clock
    addr_i,    // address to read/write
    WData_i,   // data to write into memory
    MemWrite_i,// should I write into memory?
    MemRead_i, // should I read from memory?
    ReadData_o // the data read from memory
);

// Ports
input               clk_i;
input   [31:0]       addr_i;
input   [31:0]      WData_i;
input               MemWrite_i;
input               MemRead_i;
output  [31:0]      ReadData_o;

// Register File
reg     [7:0]      memory        [0:31];
reg ReadData_o;
// Read Data
always@(negedge clk_i) begin
    if (MemRead_i) 
        ReadData_o <= memory[addr_i];
end

// Write Data   
always@(posedge clk_i) begin
    if(MemWrite_i)
        memory[addr_i] <= WData_i;
end
   
endmodule 
