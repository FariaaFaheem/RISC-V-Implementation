module RiscProcessor(input logic clk, reset);

logic rfwrite, op2_sel;
logic [1:0] op1_sel, wb_sel;
logic [2:0] func3, imm_sel, br_type;
logic [3:0] ALU_Control;
logic [6:0] func7, opcode;

Datapath d1 (.clk(clk), .reset(reset), .rfwrite(rfwrite), .op2_sel(op2_sel), 
		     .op1_sel(op1_sel), .wb_sel(wb_sel), .imm_sel(imm_sel), .br_type(br_type),
			 .ALU_Control(ALU_Control), .func3(func3), 
			 .func7(func7), .opcode(opcode));
			   
Controller c1 (.func3(func3), .opcode(opcode), .func7(func7), 
		       .rfwrite(rfwrite), .op2_sel(op2_sel), .op1_sel(op1_sel), 
			   .wb_sel(wb_sel), .imm_sel(imm_sel), .br_type(br_type), .ALU_Control(ALU_Control));

endmodule