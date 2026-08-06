`timescale 1ns/1ps

module bcd_counter (
    input  logic       clk,
    input  logic       rst,         // Reset síncrono activo-alto
    input  logic       en,          // Enable
    output logic [3:0] cnt,         // Salida de cuenta (4 bits)
    output logic       tc           // Terminal count (1 bit)
);

    // Lógica secuencial: Contador BCD
    always_ff @(posedge clk) begin
        if (rst) begin
            cnt <= 4'd0;            // Reset síncrono activo-alto.
        end
        else if (en) begin
            if (cnt == 4'd9) begin
                cnt <= 4'd0;        // Rollover al llegar a 9.
            end 
            else begin
                cnt <= cnt + 1'b1;  // Incremento normal.
            end
        end
    end

    // Lógica combinacional: Pulso de fin de cuenta
    // Se asigna directamente como pidió el profe para evitar el desfase de 1 ciclo
    assign tc = (cnt == 4'd9) && en;
endmodule