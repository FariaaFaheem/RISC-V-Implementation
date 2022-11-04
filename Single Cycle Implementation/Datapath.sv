module Datapath (input logic clk, reset, rfwrite, op2_sel,
				 input logic [1:0] op1_sel, wb_sel,
                 input logic [2:0] imm_sel, br_type,
                 input logic [3:0] ALU_Control, 
				 output [2:0] func3, output [6:0] func7, opcode);

logic cs, wr_en, br_res;
logic [3:0] mask;
logic [4:0] raddr1, raddr2, waddr;
logic [31:0] rdata1, rdata2, wdata, op1, op2, 
extended_imm, PC, Instruction, ALU_Result, Mem_outData, Loaded_Data;

ProgramCounter pc (.clk(clk), .reset(reset), .br_res(br_res), .ALU_Result(ALU_Result), .PC(PC));
InstructionMemory i_mem (.iaddr(PC), .Instruction(Instruction));

Decoder dec (.imm_sel(imm_sel), .Instruction(Instruction), .func3(func3), 
             .raddr1(raddr1), .raddr2(raddr2), .waddr(waddr), 
             .func7(func7), .opcode(opcode), .extended_imm(extended_imm));

RegisterFile regfile (.clk(clk), .rfwrite(rfwrite), 
                      .raddr1(raddr1), .raddr2(raddr2), .waddr(waddr),
                      .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

Mux3x1 mux_op1 (.mux_sel(op1_sel), .m1(rdata1), .m2(32'b0), .m3(PC), .mux_out(op1));
Mux2x1 mux_op2 (.mux_sel(op2_sel), .m1(rdata2), .m2(extended_imm), .mux_out(op2));
Mux3x1 mux_wb  (.mux_sel(wb_sel), .m1(ALU_Result), .m2(Loaded_Data), .m3(PC+4), .mux_out(wdata));

ALU myalu (.A(op1), .B(op2), .ALU_Control(ALU_Control), .ALU_Result(ALU_Result));
BranchCondition br (.br_type(br_type), .br_op1(rdata1), .br_op2(rdata2), .br_res(br_res));
LoadStoreUnit lsu (.func3(func3), .opcode(opcode), .Mem_temp(Mem_outData), .Mem_Addr(ALU_Result),
                   .cs(cs), .wr_en(wr_en), .mask(mask), .LSU_outData(Loaded_Data));

DataMemory dm (.clk(clk), .cs(cs), .wr_en(wr_en), .mask(mask),
               .Mem_Addr(ALU_Result), .Mem_inData(rdata2), .Mem_outData(Mem_outData));
endmodule