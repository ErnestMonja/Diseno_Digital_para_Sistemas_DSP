`timescale 1ns / 1ps

module tb_cordic_vectoring;

    logic clk;
    logic rst_n;
    logic start;
    logic signed [15:0] x_in;
    logic signed [15:0] y_in;
    logic done;
    logic signed [15:0] r_out;
    logic signed [15:0] phi_out;

    cordic_vectoring dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .x_in(x_in),
        .y_in(y_in),
        .done(done),
        .r_out(r_out),
        .phi_out(phi_out)
    );

    always #5 clk = ~clk;

    task test_vector(input signed [15:0] vx, input signed [15:0] vy, input string quad);
        begin
            @(posedge clk);
            x_in = vx;
            y_in = vy;
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;
            
            wait(done);
            @(posedge clk);
            $display("Test %s | X: %d, Y: %d -> Magnitud R: %d, Fase Phi: %d", quad, vx, vy, r_out, phi_out);
            #10;
        end
    endtask

    initial begin
        $dumpfile("vectoring.vcd");
        $dumpvars(0, tb_cordic_vectoring);

        clk = 0;
        rst_n = 0;
        start = 0;
        x_in = 0;
        y_in = 0;

        #15 rst_n = 1;

        // Cuadrante I:   (0.5, 0.5)   -> (16384, 16384)
        test_vector(16'd16384, 16'd16384, "Cuadrante I  ");

        // Cuadrante II:  (-0.5, 0.5)  -> (-16384, 16384)
        test_vector(-16'd16384, 16'd16384, "Cuadrante II ");

        // Cuadrante III: (-0.5, -0.5) -> (-16384, -16384)
        test_vector(-16'd16384, -16'd16384, "Cuadrante III");

        // Cuadrante IV:  (0.5, -0.5)  -> (16384, -16384)
        test_vector(16'd16384, -16'd16384, "Cuadrante IV ");

        $finish;
    end
endmodule