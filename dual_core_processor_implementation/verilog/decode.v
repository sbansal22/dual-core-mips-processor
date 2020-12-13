`include "lib/opcodes.v"
`include "lib/debug.v"
`timescale 1ns / 1 ps

module DECODE 
 (input [`W_CPU-1:0] inst,
  
  // Register File control
  output reg [`W_REG-1:0]     wa,      // Register Write Address 
  output reg [`W_REG-1:0]     ra1,     // Register Read Address 1
  output reg [`W_REG-1:0]     ra2,     // Register Read Address 2
  output reg                  reg_wen, // Register Write Enable
  // Immediate
  output reg [`W_IMM_EXT-1:0] imm_ext, // 1-Sign or 0-Zero extend
  output reg [`W_IMM-1:0]     imm,     // Immediate Field
  // Jump Address
  output reg [`W_JADDR-1:0]   addr,    // Jump Addr Field
  // ALU Control
  output reg [`W_FUNCT-1:0]   alu_op,  // ALU OP
  // Muxing
  output reg [`W_PC_SRC-1:0]  pc_src,  // PC Source
  output reg [`W_MEM_CMD-1:0] mem_cmd, // Mem Command
  output reg [`W_ALU_SRC-1:0] alu_src, // ALU Source
  output reg [`W_REG_SRC-1:0] reg_src);// Mem to Reg

  // Unconditionally pull some instruction fields
  wire [`W_REG-1:0] rs; 
  wire [`W_REG-1:0] rt; 
  wire [`W_REG-1:0] rd; 
  assign rs   = inst[`FLD_RS];
  assign rt   = inst[`FLD_RT];
  assign rd   = inst[`FLD_RD];
  assign imm  = inst[`FLD_IMM];
  assign addr = inst[`FLD_ADDR];


  always @(inst) begin
    if (`DEBUG_DECODE) 
      /* verilator lint_off STMTDLY */
      #1 // Delay Slightly
      $display("op = %x rs = %x rt = %x rd = %x imm = %x addr = %x",inst[`FLD_OPCODE],rs,rt,rd,imm,addr);
      /* verilator lint_on STMTDLY */
  end

  always @* begin
    case(inst[`FLD_OPCODE])
      `OP_ZERO: begin
        // OP-CODE = b000000 -> Function Code
        case(inst[`FLD_FUNCT])
          `F_ADD: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_ADD;             // ALU OP
            end
          `F_ADDU: begin                    // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_ADDU;            // ALU OP
            end
          `F_AND: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_AND;             // ALU OP
            end
          `F_NOR: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_NOR;             // ALU OP
            end
          `F_OR: begin                      // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_OR;              // ALU OP
            end
          `F_SLT: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SLT;             // ALU OP
            end
          `F_SLTU: begin                    // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SLTU;            // ALU OP
            end
          `F_SUB: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SUB;             // ALU OP
            end
          `F_SUBU: begin                    // R-type
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SUBU;            // ALU OP
            end
          `F_SLL: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rt;                     // Register Read Address 1
              ra2 = rs;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_SHA;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SLL;             // ALU OP          
            end
          `F_SRL: begin                     // R-type
              wa = rd;                      // Register Write Address
              ra1 = rt;                     // Register Read Address 1
              ra2 = rs;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_SHA;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SRL;             // ALU OP
            end
          `F_SYSCAL: begin
            ra1 = `REG_V0;                  // Register Read Address 1
            ra2 = `REG_A0;
          end
          `F_SRAV: begin
              wa = rd;                      // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = rt;                     // Register Read Address 2
              reg_wen = `WREN;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_ALU;       // Mem to Reg 
              pc_src  = `PC_SRC_NEXT;       // PC Source 
              alu_op  = `F_SRAV;            // ALU OP
          end
          `F_JR: begin
              wa = `REG_0;                  // Register Write Address
              ra1 = rs;                     // Register Read Address 1
              ra2 = `REG_0;                 // Register Read Address 1
              reg_wen = `WDIS;              // Register Write Enable
              mem_cmd = `MEM_NOP;           // Mem Command
              alu_src = `ALU_SRC_REG;       // ALU Source 
              reg_src = `REG_SRC_PC;        // Mem to Reg 
              pc_src  = `PC_SRC_REGF;       // PC Source 
          end
        endcase
      end
      // OP-CODE = b000001 -> Function Code
      // OP-CODE OPERATIONS
      `ADDI: begin                      // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ADDI;              // ALU OP
        end
      `ADDIU: begin                     // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ADDIU;             // ALU OP
        end
      `ANDI: begin                      // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_ZERO_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ANDI;              // ALU OP
        end
      `ORI: begin                       // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_ZERO_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ORI;               // ALU OP
        end
        `XORI: begin                    // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_ZERO_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `XORI;              // ALU OP
        end
      `SLTI: begin                      // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `SLTI;              // ALU OP
        end
      `SLTIU: begin                     // I-type
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `SLTIU;             // ALU OP
        end
      `J_: begin
          wa = `REG_0;                  // Register Write Address
          ra1 = `REG_0;                 // Register Read Address 1
          ra2 = `REG_0;                 // Register Read Address 1
          reg_wen = `WDIS;              // Register Write Enable
          imm_ext = `IMM_ZERO_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_REG;       // ALU Source 
          reg_src = `REG_SRC_PC;        // Mem to Reg 
          pc_src  = `PC_SRC_JUMP;       // PC Source 
        end
      `BEQ: begin
          //wa = rt;                    // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          ra2 = rt;                     // Register Read Address 2
          reg_wen = `WDIS;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_REG;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_BRCH;       // PC Source 
          alu_op  = `F_SUB;             // ALU OP
       end
      `BNE: begin
          ra1 = rs;                     // Register Read Address 1
          ra2 = rt;                     // Register Read Address 2
          reg_wen = `WDIS;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_NOP;           // Mem Command
          alu_src = `ALU_SRC_REG;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_BRCH;       // PC Source 
          alu_op  = `F_SUB;             // ALU OP
        end
      `JAL: begin
          wa = `REG_RA;                 // Register Write Address
          ra1 = `REG_0;                 // Register Read Address 1
          ra2 = `REG_0;                 // Register Read Address 1
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_ZERO_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_WRITE;         // Mem Command
          alu_src = `ALU_SRC_REG;       // ALU Source 
          reg_src = `REG_SRC_PC;        // Mem to Reg 
          pc_src  = `PC_SRC_JUMP;       // PC Source 
      end
      `LW: begin
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          ra2 = rt;                     // Register Read Address 2
          reg_wen = `WREN;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_READ;          // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_MEM;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ADDI;              // ALU OP
       end
      `SW: begin
          wa = rt;                      // Register Write Address
          ra1 = rs;                     // Register Read Address 1
          ra2 = rt;                     // Register Read Address 2
          reg_wen = `WDIS;              // Register Write Enable
          imm_ext = `IMM_SIGN_EXT;      // 1-Sign or 0-Zero extend
          mem_cmd = `MEM_WRITE;         // Mem Command
          alu_src = `ALU_SRC_IMM;       // ALU Source 
          reg_src = `REG_SRC_ALU;       // Mem to Reg 
          pc_src  = `PC_SRC_NEXT;       // PC Source 
          alu_op  = `ADDI;              // ALU OP
        end
      default: begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WDIS;
        imm_ext = `IMM_ZERO_EXT; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT;  alu_op  = inst[`FLD_FUNCT]; end
    endcase
  end
endmodule
