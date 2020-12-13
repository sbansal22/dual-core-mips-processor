`ifndef OPCODES_V
  `define OPCODES_V 1

  // Instruction Field Widths
  `define W_CPU     32
  `define W_OPCODE   6
  `define W_REG      5
  `define W_SHAMT    5
  `define W_FUNCT    6
  `define W_IMM     16
  `define W_JADDR   26

  // Instruction Fields
  `define FLD_OPCODE 31:26
  `define FLD_RS     25:21
  `define FLD_RT     20:16
  `define FLD_RD     15:11
  `define FLD_IMM    15:0
  `define FLD_ADDR   25:0
  `define FLD_SHAMT  10:6
  `define FLD_FUNCT   5:0
  `define PC_UPPER   31:28

  // Mux Control Widths 
  `define W_EN         1
  `define W_PC_SRC     2
  `define W_IMM_EXT    1
  `define W_ALU_SRC    2
  `define W_REG_SRC    2
  `define W_MEM_CMD    2
  `define W_WORD       2

  // Lots of MUX and Enable Defines
  `define WREN         `W_EN'b1
  `define WDIS         `W_EN'b0

  `define DATA_MEM      `W_EN'b1
  `define CACHE         `W_EN'b0
  
  `define PC_SRC_NEXT  `W_PC_SRC'd0
  `define PC_SRC_JUMP  `W_PC_SRC'd1
  `define PC_SRC_BRCH  `W_PC_SRC'd2
  `define PC_SRC_REGF  `W_PC_SRC'd3

  `define IMM_SIGN_EXT `W_IMM_EXT'b1
  `define IMM_ZERO_EXT `W_IMM_EXT'b0

  `define ALU_SRC_REG  `W_ALU_SRC'd0
  `define ALU_SRC_IMM  `W_ALU_SRC'd1
  `define ALU_SRC_SHA  `W_ALU_SRC'd2

  `define REG_SRC_ALU  `W_REG_SRC'd0
  `define REG_SRC_MEM  `W_REG_SRC'd1
  `define REG_SRC_PC   `W_REG_SRC'd2

  `define MEM_NOP      `W_MEM_CMD'd0
  `define MEM_READ     `W_MEM_CMD'd1
  `define MEM_WRITE    `W_MEM_CMD'd2

  // Registers
  `define REG_0  `W_REG'd0
  `define REG_AT `W_REG'd1
  `define REG_V0 `W_REG'd2
  `define REG_V1 `W_REG'd3
  `define REG_A0 `W_REG'd4
  `define REG_A1 `W_REG'd5
  `define REG_A2 `W_REG'd6
  `define REG_A3 `W_REG'd7
  `define REG_T0 `W_REG'd8
  `define REG_T1 `W_REG'd9
  `define REG_T2 `W_REG'd10
  `define REG_T3 `W_REG'd11
  `define REG_T4 `W_REG'd12
  `define REG_T5 `W_REG'd13
  `define REG_T6 `W_REG'd14
  `define REG_T7 `W_REG'd15
  `define REG_S0 `W_REG'd16
  `define REG_S1 `W_REG'd17
  `define REG_S2 `W_REG'd18
  `define REG_S3 `W_REG'd19
  `define REG_S4 `W_REG'd20
  `define REG_S5 `W_REG'd21
  `define REG_S6 `W_REG'd22
  `define REG_S7 `W_REG'd23
  `define REG_T8 `W_REG'd24
  `define REG_T9 `W_REG'd25
  `define REG_K0 `W_REG'd26
  `define REG_K1 `W_REG'd27
  `define REG_GP `W_REG'd28
  `define REG_SP `W_REG'd29
  `define REG_S8 `W_REG'd30
  `define REG_RA `W_REG'd31

  // FUNCT Codes
  `define F_ADD     `W_OPCODE'b100000
  `define F_ADDU    `W_OPCODE'b100001
  `define F_AND     `W_OPCODE'b100100
  `define F_NOR     `W_OPCODE'b100111
  `define F_OR      `W_OPCODE'b100101
  `define F_SLT     `W_OPCODE'b101010
  `define F_SLTU    `W_OPCODE'b101011
  `define F_SUB     `W_OPCODE'b100010
  `define F_SUBU    `W_OPCODE'b100011
  `define F_XOR     `W_OPCODE'b100110
  `define F_SLL     `W_OPCODE'b000000
  `define F_SLLV    `W_OPCODE'b000100
  `define F_SRA     `W_OPCODE'b000011
  `define F_SRAV    `W_OPCODE'b000111
  `define F_SRL     `W_OPCODE'b000010
  `define F_SRLV    `W_OPCODE'b000110
  `define F_DIV     `W_OPCODE'b011010
  `define F_DIVU    `W_OPCODE'b011011
  `define F_MFHI    `W_OPCODE'b010000
  `define F_MFLO    `W_OPCODE'b010010
  `define F_MTHI    `W_OPCODE'b010001
  `define F_MTLO    `W_OPCODE'b010011
  `define F_MULT    `W_OPCODE'b011000
  `define F_MULTU   `W_OPCODE'b011001
  `define F_BREAK   `W_OPCODE'b001101
  `define F_JALR    `W_OPCODE'b001001
  `define F_JR      `W_OPCODE'b001000
  `define F_SYSCAL  `W_OPCODE'b001100
  
  // RT Field Codes for Branches
  `define RT_BGEZ   `W_REG'b00001
  `define RT_BGEZAL `W_REG'b10001
  `define RT_BGTZ   `W_REG'b00000
  `define RT_BLEZ   `W_REG'b00000
  `define RT_BLTZ   `W_REG'b00000
  `define RT_BLTZAL `W_REG'b10000

  // RS Field Codes for M*C0
  `define RS_MFC0   `W_REG'b00000
  `define RS_MTC0   `W_REG'b00100

  // Op Codes
  // Arithmetic
  // OP_ZERO is the catchall for non-immediate instructions
  `define OP_ZERO   `W_OPCODE'b000000
  `define OP_ONE    `W_OPCODE'b000001
  `define ADD       `W_OPCODE'b000000
  `define ADDI      `W_OPCODE'b001000
  `define ADDIU     `W_OPCODE'b001001
  `define ADDU      `W_OPCODE'b000000
  `define AND       `W_OPCODE'b000000
  `define ANDI      `W_OPCODE'b001100
  `define LUI       `W_OPCODE'b001111
  `define NOR       `W_OPCODE'b000000  
  `define OR        `W_OPCODE'b000000
  `define ORI       `W_OPCODE'b001101
  `define SLT       `W_OPCODE'b000000
  `define SLTI      `W_OPCODE'b001010
  `define SLTIU     `W_OPCODE'b001011
  `define SLTU      `W_OPCODE'b000000
  `define SUB       `W_OPCODE'b000000
  `define SUBU      `W_OPCODE'b000000
  `define XOR       `W_OPCODE'b000000
  `define XORI      `W_OPCODE'b001110
  `define SLL       `W_OPCODE'b000000
  `define SLLV      `W_OPCODE'b000000
  `define SRA       `W_OPCODE'b000000
  `define SRAV      `W_OPCODE'b000000
  `define SRL       `W_OPCODE'b000000
  `define SRLV      `W_OPCODE'b000000
  `define DIV       `W_OPCODE'b000000
  `define DIVU      `W_OPCODE'b000000
  `define MFHI      `W_OPCODE'b000000
  `define MFLO      `W_OPCODE'b000000
  `define MTHI      `W_OPCODE'b000000
  `define MTLO      `W_OPCODE'b000000
  `define MULT      `W_OPCODE'b000000
  `define MULTU     `W_OPCODE'b000000

  // Branch and Jump Instructions
  `define BEQ       `W_OPCODE'b000100
  `define BGEZ      `W_OPCODE'b000001
  `define BGEZAL    `W_OPCODE'b000001
  `define BGTZ      `W_OPCODE'b000111
  `define BLEZ      `W_OPCODE'b000110
  `define BLTZ      `W_OPCODE'b000001
  `define BLTZAL    `W_OPCODE'b000001
  `define BNE       `W_OPCODE'b000101
  `define J_        `W_OPCODE'b000010  
  `define JAL       `W_OPCODE'b000011
  `define JALR      `W_OPCODE'b000000  
  `define JR        `W_OPCODE'b000000
  `define MFC0      `W_OPCODE'b010000
  `define MTC0      `W_OPCODE'b010000
  
  // Load Store Instructions
  `define LB        `W_OPCODE'b100000
  `define LBU       `W_OPCODE'b100100
  `define LH        `W_OPCODE'b100001
  `define LHU       `W_OPCODE'b100101
  `define LW        `W_OPCODE'b100011
  `define SB        `W_OPCODE'b101000
  `define SH        `W_OPCODE'b101001
  `define SW        `W_OPCODE'b101011

  // Special Instructions  
  `define BREAK     `W_OPCODE'b000000
  `define SYSCAL    `W_OPCODE'b000000

`endif
