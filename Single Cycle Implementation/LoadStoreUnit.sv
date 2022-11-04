module LoadStoreUnit (input logic [2:0] func3,
                      input logic [6:0] opcode,
                      input logic [31:0] Mem_temp, Mem_Addr,
                      output logic cs, wr_en,
                      output logic [3:0] mask,
                      output logic [31:0] LSU_outData);


always_comb begin
    //Store Unit
    if (opcode == 7'b0100011) begin
        cs    = 1'b0;
        wr_en = 1'b0;
        // selecting the required size and location for storing
        case(func3[1:0]) 
            2'b00 : begin  // SB
                case(Mem_Addr[1:0])
                    2'b00: begin
                           mask = 4'b0001;
                    end
                    2'b01: begin
                           mask = 4'b0010;
                    end
                    2'b10: begin
                           mask = 4'b0100;
                    end
                    2'b11: begin 
                           mask = 4'b1000;
                    end
                endcase
            end
            2'b01 : begin   // SH
                case(Mem_Addr[1])
                    1'b0: begin
                          mask = 4'b0011;
                    end
                    1'b1: begin
                          mask = 4'b1100;
                    end
                endcase
            end
            2'b10: begin // SW
                   mask = 4'b1111;
            end
            default: mask = 4'b0000;
        endcase
    end

    // Load Unit
    if (opcode == 7'b0000011) begin
        cs    = 1'b0;
        wr_en = 1'b1;
        // selecting the required size of the loaded memory
        case(func3)
            3'b000: begin   // LB
                    case(Mem_Addr[1:0]) 
                        2'b00 : LSU_outData = {{24{Mem_temp[7]}}, {Mem_temp[7:0]}};
                        2'b01 : LSU_outData = {{24{Mem_temp[15]}}, {Mem_temp[15:8]}}; 
                        2'b10 : LSU_outData = {{24{Mem_temp[23]}}, {Mem_temp[23:16]}};
                        2'b11 : LSU_outData = {{24{Mem_temp[31]}}, {Mem_temp[31:24]}}; 
                    endcase
            end 
            3'b001: begin  // LH
                    case(Mem_Addr[1]) 
                        1'b0 : LSU_outData = {{16{Mem_temp[15]}}, {Mem_temp[15:0]}}; 
                        1'b1 : LSU_outData = {{16{Mem_temp[31]}}, {Mem_temp[31:16]}};  
                    endcase
            end    
            3'b010 : LSU_outData = Mem_temp;    // LW
            3'b100: begin  // LBU
                    case(Mem_Addr[1:0]) 
                        2'b00 : LSU_outData = {24'b0, {Mem_temp[7:0]}};  
                        2'b01 : LSU_outData = {24'b0, {Mem_temp[15:8]}};
                        2'b10 : LSU_outData = {24'b0, {Mem_temp[23:16]}};  
                        2'b11 : LSU_outData = {24'b0, {Mem_temp[31:24]}};
                    endcase
            end
            3'b101: begin   // LHU
                    case(Mem_Addr[1]) 
                        1'b0 : LSU_outData = {16'b0, {Mem_temp[15:0]}}; 
                        1'b1 : LSU_outData = {16'b0, {Mem_temp[31:16]}};
                    endcase
            end
            default: LSU_outData = 0;
        endcase
    end
end
endmodule