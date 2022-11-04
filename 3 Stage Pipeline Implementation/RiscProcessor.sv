module RiscProcessor(input logic clk, reset);

logic rfwrite, op2_sel;
logic [1:0] op1_sel, wb_sel;
logic [2:0] imm_sel, br_type;
logic [3:0] ALU_Control;
logic [31:0] IR_F_DE;

Datapath d1 (.clk(clk), .reset(reset), .rfwrite(rfwrite), .op2_sel(op2_sel), 
		     .op1_sel(op1_sel), .wb_sel(wb_sel), .imm_sel(imm_sel), .br_type(br_type),
			 .ALU_Control(ALU_Control), .IR_F_DE(IR_F_DE));
			   
Controller c1 (.IR_F_DE(IR_F_DE), .rfwrite(rfwrite), .op2_sel(op2_sel), .op1_sel(op1_sel), 
			   .wb_sel(wb_sel), .imm_sel(imm_sel), .br_type(br_type), .ALU_Control(ALU_Control));

endmodule