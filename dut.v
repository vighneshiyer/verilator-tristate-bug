module dut(input clk);
    wire ts_0, ts_1, ts_2, ts_3;

    model m (.clk(clk), .*);

    always @(posedge clk) begin
        $display("%b", ts_1);
    end
endmodule

module model(input clk, inout ts_0, inout ts_1, inout ts_2, inout ts_3);
    wire [3:0] drive, d;
    datagen datagen (.clk(clk), .drive(drive), .d(d));
    assign ts_0 = (drive[0] ? d[0] : 1'bz);
    assign ts_1 = (drive[1] ? d[1] : 1'bz);
    assign ts_2 = (drive[2] ? d[2] : 1'bz);
    assign ts_3 = (drive[3] ? d[3] : 1'bz);
endmodule

module datagen(input clk, output [3:0] drive, output [3:0] d);
    reg [3:0] cycle = 0;
    reg [3:0] drive_reg = 0;
    reg [3:0] d_reg = 0;
    always @(posedge clk) begin
        case (cycle)
            4'd1: begin
                drive_reg <= 4'b0010;
                d_reg <= 4'b1110;
            end
            default: begin
                drive_reg <= 4'd0;
                d_reg <= 4'd0;
            end
        endcase
        cycle <= cycle + 1;
    end
    assign drive = drive_reg;
    assign d = d_reg;
endmodule
