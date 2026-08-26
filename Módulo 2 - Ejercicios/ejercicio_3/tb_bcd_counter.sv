`timescale 1ns/1ps

module tb_bcd_counter;
    // Declaración de señales
    logic       clk;
    logic       rst;
    logic       en;
    logic [3:0] cnt;
    logic       tc;

    integer tc_count;                   // Variable interna del testbench para el auto-check:

    bcd_counter dut (                   // Instancia del módulo (Device Under Test):
        .clk(clk),
        .rst(rst),
        .en(en),
        .cnt(cnt),
        .tc(tc)
    );
    
    initial begin                       // Generación de Clock a 100 MHz (Periodo de 10 ns -> cambia cada 5 ns)
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Lógica del Golden Model / Auto-Checker:
    //  - Detecta y cuenta los pulsos de 'tc' en cada flanco de subida
    always_ff @(posedge clk) begin
        if (rst) begin
            tc_count <= 0;
        end
        else if (tc && en) begin
            tc_count <= tc_count + 1;
        end
    end

    // Bloque principal de estímulos
    initial begin
        // Generación del archivo VCD para GTKWave:
        $dumpfile("bcd_counter.vcd");
        $dumpvars(0, tb_bcd_counter);

        // 1. Inicialización y Reset Síncrono:
        rst = 1;
        en  = 0;
        
        // Esperamos un par de flancos para que el reset síncrono haga efecto:
        @(posedge clk);
        @(posedge clk);
        
        // 2. Liberamos el reset y activamos el enable:
        rst = 0;
        en  = 1;

        // 3. Ejecutamos exactamente 100 ciclos de reloj con el contador habilitado:
        repeat (100) @(posedge clk);

        // 4. Pausamos el contador:
        en = 0;
        @(posedge clk);

        // 5. Verificación automática (Auto-check):
        $display("");
        $display("==================================================");
        $display("   RESULTADOS DE LA SIMULACIÓN - BCD COUNTER      ");
        $display("==================================================");
        $display("Ciclos con EN=1 ejecutados: 100");
        $display("Pulsos 'tc' detectados:     %0d", tc_count);
        $display("--------------------------------------------------");
        
        if (tc_count == 10) begin
            $display("ESTADO: [ PASS ] - El rollover funciono perfecto.");
        end else begin
            $display("ESTADO: [ FAIL ] - Hubo un error en la cuenta.");
        end
        $display("==================================================");
        $display("");

        // Fin de la simulación:
        $finish;
    end
endmodule
