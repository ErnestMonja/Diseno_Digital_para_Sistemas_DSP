module tb_rns;

parameter NB_X = 5;
parameter NB_Y = 4;
parameter NB_MOD3 = 2;
parameter NB_MOD5 = 3;
parameter NB_MOD7 = 4;

logic [NB_X   -1 : 0] x;
logic [NB_Y   -1 : 0] y;
logic [NB_MOD3-1 : 0] x_mod3;
logic [NB_MOD5-1 : 0] x_mod5;
logic [NB_MOD7-1 : 0] x_mod7; 
logic [NB_MOD3-1 : 0] y_mod3;
logic [NB_MOD5-1 : 0] y_mod5;
logic [NB_MOD7-1 : 0] y_mod7; 
logic [NB_MOD3-1 : 0] p_mod3;
logic [NB_MOD5-1 : 0] p_mod5;
logic [NB_MOD7-1 : 0] p_mod7; 

rns
#(
    .NB_X(NB_X),
    .NB_Y(NB_Y),
    .NB_MOD3(NB_MOD3),
    .NB_MOD5(NB_MOD5),
    .NB_MOD7(NB_MOD7)
)
u_rns
(
    .x(x),
    .y(y),
    .p_mod3(p_mod3),
    .p_mod5(p_mod5),
    .p_mod7(p_mod7) 
);

assign x_mod3 = u_rns.x_mod3;
assign x_mod5 = u_rns.x_mod5;
assign x_mod7 = u_rns.x_mod7;
assign y_mod3 = u_rns.y_mod3;
assign y_mod5 = u_rns.y_mod5;
assign y_mod7 = u_rns.y_mod7;

initial begin
    x = 5'd14;
    y = 4'd6;

    #10
    $display("X: %0d | [%0d, %0d, %0d]",  x, x_mod3, x_mod5, x_mod7);
    $display("Y:  %0d | [%0d, %0d, %0d]", y, y_mod3, y_mod5, y_mod7);
    $display("P:      [%0d, %0d, %0d]",      p_mod3, p_mod5, p_mod7);
end
    
endmodule