`timescale 1ns / 1ps

module tb_pipeline;

    // Señales
    logic               clk;
    logic               rst_n;
    logic signed [7:0]  x_in;
    logic               valid_in;
    logic               ready_out;
    logic signed [15:0] y_out;
    logic               valid_out;
    logic               ready_in;

    // Instancia del DUT
    pipeline_3stage dut (
        .clk(clk),
        .rst_n(rst_n),
        .x_in(x_in),
        .valid_in(valid_in),
        .ready_out(ready_out),
        .y_out(y_out),
        .valid_out(valid_out),
        .ready_in(ready_in)
    );

    // Generación de Clock (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // =========================================================================
    // GOLDEN MODEL EN SOFTWARE Y AUTO-CHECKER
    // =========================================================================
    
    // Cola para guardar los resultados esperados (FIFO)
    logic signed [15:0] expected_queue [$];

    // Función del Golden Model matemático
    function automatic logic signed [15:0] golden_model(input logic signed [7:0] x);
        logic signed [15:0] y;
        // y = ((x + 5) * 3) >>> 4
        y = ((x + 8'sd5) * 8'sd3) >>> 4; 
        return y;
    endfunction

    // Monitor de Entrada: Usa 'always' normal para evitar warnings de síntesis
    always @(posedge clk) begin
        if (valid_in && ready_out && rst_n) begin
            expected_queue.push_back(golden_model(x_in));
        end
    end

    // Monitor de Salida: Compara el DUT vs el Golden Model
    integer errors = 0;
    always @(posedge clk) begin
        if (valid_out && ready_in && rst_n) begin
            logic signed [15:0] exp_val;
            exp_val = expected_queue.pop_front();
            
            if (y_out !== exp_val) begin
                $display("ERROR en t=%0t: x_in=%d | Esperado=%d | Obtenido=%d", $time, x_in, exp_val, y_out);
                errors++;
            end
        end
    end

    // =========================================================================
    // MEDICIÓN DE THROUGHPUT
    // =========================================================================
    integer total_cycles = 0;
    integer valid_transfers = 0;
    logic   measure_en = 0;

    always @(posedge clk) begin
        if (measure_en) total_cycles++;
        if (valid_out && ready_in && rst_n && measure_en) valid_transfers++;
    end

    // =========================================================================
    // BLOQUE DE ESTÍMULOS
    // =========================================================================
    initial begin
        $dumpfile("pipeline.vcd");
        $dumpvars(0, tb_pipeline);

        // Inicialización
        rst_n    = 0;
        valid_in = 0;
        ready_in = 1;
        x_in     = 0;
        
        #20 rst_n = 1; // Liberar reset
        @(posedge clk);

        // ---------------------------------------------------------
        // FASE 1: Régimen sin stalls (ready_in = 1 siempre)
        // ---------------------------------------------------------
        $display(">>> INICIANDO FASE 1: Transmision sin stalls...");
        measure_en = 1;
        
        repeat(20) begin
            valid_in <= 1;
            // Generar un número aleatorio entre -128 y 127
            x_in <= $random; 
            @(posedge clk);
        end

        valid_in <= 0;
        // Esperar a que el pipeline se vacíe (flushing)
        repeat(5) @(posedge clk); 
        
        measure_en = 0;
        $display("Rendimiento Fase 1 (Ideal): %0d muestras en %0d ciclos.", valid_transfers, total_cycles);

        // ---------------------------------------------------------
        // FASE 2: Probar con stall alternando (ready_in = random)
        // ---------------------------------------------------------
        $display(">>> INICIANDO FASE 2: Transmision con STALLS...");
        total_cycles = 0;
        valid_transfers = 0;
        measure_en = 1;

        repeat(50) begin
            // ready_in alterna pseudo-aleatoriamente para forzar stalls
            ready_in <= $random; 
            valid_in <= $random;
            if (valid_in && ready_out) begin
                x_in <= $random;
            end
            @(posedge clk);
        end

        // Limpiar pipeline al finalizar
        valid_in <= 0;
        ready_in <= 1;
        repeat(10) @(posedge clk);
        measure_en = 0;

        $display("Rendimiento Fase 2 (Con Stalls): %0d muestras en %0d ciclos.", valid_transfers, total_cycles);

        // ---------------------------------------------------------
        // REPORTE FINAL
        // ---------------------------------------------------------
        $display("");
        $display("==================================================");
        $display("   RESULTADOS DE LA SIMULACIÓN - PIPELINE AXI-S   ");
        $display("==================================================");
        if (errors == 0 && expected_queue.size() == 0) begin
            $display("ESTADO: [ PASS ] - El pipeline funciona perfecto.");
        end else begin
            $display("ESTADO: [ FAIL ] - Se encontraron %0d errores.", errors);
        end
        $display("Throughput ideal teorico: 1.0 muestras/ciclo");
        $display("==================================================");
        $display("");
        
        $finish;
    end

endmodule