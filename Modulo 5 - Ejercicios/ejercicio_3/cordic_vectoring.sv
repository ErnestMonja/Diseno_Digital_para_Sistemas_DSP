`timescale 1ns / 1ps

module cordic_vectoring (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic signed [15:0] x_in,    // Formato S(16,15)
    input  logic signed [15:0] y_in,    // Formato S(16,15)
    output logic done,
    output logic signed [15:0] r_out,   // Formato S(16,15)
    output logic signed [15:0] phi_out  // Formato S(16,13) rango [-pi, pi]
);

    localparam int ITERATIONS = 16;
    // 1/K = 0.607252935 en S(16,15) -> 0.607252935 * 32768 = 19898
    localparam logic signed [15:0] K_INV = 16'd19898; 
    // Pi en formato S(16,13) (escala 8192) -> 3.14159265 * 8192 = 25736
    localparam logic signed [15:0] PI_S1613 = 16'd25736;

    // ROM arctan(2^-i) precalculada en formato S(16,13)
    logic signed [15:0] atan_rom [0:15];
    initial begin
        atan_rom[0]  = 16'd6434;  // atan(2^0)  = pi/4
        atan_rom[1]  = 16'd3798;  // atan(2^-1)
        atan_rom[2]  = 16'd2007;  // atan(2^-2)
        atan_rom[3]  = 16'd1019;  // atan(2^-3)
        atan_rom[4]  = 16'd511;   // atan(2^-4)
        atan_rom[5]  = 16'd256;   // atan(2^-5)
        atan_rom[6]  = 16'd128;   // atan(2^-6)
        atan_rom[7]  = 16'd64;    // atan(2^-7)
        atan_rom[8]  = 16'd32;    // atan(2^-8)
        atan_rom[9]  = 16'd16;    // atan(2^-9)
        atan_rom[10] = 16'd8;     // atan(2^-10)
        atan_rom[11] = 16'd4;     // atan(2^-11)
        atan_rom[12] = 16'd2;     // atan(2^-12)
        atan_rom[13] = 16'd1;     // atan(2^-13)
        atan_rom[14] = 16'd0;
        atan_rom[15] = 16'd0;
    end

    typedef enum logic [1:0] {IDLE, ITER, MULT_K, DONE_ST} state_t;
    state_t state, next_state;

    // Registros extendidos a 18 bits para contener el crecimiento de ganancia K
    logic signed [17:0] x, y;
    logic signed [17:0] next_x, next_y;
    logic signed [15:0] z, next_z;
    logic [4:0] iter_cnt, next_iter_cnt;

    logic signed [33:0] r_mult;

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
                    // Pre-rotación de 180° si x < 0 (Cuadrantes II y III)
                    if (x_in < 0) begin
                        next_x = -{{2{x_in[15]}}, x_in};
                        next_y = -{{2{y_in[15]}}, y_in};
                        next_z = (y_in >= 0) ? PI_S1613 : -PI_S1613;
                    end else begin
                        next_x = {{2{x_in[15]}}, x_in};
                        next_y = {{2{y_in[15]}}, y_in};
                        next_z = 16'd0;
                    end
                    next_iter_cnt = 5'd0;
                    next_state    = ITER;
                end
            end

            ITER: begin
                // Vectoring: llevar y -> 0
                if (y < 0) begin
                    next_x = x - (y >>> iter_cnt);
                    next_y = y + (x >>> iter_cnt);
                    next_z = z - atan_rom[iter_cnt];
                end else begin
                    next_x = x + (y >>> iter_cnt);
                    next_y = y - (x >>> iter_cnt);
                    next_z = z + atan_rom[iter_cnt];
                end

                if (iter_cnt == ITERATIONS - 1) begin
                    next_state = MULT_K;
                end else begin
                    next_iter_cnt = iter_cnt + 1'b1;
                end
            end

            MULT_K: begin
                next_state = DONE_ST;
            end

            DONE_ST: begin
                done = 1'b1;
                next_state = IDLE;
            end
        endcase
    end

    // Corrección de ganancia: R = x * (1/K)
    assign r_mult  = x * $signed({{18{K_INV[15]}}, K_INV});
    assign r_out   = r_mult[30:15]; // Truncado a S(16,15)
    assign phi_out = z;

endmodule