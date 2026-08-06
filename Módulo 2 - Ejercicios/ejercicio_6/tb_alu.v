// Los resultados del latch estan en
// ~/openlane2/designs/alu_bad/runs/RUN_2026-08-05_12-26-27/06-yosys-synthesis/reports/latch.rpt

`timescale 1ns/100ps

module tb_alu ();

parameter DATA_WIDTH = 8;
parameter OP_WIDTH = 2;

reg [DATA_WIDTH-1 : 0] a;
reg [DATA_WIDTH-1 : 0] b;
reg [OP_WIDTH-1 : 0] op;
wire [DATA_WIDTH-1 : 0] y_bad;
wire [DATA_WIDTH-1 : 0] y_fix1;
wire [DATA_WIDTH-1 : 0] y_fix2;

integer i;
integer j;

alu_bad
#(
    .DATA_WIDTH(DATA_WIDTH),
    .OP_WIDTH(OP_WIDTH)
)
u_alu_bad
(
    .a(a),
    .b(b),
    .op(op),
    .y(y_bad)
);

alu_fix1
#(
    .DATA_WIDTH(DATA_WIDTH),
    .OP_WIDTH(OP_WIDTH)
)
u_alu_fix1
(
    .a(a),
    .b(b),
    .op(op),
    .y(y_fix1)
);

alu_fix2
#(
    .DATA_WIDTH(DATA_WIDTH),
    .OP_WIDTH(OP_WIDTH)
)
u_alu_fix2
(
    .a(a),
    .b(b),
    .op(op),
    .y(y_fix2)
);

initial begin
    $dumpfile("tb_alu.vcd");
    $dumpvars(0, tb_alu);

    a = 8'h0;
    b = 8'h0;
    op = 2'b00;

    $display("");
    $display("Tiempo  |                                                   ");
    $display("------- +---------------------------------------------------");
    $monitor("  %3dns | a = %2h \t b = %2h \t op = %1h \t y(latch) = %2h \t y(default) = %2h \t y(pre-assign) = %2h", $time, a, b, op, y_bad, y_fix1, y_fix2);

    for (i = 0; i < 4; i = i + 1) begin
        for (j = 0; j < 64; j = j + 1) begin
            #10
            op = i;
            a = 8'h00 + j;
            b = 8'h01 + j;
        end
    end

    #10
    $finish;
end
    
endmodule