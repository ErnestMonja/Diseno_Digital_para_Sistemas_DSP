`timescale 1ns/1ps

module array_mul (
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    output logic [15:0] p
);
    // Generacion de los 64 productos parciales
    logic [7:0] pp [0:7];

    genvar r, c;
    generate
        for (r = 0; r < 8; r = r + 1) begin : gen_pp
            for (c = 0; c < 8; c = c + 1) begin : gen_pp_inner
                assign pp[r][c] = a[c] & b[r];
            end
        end
    endgenerate

    // Matrices de estados de sumas y acarreos (8 filas x 8 bits)
    logic [7:0] s [0:7];
    logic [7:0] c_out [0:7];

    // Fila 0: primer producto parcial
    assign s[0]     = pp[0];
    assign c_out[0] = 8'b0;
    assign p[0]     = s[0][0];

    // Filas 1 a 7 (Matriz CSA)
    generate
        for (r = 1; r < 8; r = r + 1) begin : gen_csa
            for (c = 0; c < 8; c = c + 1) begin : gen_fa
                wire fa_a   = (c == 7) ? 1'b0 : s[r-1][c+1];
                wire fa_b   = pp[r][c];
                wire fa_cin = c_out[r-1][c];

                full_adder fa_inst (
                    .a   (fa_a),
                    .b   (fa_b),
                    .cin (fa_cin),
                    .sum (s[r][c]),
                    .cout(c_out[r][c])
                );
            end
            assign p[r] = s[r][0];
        end
    endgenerate

    // Fila final CPA (Suma de acarreos para bits 8 al 15)
    logic [7:0] cpa_carry;

    full_adder fa_cpa0 (
        .a   (s[7][1]),
        .b   (c_out[7][0]),
        .cin (1'b0),
        .sum (p[8]),
        .cout(cpa_carry[0])
    );

    generate
        for (c = 1; c < 7; c = c + 1) begin : gen_cpa
            full_adder fa_cpa (
                .a   (s[7][c+1]),
                .b   (c_out[7][c]),
                .cin (cpa_carry[c-1]),
                .sum (p[8 + c]),
                .cout(cpa_carry[c])
            );
        end
    endgenerate

    full_adder fa_cpa7 (
        .a   (1'b0),
        .b   (c_out[7][7]),
        .cin (cpa_carry[6]),
        .sum (p[15]),
        .cout(cpa_carry[7])
    );
endmodule