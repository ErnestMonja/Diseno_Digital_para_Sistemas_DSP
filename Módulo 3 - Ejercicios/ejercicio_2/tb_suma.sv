`timescale 1ns/1ps

module tb_suma;

parameter NB_A  = 6;
parameter NBF_A = 4;
parameter NB_B  = 8;
parameter NBF_B = 5;
parameter NB_S  = 9;
parameter NBF_S = 5;

logic signed [NB_A-1 : 0] a;
logic signed [NB_B-1 : 0] b;
logic signed [NB_S-1 : 0] s;

logic signed [NB_B-1 : 0] a_format;

suma
#(
    .NB_A (NB_A ),
    .NBF_A(NBF_A),
    .NB_B (NB_B ),
    .NBF_B(NBF_B),
    .NB_S (NB_S ),
    .NBF_S(NBF_S)
)
u_suma
(
    .a(a),
    .b(b),
    .s(s)
);

assign a_format = u_suma.a_format;

initial begin
    a = -1.75 * (2**NBF_A);
    b = 0.9375 * (2**NBF_B);

    #10
    $display("A:   %6b  | %0d", a, a);
    $display("B:  %8b |  %0d", b, b);
    $display("");
    $display("A:  %8b | %0d", a_format, a_format);
    $display("B:  %8b |  %0d", b, b);
    $display("---------------------");
    $display("S: %9b | %0d", s, s);
    $finish;
end
    
endmodule