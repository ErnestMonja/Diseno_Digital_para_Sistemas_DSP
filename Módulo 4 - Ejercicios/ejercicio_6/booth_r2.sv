module booth_r2 #(
    parameter NB_IN = 8,
    parameter NB_OUT = 2 * NB_IN
) (
    input  logic signed [NB_IN -1 : 0] a,  // Multiplicando
    input  logic signed [NB_IN -1 : 0] b,  // Multiplicador
    output logic signed [NB_OUT-1 : 0] m    // Producto
);

logic signed [NB_IN+1 -1 : 0] b_aux;
logic signed [NB_OUT  -1 : 0] pp [NB_IN -1 : 0];
logic signed [NB_OUT  -1 : 0] acc;
integer i;

always_comb begin : prod
    b_aux = {b, 1'b0};
    acc = {NB_OUT{1'b0}};

    for (i = 0; i < NB_IN; i = i + 1) begin
        case (b_aux[i +: 2])
            2'b00: 
                pp[i] = {NB_OUT{1'b0}};
            2'b01: 
                pp[i] = a <<< i;
            2'b10: 
                pp[i] = -a <<< i;
            2'b11: 
                pp[i] = {NB_OUT{1'b0}};
        endcase

        acc += pp[i];
    end

    m = acc;
end

endmodule