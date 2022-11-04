module Controller(input logic [31:0] IR_F_DE,
				  output logic rfwrite, op2_sel,
				  output logic [1:0] op1_sel, wb_sel,
				  output logic [2:0] imm_sel, br_type,
				  output logic [3:0] ALU_Control);
logic [2:0] func3;
logic [6:0] func7, opcode;

assign func3  = IR_F_DE[14:12];
assign func7  = IR_F_DE[31:25];
assign opcode = IR_F_DE[6:0];

always_comb begin
	rfwrite     = 1'b0;
	op2_sel     = 1'b0;
	op1_sel     = 2'b00;
	wb_sel      = 2'b00;
	imm_sel     = 3'b000;
	br_type     = 3'b111;
	ALU_Control = 4'b0000;
	
	case(opcode)
		7'b0110011: begin //R Type Instruction
					rfwrite  = 1'b1;
		end
		7'b0010011: begin  //I Type Instruction
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					imm_sel  = 3'b001;
		end	
		7'b0000011: begin  //Load Instruction
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					wb_sel   = 2'b01;
					imm_sel  = 3'b001;
		end
		7'b0100011: begin	//Store Instruction
					op2_sel  = 1'b1;
					imm_sel  = 3'b010;
		end
		7'b0110111: begin	//LUI
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					op1_sel  = 2'b01;
					imm_sel  = 3'b011;
		end
		7'b0010111: begin	//AUIPC
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					op1_sel  = 2'b10;
					imm_sel  = 3'b011;
		end
		7'b1100011: begin	//Branch Instruction
					op2_sel  = 1'b1;
					op1_sel  = 2'b10;
					imm_sel  = 3'b100;
					case(func3)
						3'b000: br_type = 3'b000;	//BEQ
						3'b001: br_type = 3'b001;	//BNE
						3'b100: br_type = 3'b010;	//BLT
						3'b101: br_type = 3'b011;	//BGE
						3'b110: br_type = 3'b100;	//BLTU
						3'b111: br_type = 3'b101;	//BGEU
						default:  br_type = 3'b111;
					endcase
		end
		7'b1101111: begin	//JAL Instruction
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					op1_sel  = 2'b10;
					wb_sel   = 2'b10;
					imm_sel  = 3'b101;
					br_type  = 3'b110;
		end
		7'b1100111: begin	//JALR Instruction
					rfwrite  = 1'b1;
					op2_sel  = 1'b1;
					op1_sel  = 2'b00;
					wb_sel   = 2'b10;
					imm_sel  = 3'b001;
					br_type  = 3'b110;
		end

	endcase
	
	if (opcode == 7'b0110011 || opcode == 7'b0010011) begin
		case(func3)
			3'b000: begin
					ALU_Control = 4'd0; 					// add
					if (func7 == 7'b0100000) 
						ALU_Control = 4'd1; 				// subtract
					end
			3'b001: begin 
					ALU_Control = 4'd2;                		// sll
					end
			3'b010: ALU_Control = 4'd3; 					// slt
			3'b011: ALU_Control = 4'd4;						// sltu
			3'b100: ALU_Control = 4'd5;					    // xor
			3'b101: begin
					if (func7 == 7'b0000000) 
						ALU_Control = 4'd6; 				// srl
					else if (func7 == 7'b0100000) 
						ALU_Control = 4'd7; 				// sra
					end				    
			3'b110: ALU_Control = 4'd8; 					// or
			3'b111: ALU_Control = 4'd9;       				// and
			default: ALU_Control = 0;
		endcase
	end
end
endmodule