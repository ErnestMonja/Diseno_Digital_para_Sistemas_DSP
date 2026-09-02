`timescale 1ns / 1ps

module cordic_folded (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic signed [15:0] theta_in, // Entrada en S(16,14)
    output logic done,
    output logic signed [15:0] sin_out,
    output logic signed [15:0] cos_out
);

    // Parámetros S(16,14) y constantes
    localparam int ITERATIONS = 14;
    localparam logic signed [15:0] K_INV = 16'd9949; // 1/K = 0.60725 * 2^14

    // ROM de arctan(2^-i) precalculada en S(16,14)
    logic signed [15:0] atan_rom [0:13];
    assign atan_rom[0]  = 16'd12867; // atan(2^0)  = pi/4
    assign atan_rom[1]  = 16'd7596;  // atan(2^-1)
    assign atan_rom[2]  = 16'd4013;  // atan(2^-2)
    assign atan_rom[3]  = 16'd2037;  // atan(2^-3)
    assign atan_rom[4]  = 16'd1022;  // atan(2^-4)
    assign atan_rom[5]  = 16'd511;   // atan(2^-5)
    assign atan_rom[6]  = 16'd256;   // atan(2^-6)
    assign atan_rom[7]  = 16'd128;   // atan(2^-7)
    assign atan_rom[8]  = 16'd64;    // atan(2^-8)
    assign atan_rom[9]  = 16'd32;    // atan(2^-9)
    assign atan_rom[10] = 16'd16;    // atan(2^-10)
    assign atan_rom[11] = 16'd8;     // atan(2^-11)
    assign atan_rom[12] = 16'd4;     // atan(2^-12)
    assign atan_rom[13] = 16'd2;     // atan(2^-13)

    // Estados de la FSM
    typedef enum logic [1:0] {IDLE, ITER, DONE_ST} state_t;
    state_t state, next_state;

    // Registros del datapath
    logic signed [15:0] x, y, z;
    logic signed [15:0] next_x, next_y, next_z;
    logic [3:0] iter_cnt, next_iter_cnt;

    // Lógica secuencial
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state    <= IDLE;
            x        <= '0;
            y        <= '0;
            z        <= '0;
            iter_cnt <= '0;
        end else begin
            state    <= next_state;
            x        <= next_x;
            y        <= next_y;
            z        <= next_z;
            iter_cnt <= next_iter_cnt;
        end
    end

    // Lógica combinacional (Datapath y FSM)
    always_comb begin
        next_state    = state;
        next_x        = x;
        next_y        = y;
        next_z        = z;
        next_iter_cnt = iter_cnt;
        done          = 1'b0;

        case (state)
            IDLE: begin
                if (start) begin
                    next_x        = K_INV; // Inicialización pre-escalada
                    next_y        = 16'd0;
                    next_z        = theta_in;
                    next_iter_cnt = 4'd0;
                    next_state    = ITER;
                end
            end

            ITER: begin
                // Decisión de rotación (signo de z)
                if (z >= 0) begin
                    next_x = x - (y >>> iter_cnt);
                    next_y = y + (x >>> iter_cnt);
                    next_z = z - atan_rom[iter_cnt];
                end else begin
                    next_x = x + (y >>> iter_cnt);
                    next_y = y - (x >>> iter_cnt);
                    next_z = z + atan_rom[iter_cnt];
                end

                if (iter_cnt == ITERATIONS - 1) begin
                    next_state = DONE_ST;
                end else begin
                    next_iter_cnt = iter_cnt + 1'b1;
                end
            end

            DONE_ST: begin
                done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

    // Asignación de salidas
    assign cos_out = x;
    assign sin_out = y;

endmodule