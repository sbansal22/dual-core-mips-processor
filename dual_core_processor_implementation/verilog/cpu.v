`include "fetch.v"
`include "decode.v"
`include "regfile.v"
`include "alu.v"
`include "memory.v"
`include "mem_dest_control.v"

`timescale 1ns / 1ps

module SINGLE_CYCLE_CPU
  (input clk,
   input rst,

   output [`W_MEM_CMD-1:0] mem_cmd_data,    // mem_cmd = WrEn
   output [`W_CPU-1:0] rd2,                 // data_in = rd2 
   output [`W_CPU-1:0] alu_out,             // data_addr = ALU_out 
   input [`W_CPU-1:0] data_out_data_mem,
   output stop_wire);
  
  reg [`W_PC_SRC-1:0] pc_src;
  reg [`W_EN-1:0] branch_ctrl;
  reg [`W_CPU-1:0] reg_addr;
  reg [`W_JADDR-1:0] jump_addr;
  reg [`W_IMM-1:0] imm_addr;
  reg [`W_CPU-1:0] pc_next;
  reg [`W_CPU-1:0] inst;
  reg [`W_REG-1:0] wa;
  reg [`W_REG-1:0] ra1;
  reg [`W_REG-1:0] ra2;
  reg reg_wen;
  reg [`W_IMM_EXT-1:0] imm_ext;
  reg [`W_IMM-1:0] imm;
  reg [`W_OPCODE-1:0] alu_op;
  reg [`W_MEM_CMD-1:0] mem_cmd;
  reg [`W_MEM_CMD-1:0] mem_cmd_data;
  reg [`W_MEM_CMD-1:0] mem_cmd_cache;
  reg [`W_ALU_SRC-1:0] alu_src;
  reg [`W_REG_SRC-1:0] reg_src;
  reg [`W_CPU-1:0] wd;
  reg [`W_CPU-1:0] rd1;
  reg [`W_CPU-1:0] rd2;
  reg [`W_CPU-1:0] alu_out;
  reg overflow;
  reg isZero;
  reg [`W_CPU-1:0] PC;
  reg [`W_CPU-1:0] instruction;
  reg [`W_CPU-1:0] data_out;
  reg [`W_CPU-1:0] data_out_cache;
  reg [`W_CPU-1:0] MemToReg_mux_out;
  reg [`W_CPU-1:0] alu_input_mux;
  reg stop_wire = 0;
  
  FETCH fetch_inst(clk, 
                   rst, 
                   pc_src, 
                   branch_ctrl, 
                   rd1,
                   jump_addr, 
                   imm, 
                   PC); 

  DECODE decode_inst(inst, 
                     wa, 
                     ra1, 
                     ra2, 
                     reg_wen, 
                     imm_ext, 
                     imm, 
                     jump_addr,
                     alu_op, 
                     pc_src, 
                     mem_cmd, 
                     alu_src, 
                     reg_src);

  REGFILE regfile_inst(clk, 
                       rst, 
                       reg_wen,           // Write Enable 
                       wa,
                       MemToReg_mux_out,  // Write Data Address
                       ra1,               // Register Address 1
                       ra2,               // Register Address 2
                       rd1,               // Data out 1
                       rd2);              // Data out 2

  // alu_src MUX
  always @* begin
    case (alu_src) 
      `ALU_SRC_REG:  begin alu_input_mux = rd2; end
      `ALU_SRC_IMM:  begin
        case(imm_ext)
          `IMM_ZERO_EXT: begin alu_input_mux = {{16{1'b0}}, {imm}}; end
          `IMM_SIGN_EXT: begin alu_input_mux = {{16{imm[15]}}, {imm}}; end
        endcase
        end
      `ALU_SRC_SHA:  begin alu_input_mux = inst[`FLD_SHAMT]; end
      default: begin alu_input_mux = 0; end
    endcase
  end

  ALU alu_inst(alu_op, 
               rd1, 
               alu_input_mux, 
               alu_out, 
               overflow, 
               isZero);

  // beq MUX
  always @* begin
    if (inst[`FLD_OPCODE] == `BEQ) begin
      case(isZero)
        0: begin branch_ctrl = `WDIS; end
        1: begin branch_ctrl = `WREN; end
        default: begin branch_ctrl = `WDIS; end
      endcase
    end 
    if (inst[`FLD_OPCODE] == `BNE) begin
      case(isZero)
        0: begin branch_ctrl = `WREN; end
        1: begin branch_ctrl = `WDIS; end
        default: begin branch_ctrl = `WDIS; end
      endcase
     end
  end

  MEM_DEST_CONTROL mem_control(clk, 
                               rst, 
                               inst, 
                               mem_cmd, 
                               data_out_cache, 
                               data_out_data_mem, 
                               mem_cmd_data, 
                               mem_cmd_cache, 
                               data_out);

  MEMORY stage_MEMORY(clk, 
                      rst, 
                      PC, 
                      inst, 
                      mem_cmd_cache,    // mem_cmd = WrEn
                      rd2,              // data_in = rd2 
                      alu_out,          // data_addr = ALU_out 
                      data_out_cache);


  // MemToReg MUX
  always @* begin
    case (reg_src)
      `REG_SRC_ALU:  begin MemToReg_mux_out = alu_out; end
      `REG_SRC_MEM:  begin MemToReg_mux_out = data_out; end
      `REG_SRC_PC:   begin MemToReg_mux_out = PC + 4; end
      default: begin ; end
    endcase
  end


  //SYSCALL Catch 
  always @(posedge clk) begin
    if (inst[`FLD_OPCODE] == `OP_ZERO && 
        inst[`FLD_FUNCT]  == `F_SYSCAL) begin
        case(rd1) 
          10: begin
              assign stop_wire = 1;
            end
          default:;
        endcase
    end
  end

endmodule
