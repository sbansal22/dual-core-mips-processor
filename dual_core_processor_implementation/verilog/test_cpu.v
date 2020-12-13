`include "cpu.v"
`include "data_memory.v"
`timescale 1ns / 1ps

//------------------------------------------------------------------------
// Simple fake CPU testbench sequence
//------------------------------------------------------------------------

module cpu_test ();

  reg clk;
  reg reset;

  reg [`W_MEM_CMD-1:0] mem_cmd_1;
  reg [`W_CPU-1:0] data_in_1;
  reg [`W_CPU-1:0] data_addr_1;
  reg [`W_CPU-1:0] data_out_1;
  reg stop_wire_1;

  reg [`W_MEM_CMD-1:0] mem_cmd_2;
  reg [`W_CPU-1:0] data_in_2;
  reg [`W_CPU-1:0] data_addr_2;
  reg [`W_CPU-1:0] data_out_2;
  reg stop_wire_2;

  // Clock generation
  initial clk=0;
  always #10 clk = !clk;

  // Instantiate fake CPU

  DATA_MEMORY data_mem(clk,reset,mem_cmd_1,data_in_1,data_addr_1,data_out_1,mem_cmd_2,data_in_2,data_addr_2,data_out_2);

  SINGLE_CYCLE_CPU cpu1(clk,reset,mem_cmd_1,data_in_1,data_addr_1,data_out_1,stop_wire_1);
  SINGLE_CYCLE_CPU cpu2(clk,reset,mem_cmd_2,data_in_2,data_addr_2,data_out_2,stop_wire_2);
  
  always @* begin  
    if ((stop_wire_1 == 1) && 
        (stop_wire_2 == 1)) begin
          $display("Core 0: a0 = %x",cpu1.regfile_inst.rf[`REG_A0]);
          $display("Core 1: a0 = %x",cpu2.regfile_inst.rf[`REG_A0]);
          $display("Both Cores Have Exited");
          $finish; // Replace with wirte to indicate CPU is done
    end
  end

  // Filenames for memory images and VCD dump file
  reg [1023:0] mem_inst_fn;
  reg [1023:0] mem_data_fn; //shared data memory 
  reg [1023:0] vcd_dump_fn;
  reg init_data = 1;      // Initializing .data segment is optional
  integer multicore = 2;

  // Test sequence
  initial begin
    $display("Number of cores: %d", multicore); //try %D or %0d if %f doesn't work
    // Get command line arguments for memory image(s) and VCD dump file
    //   http://iverilog.wikia.com/wiki/Simulation
    //   http://www.project-veripage.com/plusarg.php
    if (! $value$plusargs("mem_inst_fn=%s", mem_inst_fn)) begin
      $display("ERROR: provide +mem_inst_fn=[path to .inst.hex memory image] argument");
      $finish();
    end
    if (! $value$plusargs("mem_data_fn=%s", mem_data_fn)) begin
      $display("INFO: +mem_data_fn=[path to .data.hex memory image] argument not provided; data memory segment uninitialized");
      init_data = 0;
    end
    if (! $value$plusargs("vcd_dump_fn=%s", vcd_dump_fn)) begin
      $display("ERROR: provide +dump_fn=[path for VCD dump] argument");
      $finish();
    end

    // Load CPU memory from (assembly) dump files
    // Assumes compact memory map, _word_ addressed memory implementation
    //   -> .text segment starts at word address 0
    //   -> .data segment starts at word address 2048 (byte address 0x2000)
    $readmemh(mem_inst_fn, cpu1.stage_MEMORY.mem, 0,2047);
    $writememh(mem_inst_fn, cpu1.stage_MEMORY.mem, 0,2047);

    $readmemh(mem_inst_fn, cpu2.stage_MEMORY.mem, 0,2047);
    $writememh(mem_inst_fn, cpu2.stage_MEMORY.mem, 0,2047);

    if (init_data)
      $readmemh(mem_data_fn, cpu1.stage_MEMORY.mem, 2048,4095);
      $readmemh(mem_data_fn, cpu2.stage_MEMORY.mem, 2048,4095);
      $readmemh(mem_data_fn, data_mem.mem,2048,4095);
      $writememh(mem_data_fn, cpu1.stage_MEMORY.mem, 2048,4095);
      $writememh(mem_data_fn, cpu2.stage_MEMORY.mem, 2048,4095); 
      $writememh(mem_data_fn, data_mem.mem,0,4095);

    // 0x2000 = 2048
    cpu1.stage_MEMORY.mem[2048] = 16'b0;
    cpu2.stage_MEMORY.mem[2048] = 16'b1;

    // Dump waveforms to file
    // Note: arrays (e.g. memory) are not dumped by default
    $dumpfile(vcd_dump_fn);
    $dumpvars(vcd_dump_fn);

    // Assert reset pulse
    reset = 0; #5;
    reset = 1; #10;
    reset = 0; #10;

    // End execution after some time delay - adjust to match your program
    // or use a smarter approach like looking for an exit syscall or the
    // PC to be the value of the last instruction in your program.
    /* verilator lint_off STMTDLY */
    #6000
    /* verilator lint_on STMTDLY */
    //$display("%x", data_mem.mem[2048]);
    //$display("%x", data_mem.mem[2049]);
    $display("Are you sure you should be running this long?");
    $finish();
    end

endmodule


  /* control loop 
  what's the best/easiest way to do an interrupt control?

  interrupt: 1 = cpu1 is using mem, 0 = cpu1 is not using mem
  if cpu1 is not being used, use cpu2

    if using mem: 
      int = 1
    else: 
      int = 0

    if cpu2 needs mem: 
      while int = 1:
        wait 
      instuction = instruction 
 
  indicators? reserve registers as flags (4 instruction cycles) 
    if locked: 
      wait 
    else: 
      turn flag off 
      do mem stuff 

  should we have a single instruction memory? 
    how do we tell it which cpu to go to? 
    cpu encoded instructions? 
    demux? can we still do parallel? 
    can we send instructions from cpu1 to cpu2? 
    where can we put the demux to load separate sub instruction memories
    multi-threading in MIPS?

    1) demux after cpu1 
    2) demux after inst mem with control coming from a flag
    3) from cpu1 to cpu2 
    4) two separate inst memories being preloaded
  */
