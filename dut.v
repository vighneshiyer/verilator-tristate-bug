module dut(input clk);
    wire ts_0, ts_1;

    model m (.clk(clk), .*);

    always @(posedge clk) begin
        $display("%b %b", ts_1, ts_0);
    end
endmodule

module model(input clk, inout ts_0, inout ts_1);
    reg [1:0] drive = 0; // these must be at least 2 bits wide or the bug doesn't exist
    reg [1:0] d = 0;
    always @(posedge clk) begin
        drive <= 2'b11; // this must be a clocked assignment or the bug doesn't exist (combinational assignment = no bug)
        d <= 2'b11;
    end

    assign ts_0 = (drive[0] ? d[0] : 1'bz);
    assign ts_1 = (drive[1] ? d[1] : 1'bz);
endmodule
