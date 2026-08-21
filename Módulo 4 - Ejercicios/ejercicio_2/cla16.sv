module cla16 #(
    parameter NB = 16, // 16 bits en total
    parameter N_GROUPS = 4 // 4 grupos
) (
    input  logic [NB-1 : 0] a,  // Sumando A
    input  logic [NB-1 : 0] b,  // Sumando B
    input  logic            ci, // Carry in
    output logic [NB-1 : 0] s,  // Resultado
    output logic            co  // Carry out
);

localparam NB_G = NB / N_GROUPS; // 4 bits por grupo

logic [N_GROUPS+1 -1 : 0] c;  // Carry
logic [N_GROUPS   -1 : 0] g;  // Generate
logic [N_GROUPS   -1 : 0] p;  // Propagate

// integer i;

assign c[0] = ci;

generate
    genvar i;

    for (i = 1; i < N_GROUPS + 1; i = i + 1) begin
        cla4#(
            .NB(NB_G)
        )
        cla4_u(
            .a (a  [NB_G*(i-1) +: NB_G]),
            .b (b  [NB_G*(i-1) +: NB_G]),
            .s (s  [NB_G*(i-1) +: NB_G]),
            .ci(c  [i-1]               ),
            // .co(co [i-1]               ),
            .pg(p  [i-1]               ),
            .gg(g  [i-1]               )
        );

        assign #1 c[i] = g[i-1] | (p[i-1] & c[i-1]);
    end
endgenerate

assign co = c[N_GROUPS];

endmodule