/*----------------------------------------------------------------------------
 Unified instruction/data memory for CPU
   - Reads are combinational/instantaneous
   - Writes occur on rising edge of clock
   - Reads/write data are 32-bit (4 byte) words
   - Addresses (PC and data_addr) should be aligned to 32-bit words
     (i.e. the two LSB should be zero)
   - Simulated memory size is 16KiB (rather than the maximum addressible
     2^32 bytes), so the upper 18 bits of the addresses must be zero
----------------------------------------------------------------------------*/

`include "lib/opcodes.v"
`timescale 1ns / 1ps

module DATA_MEMORY
 (input          clk,
  input          rst,
  
  // Read/write port for data 
  input  [`W_MEM_CMD-1:0] mem_cmd_1,
  input  [`W_CPU-1:0]     data_in_1,
  input  [`W_CPU-1:0]     data_addr_1,
  output [`W_CPU-1:0]     data_out_1,
  
  input  [`W_MEM_CMD-1:0] mem_cmd_2,
  input  [`W_CPU-1:0]     data_in_2,
  input  [`W_CPU-1:0]     data_addr_2,
  output [`W_CPU-1:0]     data_out_2);

  // 16KiB memory, organized as 4096 element array of 32-bit words
  reg [`W_CPU-1:0] mem [4095:0];
  // Alternative: 16KiB memory, organized as 16384 element array of bytes
  //   This is closer to the physical implementation but makes the Verilog
  //   messier since you need to access multiple bytes at once.
  // reg [7:0] mem [2**14-1:0];


  // Simplified memory "read ports"
  assign data_out_1 = mem[ data_addr_1[13:2] ];
  assign data_out_2 = mem[ data_addr_2[13:2] ];
  // Note: Discards the low 2 bits of the address (which should be zero)
  // since we implemented the memory as an array of words instead of bytes.
  // Discards upper 18 bits of address (which should be zero) because memory
  // is only 16 KiB (smaller than maximum addressible 2^32 bytes).

  // Data write port
  always @(posedge clk) begin
      if (mem_cmd_1 == `MEM_WRITE) begin
          mem[ data_addr_1[13:2] ] = data_in_1;
      end
  end
  
  // Data write port
  always @(posedge clk) begin
      if (mem_cmd_2 == `MEM_WRITE) begin
          mem[ data_addr_2[13:2] ] = data_in_2;
      end
  end
  
  // Non-synthesizable debugging code for checking assertions about addresses
  always @(posedge clk) begin // if either of the first two bits aren't 0 you are doing something wrong
    if (mem_cmd_1 == `MEM_READ) begin
      if (| data_addr_1[1:0]) begin	// Lower address bits != 00
        $display("Warning: misaligned data_addr_1 access, truncating: %h", data_addr_1);      end
      if (| data_addr_1[31:14]) begin  // Upper address bits non-zero
        $display("Error: data_addr_1 outside implemented memory range: %h", data_addr_1);
        $stop();
      end
    end
  end

    // Non-synthesizable debugging code for checking assertions about addresses
  always @(posedge clk) begin // if either of the first two bits aren't 0 you are doing something wrong
    if (mem_cmd_2 == `MEM_READ) begin
      if (| data_addr_2[1:0]) begin	// Lower address bits != 00
        $display("Warning: misaligned data_addr_2 access, truncating: %h", data_addr_2);      end
      if (| data_addr_2[31:14]) begin  // Upper address bits non-zero
        $display("Error: data_addr_2 outside implemented memory range: %h", data_addr_2);
        $stop();
      end
    end
  end
  
endmodule