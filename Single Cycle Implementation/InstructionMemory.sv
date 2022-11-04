module InstructionMemory (input logic [31:0] iaddr,
                          output logic [31:0] Instruction);
//512 Instructions

logic [31:0] Instruction_Mem [63:0];
initial begin
    $readmemh("ins.txt", Instruction_Mem);
end 
always_comb begin 
    Instruction = Instruction_Mem[iaddr[31:2]];
end
endmodule