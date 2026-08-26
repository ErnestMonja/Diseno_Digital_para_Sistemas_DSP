`timescale 1ns/1ps

module rca4 #(
    parameter N = 4
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic         cin,
    output logic [N-1:0] s,
    output logic         cout
);
    logic [N:0] c;
    assign c[0] = cin;

    genvar i;
    generate 
        for (i = 0; i < N; i = i + 1) begin : fa_chain
            assign {c[i+1], s[i]} = a[i] + b[i] + c[i];
        end
    endgenerate

    assign cout = c[N];
endmodule