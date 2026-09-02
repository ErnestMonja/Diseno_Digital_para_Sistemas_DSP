`timescale 1ns / 1ps

module tb_cordic_folded;

    logic clk;
    logic rst_n;
    logic start;
    logic signed [15:0] theta_in;
    logic done;
    logic signed [15:0] sin_out;
    logic signed [15:0] cos_out;

    cordic_folded dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .theta_in(theta_in),
        .done(done),
        .sin_out(sin_out),
        .cos_out(cos_out)
    );

    always #5 clk = ~clk;

    task test_angle(input signed [15:0] angle, input string name);
        begin
            @(posedge clk);
            theta_in = angle;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;
            
            wait(done);
            @(posedge clk);
            $display("Test %s completado. Seno: %d, Coseno: %d", name, sin_out, cos_out);
            #10;
        end
    endtask

    initial begin
        $dumpfile("cordic.vcd");
        $dumpvars(0, tb_cordic_folded);

        clk = 0;
        rst_n = 0;
        start = 0;
        theta_in = 0;

        #15 rst_n = 1;

        // Pi/6 = 0.523598 -> 0.523598 * 16384 = 8578
        test_angle(16'd8578, "Pi/6");
        // Pi/4 = 0.785398 -> 0.785398 * 16384 = 12867
        test_angle(16'd12867, "Pi/4");
        // Pi/3 = 1.047197 -> 1.047197 * 16384 = 17157
        test_angle(16'd17157, "Pi/3");

        $finish;
    end
endmodule