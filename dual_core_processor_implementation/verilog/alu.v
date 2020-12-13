`include "lib/opcodes.v"
`timescale 1ns / 1ps


module ALU
 (input      [`W_OPCODE-1:0]  alu_op,
  input      [`W_CPU-1:0]     A,
  input      [`W_CPU-1:0]     B,
  output reg [`W_CPU-1:0]     R,
  output reg overflow,
  output reg isZero);

  // MUX
  always @* begin
    case (alu_op)
      `F_ADD:   begin R = A + B; end 
      `F_ADDU:  begin R = A + B; end     
      `F_AND:   begin R = A & B; end      
      `F_NOR:   begin R = A ~| B; end    
      `F_OR:    begin R = A | B; end    
      `F_SLT:   begin R = A < B; end     
      `F_SLTU:  begin R = A < B; end    
      `F_SUB:   begin R = A - B; end    
      `F_SUBU:  begin R = A - B; end 
      `F_SLL:   begin R = A << B; end   
      `F_SRAV:  begin R = B >> A; end
      `F_SRL:   begin R = A >> B; end  
      `F_SRLV:  begin R = A >> B; end 
      `ADDI:    begin R = A + B; end    
      `ADDIU:   begin R = A + B; end    
      `ANDI:    begin R = A & B; end    
      `ORI:     begin R = A | B; end
      `XORI:    begin R = A ^ B; end     
      `SLTI:    begin R = A < B; end    
      `SLTIU:   begin R = A < B; end    
      default: begin R = 0; end
    endcase
  end

  assign isZero = (R == 1'b0);
  assign overflow = (A[`W_CPU-1] & B[`W_CPU-1] & ~R[`W_CPU-1]) | (~A[`W_CPU-1] & ~B[`W_CPU-1] & R[`W_CPU-1]);

endmodule
