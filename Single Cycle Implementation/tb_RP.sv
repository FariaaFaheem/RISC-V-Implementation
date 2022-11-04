module tb_RP();

logic clk , reset;

RiscProcessor dut (.clk(clk), .reset(reset));
localparam T = 10; // Clock Period

initial begin
    clk = 0;
    forever #(T/2) clk=~clk;
end

initial begin
reset = 1;
@(posedge clk);
reset = 0;
#200;
$stop;
end

endmodule