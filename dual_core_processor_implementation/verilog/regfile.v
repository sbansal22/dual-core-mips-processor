`include "lib/debug.v"
`include "lib/opcodes.v"
`timescale 1ns / 1ps

// Register file two read ports and one write port

module REGFILE
 (input                   clk,
  input                   rst,
  input                   wren,
  input      [`W_REG-1:0] wa,
  input      [`W_CPU-1:0] wd,
  input      [`W_REG-1:0] ra1,
  input      [`W_REG-1:0] ra2,
  output reg [`W_CPU-1:0] rd1,
  output reg [`W_CPU-1:0] rd2);

  /** Storage Element **/
  reg [`W_CPU-1:0] rf [31:0];

  always @(posedge clk,posedge rst) begin
    if (rst) begin
      for(int i = 0; i<32; i=i+1) 
        rf[i] = 0;
    end
    else begin
      if (wren)
        rf[wa] = wd;
      if (`DEBUG_REGFILE) begin
        /* verilator lint_off STMTDLY */
        #2 // Delay slightly to correct print timing issue
        /* verilator lint_on STMTDLY */
        $display("$0  = %x $at = %x $v0 = %x $v1 = %x",rf[`REG_0], rf[`REG_AT],rf[`REG_V0],rf[`REG_V1]);
        $display("$a0 = %x $a1 = %x $a2 = %x $a3 = %x",rf[`REG_A0],rf[`REG_A1],rf[`REG_A2],rf[`REG_A3]);  
        $display("$t0 = %x $t1 = %x $t2 = %x $t3 = %x",rf[`REG_T0],rf[`REG_T1],rf[`REG_T2],rf[`REG_T3]);  
        $display("$t4 = %x $t5 = %x $t6 = %x $t7 = %x",rf[`REG_T4],rf[`REG_T5],rf[`REG_T6],rf[`REG_T7]);  
        $display("$s0 = %x $s1 = %x $s2 = %x $s3 = %x",rf[`REG_S0],rf[`REG_S1],rf[`REG_S2],rf[`REG_S3]);  
        $display("$s6 = %x $s5 = %x $s6 = %x $s7 = %x",rf[`REG_S4],rf[`REG_S5],rf[`REG_S6],rf[`REG_S7]);  
        $display("$t8 = %x $t9 = %x $k0 = %x $k1 = %x",rf[`REG_T8],rf[`REG_T9],rf[`REG_K0],rf[`REG_K1]);  
        $display("$gp = %x $sp = %x $s8 = %x $ra = %x",rf[`REG_GP],rf[`REG_SP],rf[`REG_S8],rf[`REG_RA]);
      end
    end

  end

  assign  rd1 = (ra1 != 0) ? rf[ra1]:0;
  assign  rd2 = (ra2 != 0) ? rf[ra2]:0;

endmodule
