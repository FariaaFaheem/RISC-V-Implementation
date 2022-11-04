module Mux5x1 (input logic [2:0] mux_sel, 
               input logic [31:0] m1, m2, m3, m4, m5,
               output logic [31:0] mux_out);
always_comb begin
	case (mux_sel)
		3'b001 : mux_out = m1;
        3'b010 : mux_out = m2;
        3'b011 : mux_out = m3;
        3'b100 : mux_out = m4;
        3'b101 : mux_out = m5;
        default : mux_out = 32'b0;
	endcase
end
endmodule