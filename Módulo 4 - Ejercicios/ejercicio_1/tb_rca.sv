`timescale 1ns/1ps

module tb_rca;
    localparam N = 8;

    logic [N-1:0] a, b, s;
    logic         cin, cout;
    logic [N:0]   expected;
    int           errors = 0;

    rca #(
        .N(N)
    ) dut (
        .a   (a),
        .b   (b),
        .cin (cin),
        .s   (s),
        .cout(cout)
    );

    task check_result(input string name);
        expected = a + b + cin;
        if ({cout, s} !== expected) begin
            $display("[FAIL] %s: a=%d, b=%d, cin=%b | Obtenido: {cout=%b, s=%d}, Esperado: %d", 
                     name, a, b, cin, cout, s, expected);
            errors++;
        end
    endtask

    initial begin
        $dumpfile("rca.vcd");
        $dumpvars(0, tb_rca);

        // 1. Borde inferior: 0 + 0
        a = 0; b = 0; cin = 0; #10;
        check_result("Borde Inferior");

        // 2. Borde superior: max + max
        a = '1; b = '1; cin = 0; #10;
        check_result("Borde Superior");

        // 3. Caso con Carry-out = 1
        a = 8'hFF; b = 8'h01; cin = 0; #10;
        check_result("Carry-out en 1");

        // 4. 500 casos aleatorios
        for (int i = 0; i < 500; i++) begin
            a   = $urandom;
            b   = $urandom;
            cin = $urandom_range(0, 1);
            #10;
            check_result("Random");
        end

        // Reporte final en consola
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