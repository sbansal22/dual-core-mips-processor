`include "lib/debug.v"
`include "lib/opcodes.v"
`timescale 1ns / 1ps

// Register file two read ports and one write port

module MEM_DEST_CONTROL
 (input      clk,
  input      rst,
  input      [`W_CPU-1:0] inst,
  input      [`W_MEM_CMD-1:0] mem_cmd,
  input      [`W_CPU-1:0] data_out_cache,
  input      [`W_CPU-1:0] data_out_data_mem,
  output     [`W_MEM_CMD-1:0] mem_cmd_data,
  output     [`W_MEM_CMD-1:0] mem_cmd_cache,
  output     [`W_CPU-1:0] data_out);

  reg [`W_MEM_CMD-1:0] mem_cmd_data;
  reg [`W_MEM_CMD-1:0] mem_cmd_cache;
  reg [`W_CPU-1:0] data_out;
  reg [`W_MEM_CMD-1:0] mem_dest = `CACHE;

    // memory control
  always @(posedge clk) begin
    if ((inst[`FLD_OPCODE] == `LW) || 
        (inst[`FLD_OPCODE]  == `SW)) begin
          case(inst[`FLD_RT])
            `REG_T4: begin  // cache if $t0 - $t3
              mem_dest = `CACHE;
            end
            `REG_T5: begin  // data_mem if $t4 - $t7
              mem_dest = `DATA_MEM;
            end
            `REG_T6: begin  // data_mem if $t4 - $t7
              mem_dest = `DATA_MEM;
            end
            `REG_T7: begin  // data_mem if $t4 - $t7
              mem_dest = `DATA_MEM;
            end
            default: mem_dest = `CACHE;
          endcase
    end
  end

  // Cache or Data Memory MUX
  always @* begin
    case (mem_dest)
      `CACHE:     begin 
                    mem_cmd_cache = mem_cmd; 
                    mem_cmd_data = `MEM_NOP;
                    data_out = data_out_cache;
                  end
      `DATA_MEM:  begin 
                    mem_cmd_data = mem_cmd; 
                    mem_cmd_cache = `MEM_NOP;
                    data_out = data_out_data_mem;
                  end
        default: begin                     
                  mem_cmd_cache = mem_cmd; 
                  mem_cmd_data = `MEM_NOP; 
                  data_out = data_out_cache;
                 end
    endcase
  end

endmodule
