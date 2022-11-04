module DataMemory (input logic clk, cs, wr_en,
                   input logic [3:0] mask,
                   input logic [31:0] Mem_Addr, Mem_inData, 
                   output logic [31:0] Mem_outData);

logic [31:0] MemoryFile [31:0];
initial begin
	$readmemh("data.txt", MemoryFile);
	end

always_ff @(negedge clk) begin
	// Storing Data from Register Files into Data Memory
	if (!cs && !wr_en) begin
        if (mask[0])
		    MemoryFile[Mem_Addr[31:2]][7:0] = Mem_inData[7:0];
        if (mask[1])
		    MemoryFile[Mem_Addr[31:2]][15:8] = Mem_inData[15:8];
        if (mask[2])
		    MemoryFile[Mem_Addr[31:2]][23:16] = Mem_inData[23:16];
        if (mask[3])
		    MemoryFile[Mem_Addr[31:2]][31:24] = Mem_inData[31:24];
        end
end	

    // Loading Data from Data Memory to Register Files
assign Mem_outData = (wr_en && !cs) ? MemoryFile[Mem_Addr[31:2]] : 32'b0;
    	
endmodule