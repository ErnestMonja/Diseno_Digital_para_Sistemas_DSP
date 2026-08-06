`timescale 1ns/1ps

module pipeline_3stage (
    input  logic               clk,
    input  logic               rst_n,           // Reset asíncrono activo-bajo.
    input  logic signed [7:0]  x_in,            // Interfaz de entrada (Slave AXI-Stream).
    input  logic               valid_in,
    output logic               ready_out,
    output logic signed [15:0] y_out,           // Interfaz de salida (Master AXI-Stream).
    output logic               valid_out,
    input  logic               ready_in
);

    // Parámetros/Constantes del cálculo: A=5, B=3 (con signo).
    localparam logic signed [7:0] A = 8'sd5;
    localparam logic signed [7:0] B = 8'sd3;

    // Habilitador global del pipeline (Back-pressure).
    logic pipe_en;
    assign pipe_en   = ready_in; 
    assign ready_out = ready_in;                // Propagación directa de back-pressure.

    // Registros intermedios para datos (Data Pipeline)
    logic signed [8:0]  stg1_data;              // 9 bits para evitar overflow en la suma.
    logic signed [15:0] stg2_data;              // Resultado del producto.
    logic signed [15:0] stg3_data;              // Resultado del shift aritmético.

    // Registros intermedios para validez (Valid Pipeline):
    logic stg1_valid;
    logic stg2_valid;
    logic stg3_valid;

    // Lógica secuencial del Pipeline:
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stg1_valid <= 1'b0;
            stg2_valid <= 1'b0;
            stg3_valid <= 1'b0;
            stg1_data  <= '0;
            stg2_data  <= '0;
            stg3_data  <= '0;
        end 
        else if (pipe_en) begin
            // Etapa 1: Suma x + A (se expande a 9 bits firmados).
            stg1_data  <= $signed(x_in) + $signed(A);
            stg1_valid <= valid_in;

            // Etapa 2: Multiplicación por B.
            stg2_data  <= stg1_data * $signed(B);
            stg2_valid <= stg1_valid;

            // Etapa 3: Shift derecho aritmético >>> 4.
            stg3_data  <= stg2_data >>> 4;
            stg3_valid <= stg2_valid;
        end
    end

    // Asignación continua a las salidas:
    assign y_out     = stg3_data;
    assign valid_out = stg3_valid;
endmodule