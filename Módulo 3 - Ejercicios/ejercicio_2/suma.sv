`timescale 1ns/1ps

module suma
#(
    parameter NB_A  = 6,
    parameter NBF_A = 4,
    parameter NB_B  = 8,
    parameter NBF_B = 5,
    parameter NB_S  = 9,
    parameter NBF_S = 5
)
(
    input  logic signed [NB_A-1 : 0] a,
    input  logic signed [NB_B-1 : 0] b,
    output logic signed [NB_S-1 : 0] s
);

logic signed [NB_B-1 : 0] a_format;

always_comb begin : suma
    a_format = {{1{a[NB_A-1]}}, a, {1{1'b0}}};
    s = a_format + b;
end
    
endmodule