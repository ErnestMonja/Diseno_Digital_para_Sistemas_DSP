`timescale 1ns/1ps

module csla16 #(
    parameter N = 16
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic         cin,
    output logic [N-1:0] s,
    output logic         cout
);
    // Cables intermedios para los acarreos entre etapas
    logic c4, c8, c12;

    // --- Bloque 0 (Bits 3:0) ---
    // El primer bloque es un RCA normal porque ya conocemos el carry in real
    rca4 b0 (
        .a(a[3:0]), .b(b[3:0]), .cin(cin), 
        .s(s[3:0]), .cout(c4)
    );

    // --- Bloque 1 (Bits 7:4) ---
    logic [3:0] s1_0, s1_1;
    logic       c8_0, c8_1;
    
    rca4 b1_0 (.a(a[7:4]), .b(b[7:4]), .cin(1'b0), .s(s1_0), .cout(c8_0));
    rca4 b1_1 (.a(a[7:4]), .b(b[7:4]), .cin(1'b1), .s(s1_1), .cout(c8_1));
    
    assign s[7:4] = (c4) ? s1_1 : s1_0;
    assign c8     = (c4) ? c8_1 : c8_0;

    // --- Bloque 2 (Bits 11:8) ---
    logic [3:0] s2_0, s2_1;
    logic       c12_0, c12_1;
    
    rca4 b2_0 (.a(a[11:8]), .b(b[11:8]), .cin(1'b0), .s(s2_0), .cout(c12_0));
    rca4 b2_1 (.a(a[11:8]), .b(b[11:8]), .cin(1'b1), .s(s2_1), .cout(c12_1));
    
    assign s[11:8] = (c8) ? s2_1 : s2_0;
    assign c12     = (c8) ? c12_1 : c12_0;

    // --- Bloque 3 (Bits 15:12) ---
    logic [3:0] s3_0, s3_1;
    logic       cout_0, cout_1;
    
    rca4 b3_0 (.a(a[15:12]), .b(b[15:12]), .cin(1'b0), .s(s3_0), .cout(cout_0));
    rca4 b3_1 (.a(a[15:12]), .b(b[15:12]), .cin(1'b1), .s(s3_1), .cout(cout_1));
    
    assign s[15:12] = (c12) ? s3_1 : s3_0;
    assign cout     = (c12) ? cout_1 : cout_0;
endmodule