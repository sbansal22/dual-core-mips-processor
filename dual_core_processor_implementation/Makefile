################################################################################
# Tools
################################################################################

# -Wall turns on all warnings
# -g2012 selects the 2012 version of iVerilog
IVERILOG=iverilog -Wall -g2012
VVP=vvp
VERILATOR_LINT=verilator_bin --lint-only
MARS_JAR=bin/Mars4_5.jar
MARS=java -jar $(MARS_JAR)

.PHONY: test_%
.PRECIOUS: %.data.hex %.inst.hex

%.inst.hex: asm/%.asm
	$(MARS) db mc CompactTextAtZero dump .text HexText $@ $<
	touch $@

%.data.hex: asm/%.asm
	$(MARS) db mc CompactTextAtZero dump .data HexText $@ $<
	touch $@

cpu.bin: verilog/*.v verilog/lib/*.v
	$(IVERILOG) -o $@ -I verilog verilog/test_cpu.v

lint_%: verilog/*.v verilog/lib/*.v
	$(VERILATOR_LINT) +incdir+verilog verilog/$*.v

test_%: cpu.bin %.inst.hex %.data.hex
	./cpu.bin +mem_inst_fn=$*.inst.hex +mem_data_fn=$*.data.hex +vcd_dump_fn=$*.vcd

clean:
	rm -f *.vcd *.bin *.hex
