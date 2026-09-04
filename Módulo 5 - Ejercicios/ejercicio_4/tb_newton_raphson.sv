`timescale 1ns/100ps

module tb_newton_raphson ();

parameter NB = 16;
parameter NBF = 16;
parameter NB_MULT = 16; // 16x16
parameter N_LUT = 8;
parameter N_ITER = 7;

// in
logic clk;
logic rst;
logic start;
logic [$clog2(N_LUT-1) - 1 : 0] lut_sel;
logic [NB-1 : 0] a;
// out
logic done;
logic [NB-1 : 0] y_o;
// test
logic [NB-1 : 0] y_o_test;
real a_real;
integer i;

newton_raphson #(
    .NB     (NB     ),
    .NBF    (NBF    ),
    .NB_MULT(NB_MULT),
    .N_LUT  (N_LUT  ),
    .N_ITER (N_ITER )
) 
dut (
    .clk    (clk    ),
    .rst    (rst    ),
    .start  (start  ),
    .lut_sel(lut_sel),
    .a      (a      ),
    .done   (done   ),
    .y_o    (y_o    )
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_newton_raphson.vcd");
    $dumpvars(0, tb_newton_raphson);

    clk = 1'b0;
    rst = 1'b1;
    start = 1'b0;
    lut_sel = 'd0;
    a = 'd0;
    y_o_test = 'd0;

    #100;
    @(posedge clk);
    rst = 1'b0;
    start = 1'b1;
    lut_sel = 3'd4;
    a_real = 0.625;
    a = a_real * 2**NBF;
    y_o_test = 1/a_real * 2**(NBF-2);

    @(posedge clk);
    start = 1'b0;

    @(posedge done);
    @(posedge clk);
    start = 1'b1;
    a_real = 0.555;
    a = a_real * 2**NBF;
    y_o_test = 1/a_real * 2**(NBF-2);

    @(posedge clk);
    start = 1'b0;

    @(posedge done);
    @(posedge clk);
    start = 1'b1;
    a_real = 0.5;
    a = a_real * 2**NBF;
    y_o_test = 1/a_real * 2**(NBF-2);

    @(posedge clk);
    start = 1'b0;

    @(posedge done);
    @(posedge clk);
    start = 1'b1;
    a_real = 0.9;
    a = a_real * 2**NBF;
    y_o_test = 1/a_real * 2**(NBF-2);

    @(posedge clk);
    start = 1'b0;

    @(posedge done);
    @(posedge clk);
    start = 1'b1;
    a_real = 0.999;
    a = a_real * 2**NBF;
    y_o_test = 1/a_real * 2**(NBF-2);

    @(posedge clk);
    start = 1'b0;
    @(posedge done);
    #100
    @(posedge clk);

    $finish;
end

endmodule