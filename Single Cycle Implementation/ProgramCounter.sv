module ProgramCounter(input logic clk, reset, br_res,
					  input logic [31:0] ALU_Result,
                      output logic [31:0] PC); 

always @(posedge clk) begin 
	if (reset) begin
		PC <= 32'd0;
    end
	else begin
		PC <= br_res ? ALU_Result : PC + 32'd4;
	end
end
endmodule