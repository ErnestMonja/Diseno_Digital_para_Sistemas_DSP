`timescale 1ns/100ps

module tb_detector_101 ();

reg clk;
reg rst_n;
reg x;
wire y;

detector_101
u_detector_101
(
    .clk  (clk  ),
    .rst_n(rst_n),
    .x    (x    ),
    .y    (y    )
);

// Clock 100 MHz
always #5 clk = ~clk;

initial begin
    $dumpfile("tb_detector_101.vcd");
    $dumpvars(0, tb_detector_101);

    clk = 1'b0;
    rst_n = 1'b0;
    x = 1'b0;

    #100 @(posedge clk);
    rst_n = 1'b1;

    $display("");
    $display("Tiempo  |                                                   ");
    $display("------- +---------------------------------------------------");

    @(posedge clk);
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 1 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 1 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 1 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 1 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b0;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 0 \t y(obtenido) = %0b", $time-1, x, y);
    #1 x = 1'b1;

    @(posedge clk);
    
    #1 $display("  %0dns | x = %0b \t y(esperado) = 1 \t y(obtenido) = %0b", $time-1, x, y);

    $finish;
end
    
endmodule