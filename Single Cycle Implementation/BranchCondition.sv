module BranchCondition (input logic [2:0] br_type,
                        input logic [31:0] br_op1, br_op2,
                        output logic br_res);

always_comb begin 
    case(br_type)
        3'd0: br_res = br_op1 == br_op2;                       // BEQ
        3'd1: br_res = br_op1 != br_op2;                       // BNE
        3'd2: br_res = $signed(br_op1) < $signed(br_op2);      // BLT
        3'd3: br_res = $signed(br_op1) >= $signed(br_op2);     // BGE
        3'd4: br_res = br_op1 < br_op2;                        // BLTU
        3'd5: br_res = br_op1 >= br_op2;                       // BGEU
        3'd6: br_res = 1'b1;                                   // JAL, JALR
    default: br_res  = 1'b0;
    endcase
end
endmodule