#include <verilated.h>
#include <stdint.h>
#include "Vdut.h"
#if VM_TRACE
# include <verilated_vcd_c.h> // Trace file format header
#endif

// Current simulation time
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;
}

int main(int argc, char **argv, char **env) {
    // Prevent unused variable warnings
    if (false && argc && argv && env) {}
    Verilated::debug(0);

    Verilated::commandArgs(argc, argv);
    Vdut* top = new Vdut;

    // If verilator was invoked with --trace
#if VM_TRACE
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("dump.vcd");
#endif

    // Only supported by modern verilator
    // const std::unique_ptr<VerilatedContext> contextp{new VerilatedContext};

    int cycles = 0;
    top->clk = 0;
    // while (contextp->time() < 8 && !contextp->gotFinish()) { // run test for 3 cycles
    while (main_time < 10 && !Verilated::gotFinish()) { // run test for 3 cycles
        top->clk = !top->clk;
        // contextp->timeInc(1);
        main_time++;
        top->eval();
        tfp->dump(main_time);
    }
    top->final();

#if VM_COVERAGE
    VerilatedCov::write("coverage.dat");
#endif
#if VM_TRACE
    if (tfp) { tfp->close(); }
#endif

    delete top;
    exit(0);
}

