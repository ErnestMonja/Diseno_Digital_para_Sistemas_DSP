module detector_101
(
    input wire clk,
    input wire rst_n,
    input wire x,
    output reg y
);

// Codificacion binaria
localparam S0   = 2'd0;
localparam S1   = 2'd1;
localparam S10  = 2'd2;
localparam S101 = 2'd3;

reg [1:0] state;
reg [1:0] state_next;

// Registro de estado
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        state <= S0;
    else
        state <= state_next;
end

// Próximo estado
always @(*) begin
    state_next = state;

    case (state)
        S0:   state_next = (x) ? S1   : S0 ;
        S1:   state_next = (x) ? S1   : S10;
        S10:  state_next = (x) ? S101 : S0 ;
        S101: state_next = (x) ? S1   : S10;
    endcase
end

// Salida Moore
always @(*) begin
    if (state == S101)
        y = 1'b1;
    else
        y = 1'b0;
end

endmodule
