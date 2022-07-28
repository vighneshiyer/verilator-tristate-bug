verilator: tb/tb
verilator_noopt: tb_noopt/tb
iverilog: tb_ivl
all: verilator verilator_noopt iverilog

tb/tb: dut.v tb.cpp
	verilator -cc --exe --build -O3 -Mdir tb $^ -o tb

tb_noopt/tb: dut.v tb.cpp
	verilator -cc --exe --build -O0 -Mdir tb_noopt $^ -o tb

tb_ivl: dut.v tb.v
	iverilog $^ -o tb_ivl

clean:
	rm -rf obj_dir tb tb_noopt a.out *.vcd tb_ivl

.PHONY: clean verilator verilator_noopt iverilog all
