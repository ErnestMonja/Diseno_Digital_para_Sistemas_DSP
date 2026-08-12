`timescale 1ns/1ps

module tb_recorte;
    // Entradas
    reg signed [9:0]  x_in;
    reg signed [10:0] y_in;     // Actualizado a 11 bits

    // Salidas
    wire signed [6:0] x_trunc;
    wire signed [6:0] x_round;
    wire signed [4:0] y_wrap;
    wire signed [4:0] y_sat;

    // Instanciación del DUT
    recorte dut(
        .x_in(x_in),
        .y_in(y_in),
        .x_trunc(x_trunc),
        .x_round(x_round),
        .y_wrap(y_wrap),
        .y_sat(y_sat)
    );

    initial begin
        $dumpfile("recorte.vcd");
        $dumpvars(0, tb_recorte);

        // Inicializamos
        x_in = 10'd0;
        y_in = 11'd0;
        #10;

        // Caso a) x = 5.5625 (S10.6)
        x_in = 10'b0001011001;
        
        // Caso b) y = 8.75 (S11.6)
        // 8.75 = 01000 (entero) + 110000 (fraccional) -> 11'b01000110000
        y_in = 11'b01000110000;
        #20;
        
        $display("Simulación terminada. Revisar el VCD en GTKWave.");
        $finish;
    end
endmodule