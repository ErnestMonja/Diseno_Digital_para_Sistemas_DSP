module recorte (
    input wire signed [9:0]  x_in,      // x = 5.5625 en S(10,6)
    input wire signed [10:0] y_in,      // y = 8.75 en S(11,6) --> Para que funcione
    output wire signed [6:0] x_trunc,   // S(7,3)
    output wire signed [6:0] x_round,   // S(7,3)
    output wire signed [4:0] y_wrap,    // S(5,3)
    output wire signed [4:0] y_sat      // S(5,3)
);

    // a) Recorte de x: S(10,6) a S(7,3) (Sin cambios)
    assign x_trunc = x_in[9:3];

    wire signed [10:0] x_round_temp;
    assign x_round_temp = x_in + 11'sd4; // Sumamos 1<<2 para redondear
    assign x_round = x_round_temp[9:3];

    // b) Recorte de y: S(11,6) a S(5,3)
    // Wrap-around: Truncado directo. Nos quedamos con 3 bits fraccionales [5:3] 
    // y 2 bits enteros/signo [7:6]. Por lo tanto, extraemos del [7:3].
    assign y_wrap = y_in[7:3];

    // Saturación: El rango de S(5,3) es [-2, +1.875]
    reg signed [4:0] y_sat_reg;
    always @(*) begin
        // Verificamos el signo original [10] y los bits enteros descartados [9:7]
        // Para que un número entre en S(5,3), los bits [10:7] deben ser idénticos (extensión de signo).

        if(y_in[10] == 1'b0 && y_in[9:7] != 3'b000) begin
            y_sat_reg = 5'b01111;           // Overflow positivo -> Forzar máximo valor S(5,3): 01111 (+1.875)
        end 
        else if(y_in[10] == 1'b1 && y_in[9:7] != 3'b111) begin
            y_sat_reg = 5'b10000;           // Overflow negativo -> Forzar mínimo valor S(5,3): 10000 (-2.0)
        end
        else begin
            y_sat_reg = y_in[7:3];          // Dentro del rango normal, hacemos un wrap normal
        end
    end
    assign y_sat = y_sat_reg;
endmodule
