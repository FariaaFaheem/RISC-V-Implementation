module Datapath (input logic clk, reset, rfwrite, op2_sel,
				 input logic [1:0] op1_sel, wb_sel,
                 input logic [2:0] imm_sel, br_type,
                 input logic [3:0] ALU_Control, 
				 output logic [31:0] IR_F_DE);

logic cs, wr_en, br_res, RF_DE_MW, BR_DE_MW;
logic [1:0] WBSEL_DE_MW;
logic [3:0] mask;
logic [31:0] rdata1, rdata2, wdata, op1, op2, 
extended_imm, PC, Instruction, ALU_Result, Mem_outData, Loaded_Data,
PC_F_DE, PC_DE_MW, ALU_DE_MW, WD_DE_MW, IR_DE_MW;

ProgramCounter pc (.clk(clk), .reset(reset), .br_res(BR_DE_MW), .ALU_Result(ALU_DE_MW), .PC(PC));
InstructionMemory i_mem (.iaddr(PC), .Instruction(Instruction));

FlipFlop #(32) pc_fde (.clk(clk), .reset(reset), .data_in(PC), .data_out(PC_F_DE));
FlipFlop #(32) ir_fde (.clk(clk), .reset(reset), .data_in(Instruction), .data_out(IR_F_DE));

FlipFlop #(32) pc_demw (.clk(clk), .reset(reset), .data_in(PC_F_DE), .data_out(PC_DE_MW));
FlipFlop #(32) alu_demw (.clk(clk), .reset(reset), .data_in(ALU_Result), .data_out(ALU_DE_MW));
FlipFlop #(32) wd_demw (.clk(clk), .reset(reset), .data_in(rdata2), .data_out(WD_DE_MW));
FlipFlop #(32) ir_demw (.clk(clk), .reset(reset), .data_in(IR_F_DE), .data_out(IR_DE_MW));
FlipFlop #(2) wbsel_demw (.clk(clk), .reset(reset), .data_in(wb_sel), .data_out(WBSEL_DE_MW));
FlipFlop #(1) rf_demw (.clk(clk), .reset(reset), .data_in(rfwrite), .data_out(RF_DE_MW));
FlipFlop #(1) br_demw (.clk(clk), .reset(reset), .data_in(br_res), .data_out(BR_DE_MW));

Immediate dec (.imm_sel(imm_sel), .Instruction(IR_F_DE), .extended_imm(extended_imm));

RegisterFile regfile (.clk(clk), .rfwrite(RF_DE_MW), 
                      .raddr1(IR_F_DE[19:15]), .raddr2(IR_F_DE[24:20]), .waddr(IR_DE_MW[11:7]),
                      .wdata(wdata), .rdata1(rdata1), .rdata2(rdata2));

Mux3x1 mux_op1 (.mux_sel(op1_sel), .m1(rdata1), .m2(32'b0), .m3(PC_F_DE), .mux_out(op1));
Mux2x1 mux_op2 (.mux_sel(op2_sel), .m1(rdata2), .m2(extended_imm), .mux_out(op2));
Mux3x1 mux_wb  (.mux_sel(WBSEL_DE_MW), .m1(ALU_DE_MW), .m2(Loaded_Data), .m3(PC_DE_MW + 4), .mux_out(wdata));

ALU myalu (.A(op1), .B(op2), .ALU_Control(ALU_Control), .ALU_Result(ALU_Result));
BranchCondition br (.br_type(br_type), .br_op1(rdata1), .br_op2(rdata2), .br_res(br_res));

LoadStoreUnit lsu (.func3(IR_DE_MW[14:12]), .opcode(IR_DE_MW[6:0]), .Mem_temp(Mem_outData), .Mem_Addr(ALU_DE_MW),
                   .cs(cs), .wr_en(wr_en), .mask(mask), .LSU_outData(Loaded_Data));
DataMemory dm (.clk(clk), .cs(cs), .wr_en(wr_en), .mask(mask),
               .Mem_Addr(ALU_DE_MW), .Mem_inData(WD_DE_MW), .Mem_outData(Mem_outData));
endmodule