`timescale 1ns/1ps

module tb_array_mul;
    logic [7:0]  a;
    logic [7:0]  b;
    logic [15:0] p;
    logic [15:0] expected;

    integer i, j;
    integer errors = 0;

    array_mul dut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        $dumpfile("tb_array_mul.vcd");
        $dumpvars(0, tb_array_mul);

        $display("==================================================");
        $display("Inicio Test Exhaustivo (65,536 combinaciones)...");
        $display("==================================================");

        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                a = i[7:0];
                b = j[7:0];
                expected = a * b;
                #1; // Tiempo de propagacion combinacional

                if (p !== expected) begin
                    $display("[FAIL] a=%0d b=%0d | Esperado=%0d Obtenido=%0d", a, b, expected, p);
                    errors = errors + 1;
                end
            end
        end

        $display("==================================================");
        if (errors == 0)
            $display("RESULTADO: PASS - 65,536/65,536 vectores validados.");
        else
            $display("RESULTADO: FAIL - %0d errores encontrados.", errors);
        $display("==================================================");

        $finish;
    end
endmodule