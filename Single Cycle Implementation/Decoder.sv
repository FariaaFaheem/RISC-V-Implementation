module Decoder (input logic [2:0] imm_sel,
                input logic [31:0] Instruction,
                output logic [2:0] func3,
                output logic [4:0] raddr1, raddr2, waddr,
                output logic [6:0] opcode, func7,
                output logic [31:0] extended_imm);

logic [31:0] imm, Simm, Uimm, Bimm, Jimm;

assign raddr1 = Instruction[19:15];
assign raddr2 = Instruction[24:20];
assign waddr  = Instruction[11:7];

assign imm    = { {20{Instruction[31]}}, Instruction[31:20] };  //I Type, Load and JALR Instructions
assign Simm   = { {20{Instruction[31]}}, Instruction[31:25], Instruction[11:7] };  //Store Instructions
assign Uimm   = { Instruction[31:12], 12'b0 };    //U Type Instruction
assign Bimm   = { {20{Instruction[31]}}, Instruction[7], 
                  Instruction[30:25], Instruction[11:8], 1'b0 };  //Branch Instructions
assign Jimm   = { {12{Instruction[31]}}, Instruction[19:12], 
                  Instruction[20], Instruction[30:21], 1'b0 };  //JAL Instruction

assign func3  = Instruction[14:12];
assign func7  = Instruction[31:25];
assign opcode = Instruction[6:0];

Mux5x1 mux_imm (.mux_sel(imm_sel), .m1(imm), .m2(Simm), .m3(Uimm), 
                .m4(Bimm), .m5(Jimm), .mux_out(extended_imm));

endmodule