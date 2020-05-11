module PC
(
    clk_i,
    rst_i,
    start_i,
    pc_i,
    pc_o,
    PCWrite_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;
input PCWrite_i;
input   [31:0]      pc_i;
output  [31:0]      pc_o;


// Wires & Registers
reg     [31:0]      pc_o;


always@(posedge clk_i or negedge rst_i) begin
    // $display("rst = %d bitch", rst_i);
    if(~rst_i) begin // should reset
        pc_o <= 32'b0;
    end
    else begin // shouldn't reset
        if(start_i) // should start
            pc_o <= pc_i;
        else begin// not starting
             //PCwrite_i =0 means stall 1 means no stall
            pc_o<=pc_o;
        end
        if(PCWrite_i) pc_o <= pc_i;
        else pc_o<=pc_o;
    end
    // if (start_i) begin 
    //     if(PCWrite_i == 1) pc_o <= pc_i;
    //     else pc_o <= pc_o;
    // end
    // else pc_o <= 32'b0;
     
end

endmodule
