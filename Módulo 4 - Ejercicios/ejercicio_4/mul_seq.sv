// • Un adder de N bits
// • Un registro acumulador (2N bits)
// • Un shifter (a la derecha)
// • Un control FSM

// Funcionamiento:
// • En cada ciclo lee el LSB del multiplicador.
// • Si es 1, suma el multiplicando al acumulador. Si es 0, no hace nada.
// • Shiftea el acumulador 1 posición a la derecha.
// • Repite N ciclos.

module mul_seq #(
    parameter NB_IN = 8,
    parameter NB_OUT = 2 * NB_IN
) (
    input  logic                clk,
    input  logic                rst,
    input  logic [NB_IN -1 : 0] a,  // Multiplicando
    input  logic [NB_IN -1 : 0] b,  // Multiplicador
    input  logic                start, // Iniciar producto
    output logic [NB_OUT-1 : 0] m,   // Producto
    output logic                done // Flag de producto listo
);

localparam IDLE = 2'd0;
localparam COMPUTE = 2'd1;
localparam DONE = 2'd2;

localparam NB_COUNTER = $clog2(NB_IN-1); // 3

logic [1 : 0] state;
logic [1 : 0] state_next;
logic [NB_COUNTER-1 : 0] counter;
logic c;
logic [NB_OUT-1 : 0] m_acc;
logic [NB_IN-1 : 0] m_sum;

always_ff @(posedge clk) begin : state_and_outputs
    if (rst) begin
        state <= IDLE;
        counter <= 'd0;
        m_acc <= 'd0;
        m <= 'd0;
        done <= 'd0;
    end
    else begin
        state <= state_next;

        case (state)
            IDLE: begin
                counter <= 'd0;
                m_acc <= {{NB_IN{1'b0}}, b};
                done <= 1'b0;
            end
            COMPUTE: begin
                counter <= counter + 1'b1;
                m_acc <= {c, m_sum, m_acc[NB_IN-1 : 0]} >> 1;
                done <= 1'b0;
            end
            DONE: begin
                counter <= 'd0;
                m_acc <= m_acc;
                m <= m_acc;
                done <= 1'b1;
            end
        endcase
    end
end

always_comb begin : conditionals
    state_next = state;

    case (state)
        IDLE:
            if (start)
                state_next = COMPUTE;
            else
                state_next = IDLE;
        COMPUTE:
            if (&counter)
                state_next = DONE;
            else
                state_next = COMPUTE;
        DONE:
            state_next = IDLE;
        default: 
            state_next = IDLE;
    endcase
end

assign {c, m_sum} = (m_acc[0]) ? a + m_acc[NB_OUT-1 : NB_IN] : {1'b0, m_acc[NB_OUT-1 : NB_IN]};

endmodule