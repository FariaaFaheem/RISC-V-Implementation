module Mux4x1 (input logic [1:0] mux_sel, 
               input logic [31:0] m1, m2, m3, m4,
               output logic [31:0] mux_out);
always_comb begin
	case (mux_sel)
		2'b00 : mux_out = m1;
        2'b01 : mux_out = m2;
        2'b10 : mux_out = m3;
        2'b11 : mux_out = m4;
        default : mux_out = m1;
	endcase
	end
endmodule