`timescale 1ns/1ps

//==========================================
//          Caso B (non-blocking)
//==========================================
module caso_b #(
    parameter WIDTH = 4)
    (
        input   logic               clk,
        input   logic               rst_n,
        output  logic [WIDTH-1:0]   a,
        output  logic [WIDTH-1:0]   b,
        output  logic [WIDTH-1:0]   c
    );

    // Asignación inicial
    initial begin
        a = 1;
        b = 2;
        c = 3;
    end

    // En caso de Reset, vuelvo a asignar los mismos valores
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin 
            a <= 1;
            b <= 2;
            c <= 3;
        end
        else begin
            a <= b;
            b <= c;
            c <= a;
        end
    end
endmodule