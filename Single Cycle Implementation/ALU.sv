module ALU  (input logic [31:0] A, B,
            input logic [3:0] ALU_Control,
            output logic [31:0] ALU_Result);
always_comb begin     
    case (ALU_Control)
        4'd0 : ALU_Result = A + B;                      // add
        4'd1 : ALU_Result = A - B;                      // subtarct
        4'd2 : ALU_Result = A << B[4:0];                // sll
        4'd3 : ALU_Result = $signed(A) < $signed(B);    // slt
        4'd4 : ALU_Result = A < B;                      // sltu
        4'd5 : ALU_Result = A ^ B;                      // xor
        4'd6 : ALU_Result = A >> B[4:0];                // srl
        4'd7 : ALU_Result = A >>> B[4:0];               // sra
        4'd8 : ALU_Result = A | B;                      // or
        4'd9 : ALU_Result = A & B;                      // and
        default: ALU_Result = 0;
    endcase
end
endmodule