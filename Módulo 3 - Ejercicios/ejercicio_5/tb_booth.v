`timescale 1ns/1ps

module tb_booth;
    // Entradas
    reg signed [3:0] A;
    reg signed [3:0] B;

    // Salidas
    wire signed [7:0] P;

    // Instanciación del multiplicador
    booth dut(
        .A(A),
        .B(B),
        .P(P)
    );

    initial begin
        // Archivo VCD para ver en GTKWave
        $dumpfile("booth.vcd");
        $dumpvars(0, tb_booth);

        // Inicializamos
        A = 4'd0;
        B = 4'd0;
        #10;

        // Inyectamos los valores del ejercicio
        A = 4'b0110;        // A = +6 -> 0110
        B = 4'b1011;        // B = -5 -> 1011
        #20;
        
        $display("Simulación terminada. Revisa el VCD en GTKWave.");
        $finish;
    end
endmodule