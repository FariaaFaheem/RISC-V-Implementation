module FlipFlop #( parameter WIDTH = 32)
                 (input logic clk, reset,
                  input logic [WIDTH-1:0] data_in,
                  output logic [WIDTH-1:0] data_out);
always_ff @(posedge clk) begin
    if (reset)
        data_out <= '0;
    else
        data_out <= data_in;
end
endmodule