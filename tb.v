`timescale 1ns/1ps

module tb();
    reg clk = 0;
    always #1 clk = !clk;

    dut dut (.clk(clk));

    initial begin
        repeat (4) @(posedge clk);
        $finish();
    end
endmodule
