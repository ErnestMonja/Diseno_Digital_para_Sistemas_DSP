`timescale 1ns/1ps

module tb_csla;
    logic [15:0] a, b, s;
    logic        cin, cout;
    logic [16:0] expected;
    int          errors = 0;

    csla16 dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .s   (s),
        .cout(cout)
    );

    task check_result(input string name);
        expected = a + b + cin;
        if ({cout, s} !== expected) begin
            $display("[FAIL] %s: a=%h, b=%h, cin=%b | Obtenido: {cout=%b, s=%h}, Esperado: %h", 
                     name, a, b, cin, cout, s, expected);
            errors++;
        end
    endtask

    initial begin
        $dumpfile("csla.vcd");
        $dumpvars(0, tb_csla);

        // 1. Borde inferior: 0 + 0
        a = 0; b = 0; cin = 0; #10;
        check_result("Borde Inferior");

        // 2. Borde superior: max + max
        a = '1; b = '1; cin = 0; #10;
        check_result("Borde Superior");

        // 3. Caso con Carry-out = 1
        a = 16'hFFFF; b = 16'h0001; cin = 0; #10;
        check_result("Carry-out en 1");

        // 4. 1000 casos aleatorios (segun consigna ej 2/3)
        for (int i = 0; i < 1000; i++) begin
            a   = $urandom;
            b   = $urandom;
            cin = $urandom_range(0, 1);
            #10;
            check_result("Random");
        end

        if (errors == 0) begin
            $display("=========================================");
            $display("PASS: Todos los casos evaluados con exito.");
            $display("=========================================");
        end else begin
            $display("=========================================");
            $display("FAIL: Se encontraron %0d errores.", errors);
            $display("=========================================");
        end

        $finish;
    end
endmodule