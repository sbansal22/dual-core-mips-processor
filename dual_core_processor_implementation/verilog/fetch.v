`include "lib/opcodes.v"
`include "lib/debug.v"
`timescale 1ns / 1ps

module FETCH 
 (input                      clk,
  input                      rst,
  input      [`W_PC_SRC-1:0] pc_src,
  input      [`W_EN-1:0]     branch_ctrl,
  input      [`W_CPU-1:0]    reg_addr,
  input      [`W_JADDR-1:0]  jump_addr,
  input      [`W_IMM-1:0]    imm_addr,
  output reg [`W_CPU-1:0]    pc_next);

  reg [`W_CPU-1:0] branch_addr;
  assign branch_addr = {{14{imm_addr[15]}},{imm_addr},{2'b0}};
  reg [`W_CPU-1:0] pc_4;
  assign pc_4 = pc_next + 4'b0100; 

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      pc_next <= `W_CPU'd0;
    end
    else begin
      case(pc_src)
        `PC_SRC_NEXT: begin pc_next <= pc_next + 4; end 
        `PC_SRC_JUMP: begin pc_next <= {{pc_4[`W_CPU-1:`W_CPU-4]}, {jump_addr}, {2'b0}}; end
        `PC_SRC_BRCH: begin 
          case(branch_ctrl)
            `WREN: begin pc_next <= pc_next + 4 + branch_addr; end
            `WDIS: begin pc_next <= pc_next + 4; end
            default: begin pc_next <= pc_next + 4; end
          endcase
        end
        `PC_SRC_REGF: begin pc_next <= reg_addr; end
        default     : pc_next <= pc_next + 4; 
      endcase
      if (`DEBUG_PC && ~rst) 
        $display("-- PC, PC/4 = %x, %d",pc_next,pc_next/4); 
    end
  end
endmodule

