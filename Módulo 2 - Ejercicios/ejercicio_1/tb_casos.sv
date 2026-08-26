`timescale 1ns/1ps

module tb_casos;
    parameter WIDTH = 4;                // Ancho

    reg clk = 0;                        // Señal de CLK arranca en 0.
    reg rst_n = 0;                      // RST negado arranca en 0.
    wire [WIDTH-1:0] a_A, b_A, c_A;     // Cables para observar las salidas del Caso A.
    wire [WIDTH-1:0] a_B, b_B, c_B;     // Cables para observar las salidas del Caso B.

    caso_a DUT_A(                       // Instanciamos el Caso A.
        .clk(clk), 
        .rst_n(rst_n), 
        .a(a_A),
        .b(b_A),
        .c(c_A)
    );

    caso_b DUT_B(                       // Instanciamos el Caso B.
        .clk(clk), 
        .rst_n(rst_n), 
        .a(a_B),
        .b(b_B),
        .c(c_B)
    );

    always #5 clk = ~clk;               // Generación del CLK: periodo de 10 ns (cambia cada 5 ns)
    initial begin
        $dumpfile("tb_casos.vcd");
        $dumpvars(0, tb_casos);

        // Imprimimos el encabezado de la tabla
        $display("");
        $display("Tiempo |  Caso A (blocking)      |  Caso B (non-blocking)");
        $display("-------+-------------------------+-------------------------");

        rst_n = 0;                      // Estado inicial (Reset en 0)
        #1;                             // Esperamos 1 ns para que el reset haga efecto
        $display(" reset |  a=%0d b=%0d c=%0d            |  a=%0d b=%0d c=%0d", a_A, b_A, c_A, a_B, b_B, c_B);
        
        
        rst_n = 1;                      // Soltamos el reset
        #9;                             // Avanzamos hasta los 10ns (después del primer flanco de subida)
        $display("  10ns |  a=%0d b=%0d c=%0d            |  a=%0d b=%0d c=%0d", a_A, b_A, c_A, a_B, b_B, c_B);

        
        #10;                            // Avanzamos hasta los 20ns (después del segundo flanco)
        $display("  20ns |  a=%0d b=%0d c=%0d            |  a=%0d b=%0d c=%0d", a_A, b_A, c_A, a_B, b_B, c_B);

        
        #10;                            // Avanzamos hasta los 30ns (después del tercer flanco)
        $display("  30ns |  a=%0d b=%0d c=%0d            |  a=%0d b=%0d c=%0d", a_A, b_A, c_A, a_B, b_B, c_B);

        $display("");                   // Imprimimos las conclusiones finales
        $display("Observar: Caso B rota circularmente (1,2,3)->(2,3,1)->(3,1,2)->(1,2,3)");
        $display("          Caso A NO rota -- el orden de = importa y rompe la abstraccion.");
        $display("");

        #6 $finish;                     // Terminamos en 36ns para coincidir exactamente con el mensaje "36000 (1ps)"
    end
endmodule
