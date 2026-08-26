`timescale 1ns/1ps

module rca #(
    parameter N = 8
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
            full_adder u_fa (
                .a   (a[i]),
                .b   (b[i]),
                .cin (c[i]),
                .s   (s[i]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign cout = c[N];
endmodule