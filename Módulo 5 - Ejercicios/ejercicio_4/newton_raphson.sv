// Implementar un divisor por NR que calcule y = 1/a con 16 bits de precisión.
// Usar una LUT chica de 8 entradas para y₀ 
// Completar la convergencia con 3-4 iteraciones NR.

// a normalizado [0.5,1.0)
// y: U(16,16) -> [0,1)
// LUT inicial y_o(a), 8 indices
// multiplicador 16x16 (32 bits)

// Entregar:
// (a) Generador de LUT (Python)
// (b) RTL del datapath NR folded
// (c) FSM con flag "done" tras N iters
// (d) Análisis: error vs N iteraciones

module newton_raphson #(
    parameter NB = 16,
    parameter NBF = 16,
    parameter NB_MULT = 16, // 16x16
    parameter N_LUT = 8,
    parameter N_ITER = 3
) (
    input logic clk,
    input logic rst,
    input logic start,
    input logic [$clog2(N_LUT-1) - 1 : 0] lut_sel,
    input logic [NB-1 : 0] a, // entrada U(16,16)
    output logic done,
    output logic [NB-1 : 0] y_o // salida U(16,14)
);

localparam NB_ITER = $clog2(N_ITER);

// Memoria LUT
logic [NB+1 : 0] y_lut [N_LUT-1 : 0]; 
initial begin
    $readmemh("lut.mem", y_lut, 0, N_LUT-1);
end

// Señales de control
logic sel;
logic en;
// Datapath
logic [NB+1 : 0] y_first_next;
logic [NB+1 : 0] y_first;
logic [NB+1 : 0] y_feedback;
logic [33 : 0] mult0; 
logic [17 : 0] sum_in;
logic [35 : 0] mult1; 

// El feedback toma el dato combinacional antes de registrarlo
logic [NB+1 : 0] y_feedback_next;
assign y_feedback_next = mult1[33:16];

// MUX de entrada
assign y_first_next = (sel) ? y_feedback_next : y_lut[lut_sel];

// Registros
always_ff @(posedge clk) begin
    if (rst) begin
        y_first    <= '0;
        y_feedback <= '0;
    end 
    else if (en) begin
        y_first    <= y_first_next;
        y_feedback <= y_feedback_next;
    end
end

// Matemática U(18,16)
assign mult0 = a * y_first;
assign sum_in = mult0[33 : 16]; 
assign mult1 = y_first * (18'h20000 - sum_in);

// Escalar a U(16,14) tomando los bits [17:2]
assign y_o = y_feedback[17:2]; 

// FSM
localparam S_IDLE  = 2'd0;
localparam S_INIT  = 2'd1;
localparam S_ITER  = 2'd2;
localparam S_DONE  = 2'd3;

logic [1:0] state, state_next;
logic [NB_ITER-1 : 0] iter_count, iter_count_next;

always_ff @(posedge clk) begin
    if (rst) begin
        state      <= S_IDLE;
        iter_count <= '0;
    end
    else begin
        state      <= state_next;
        iter_count <= iter_count_next;
    end
end

always_comb begin
    // Valores por defecto
    state_next      = state;
    iter_count_next = iter_count;
    sel  = 1'b0;
    en   = 1'b0;
    done = 1'b0;

    case (state)
        S_IDLE: begin
            if (start) begin
                state_next = S_INIT;
            end
        end

        S_INIT: begin
            en  = 1'b1;
            sel = 1'b0; // MUX = LUT
            state_next      = S_ITER;
            iter_count_next = '0; // Reiniciar el contador
        end

        S_ITER: begin
            en  = 1'b1;
            sel = 1'b1; // MUX = Feedback
            
            if (iter_count >= N_ITER - 1) begin
                state_next = S_DONE;
            end 
            else begin
                iter_count_next = iter_count + 1'b1;
            end
        end

        S_DONE: begin
            done = 1'b1;
            state_next = S_IDLE;
        end
    endcase
end

endmodule