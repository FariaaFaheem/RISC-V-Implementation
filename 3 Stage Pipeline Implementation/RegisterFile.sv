module RegisterFile (input logic clk, rfwrite,
                     input logic [4:0] raddr1, raddr2, waddr,
                     input logic [31:0] wdata,
                     output logic [31:0] rdata1, rdata2);

logic [31:0] Registers [31:0];
initial begin
	$readmemh("reg.txt", Registers);
end	
always_comb begin 
    rdata1 = (|raddr1) ? Registers[raddr1] : 32'b0;
    rdata2 = (|raddr2) ? Registers[raddr2] : 32'b0;
end

always_ff @( negedge clk ) begin 
    if (rfwrite) begin
        Registers[waddr] <= (|waddr) ? wdata : 32'b0;
    end
end
    
endmodule