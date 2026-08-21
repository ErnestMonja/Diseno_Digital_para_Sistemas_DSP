module cla4 #(
    parameter NB = 4
) (
    input  logic [NB-1 : 0] a,  // Sumando A
    input  logic [NB-1 : 0] b,  // Sumando B
    input  logic            ci, // Carry in
    output logic [NB-1 : 0] s,  // Resultado
    output logic            co, // Carry out
    output logic            pg, // Group propagate
    output logic            gg  // Group generate
);

logic [NB+1 -1 : 0] c;  // Carry
logic [NB   -1 : 0] g;  // Generate
logic [NB   -1 : 0] p;  // Propagate

integer i;

always_comb begin : suma
    // Bloque generate/propagate
    g = a & b;
    p = a ^ b;

    // Logica CLA
    c[0] = ci;
    for (i = 1; i < NB + 1; i = i + 1) begin
        c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end

end

// Logica suma
assign s = p ^ c[NB-1:0];
assign co = c[NB];

// Generate y propagate global
assign pg = &p;
assign gg = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]); // Parametrizar esto

// // --- Para ver los tiempos de propagacion ---

// logic [NB   -1 : 0] p_and_c_temp; // p & c

// // Bloque generate/propagate
// assign #1 g = a & b;
// assign #1 p = a ^ b;
// assign c[0] = ci;

// // Logica CLA
// assign #1 p_and_c_temp = p & c;
// assign #1 c[NB:1] = g | p_and_c_temp;

// // Logica suma
// assign #1 s = p ^ c[NB-1:0];
// assign #1 co = c[NB];

endmodule