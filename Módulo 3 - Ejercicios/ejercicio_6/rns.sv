module rns
#(
    parameter NB_X = 5,
    parameter NB_Y = 4,
    parameter NB_MOD3 = 2,
    parameter NB_MOD5 = 3,
    parameter NB_MOD7 = 4
)
(
    input  logic [NB_X   -1 : 0] x,
    input  logic [NB_Y   -1 : 0] y,
    output logic [NB_MOD3-1 : 0] p_mod3,
    output logic [NB_MOD5-1 : 0] p_mod5,
    output logic [NB_MOD7-1 : 0] p_mod7
);

logic [NB_MOD3-1 : 0] x_mod3;
logic [NB_MOD5-1 : 0] x_mod5;
logic [NB_MOD7-1 : 0] x_mod7;
logic [NB_MOD3-1 : 0] y_mod3;
logic [NB_MOD5-1 : 0] y_mod5;
logic [NB_MOD7-1 : 0] y_mod7;

// Usando '%' no es sintetizable, hay que usar un algoritmo mas complejo
always_comb begin : prod
    // Conversion
    x_mod3 = x % 3;
    x_mod5 = x % 5;
    x_mod7 = x % 7;
    y_mod3 = y % 3;
    y_mod5 = y % 5;
    y_mod7 = y % 7;

    // Producto
    p_mod3 = (x_mod3 * y_mod3) % 3;
    p_mod5 = (x_mod5 * y_mod5) % 5;
    p_mod7 = (x_mod7 * y_mod7) % 7;
end
    
endmodule