`timescale 1ns/100ps

module tb_reg_ce ();

parameter DATA_WIDTH = 8;

wire [DATA_WIDTH-1 : 0] q;
reg [DATA_WIDTH-1 : 0] d;
reg clk;
reg rst_n;
reg ce;

integer i;
reg [9:0] pass_flag;

// Clock 100 MHz
always #5 clk = ~clk;

reg_ce
#(
    .DATA_WIDTH(DATA_WIDTH)
)
u_reg_ce
(
    .q     (q    ),
    .d     (d    ),
    .clk   (clk  ),
    .rst_n (rst_n),
    .ce    (ce   )
);

initial begin
    $dumpfile("tb_reg_ce.vcd");
    $dumpvars(0, tb_reg_ce);

    clk = 0;
    rst_n = 0;
    ce = 1'b0;
    d = {DATA_WIDTH{1'b0}};

    pass_flag = 1'b0;

    #100 
    rst_n = 1;
    ce = 1'b1;

    $display("");
    $display("Tiempo  |                     ");
    $display("------- +---------------------");
    $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time, rst_n, ce, d, q);

    pass_flag[0] = (q == d) ? 1'b1 : 1'b0;
    
    @(posedge clk);
    d = 8'h02;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[1] = (q == d) ? 1'b1 : 1'b0;

    @(posedge clk);
    d = 8'h04;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[2] = (q == d) ? 1'b1 : 1'b0;

    @(posedge clk);
    d = 8'hFF;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[3] = (q == d) ? 1'b1 : 1'b0;

    @(posedge clk);
    ce = 1'b0;
    d = 8'd00;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[4] = (q == d) ? 1'b0 : 1'b1;

    @(posedge clk);
    d = 8'hAA;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[5] = (q == d) ? 1'b0 : 1'b1;

    @(posedge clk);
    d = 8'h1F;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[6] = (q == d) ? 1'b0 : 1'b1;

    #4
    rst_n = 1'b0;
    d = 8'h80;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[7] = (q == d) ? 1'b0 : 1'b1;

    @(posedge clk);
    ce = 1'b1;
    d = 8'h40;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[8] = (q == d) ? 1'b0 : 1'b1;

    @(posedge clk);
    d = 8'h20;
    #1 $display("  %0dns | rst=%0b   ce=%0d \t d=%0h \t q=%0h", $time-1, rst_n, ce, d, q);

    pass_flag[9] = (q == d) ? 1'b0 : 1'b1;

    $display("\n - RESULTADOS -");
    for (i = 0; i < 10; i = i + 1) begin
        if(pass_flag[i])
            $display("Vector %1d: PASS", i+1);
        else
            $display("Vector %1d: FAIL", i+1);
    end
    
    $finish;
end
    
endmodule
