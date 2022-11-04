module Mux2x1 (input logic mux_sel, 
               input logic [31:0] m1, m2,
               output logic [31:0] mux_out);
always_comb begin
	case (mux_sel)
		1'b0 : mux_out = m1;
        1'b1 : mux_out = m2;
        default : mux_out = m1;
	endcase
	end
endmodule