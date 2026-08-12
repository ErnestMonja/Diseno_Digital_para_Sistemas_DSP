module booth(
    input wire signed  [3:0] A,
    input wire signed  [3:0] B,
    output wire signed [7:0] P      // Producto de 8 bits
);

    // Agregamos el bit b_{-1} = 0 al final de B
    wire [4:0] B_ext = {B, 1'b0}; 
    
    // Array para almacenar los 4 productos parciales (de 8 bits cada uno)
    reg signed [7:0] pp [0:3];
    
    integer i;

    always @(*) begin
        for (i = 0; i < 4; i = i + 1) begin
            // Evaluamos el par (b_i, b_{i-1})
            case ({B_ext[i+1], B_ext[i]})
                2'b01: pp[i] =   A  <<< i;      // +A desplazado i posiciones
                2'b10: pp[i] = (-A) <<< i;      // -A desplazado i posiciones
                default: pp[i] = 8'sd0;         // 00 o 11 -> Acción: 0
            endcase
        end
    end

    // El producto final es la suma de los productos parciales
    assign P = pp[0] + pp[1] + pp[2] + pp[3];
endmodule