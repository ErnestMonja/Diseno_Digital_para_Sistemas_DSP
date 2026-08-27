`timescale 1ns/100ps

module tb_cla();

parameter NB = 16; // N bits en total
parameter N_GROUPS = 4; // N grupos

logic [NB-1 : 0] a ; // Sumando A
logic [NB-1 : 0] b ; // Sumando B
logic            ci; // Carry in
logic [NB-1 : 0] s ; // Resultado
logic            co; // Carry out
logic  pg; // Group propagate
logic  gg; // Group generate

integer i;
integer j;
integer test_count;
integer test_error;

cla16
#(
    .NB(NB),
    .N_GROUPS(N_GROUPS)
)
cla16_u
(
    .a (a ),
    .b (b ),
    .ci(ci),
    .s (s ),
    .co(co)
);

logic [NB-1 : 0] test_s;
logic test_co;

always #20 begin
    test_count = test_count + 1;

    {test_co, test_s} = a + b + ci;
    if ((s != test_s) || (co != test_co)) begin
        test_error = test_error + 1;
    end
    
end

initial begin
    $dumpfile("tb_cla.vcd");
    $dumpvars(0, tb_cla);
    test_count = 0;
    test_error = 0;
    
    // Todo 0
    a = {NB{1'b0}};
    b = {NB{1'b0}};
    ci = 1'b0;

    #5 // Delay para testear bien con el always de arriba
    // Cout 1
    #20
    a = {NB{1'b1}};
    b = {NB{1'b0}};
    ci = 1'b1;

    // Todo 1, Cin 1
    #20
    a = {NB{1'b1}};
    b = {NB{1'b1}};
    ci = 1'b1;

    // Todo 1, Cin 0
    #20
    a = {NB{1'b1}};
    b = {NB{1'b1}};
    ci = 1'b0;

    // Cout 1
    #20
    a = 16'd6;
    b = 16'd12;
    ci = 1'b0;

    // Cout 1 y Cin 1
    #20
    a = 16'd6;
    b = 16'd12;
    ci = 1'b1;

    // Cout 0 y Cin 0
    #20
    a = 16'd5;
    b = 16'd5;
    ci = 1'b0;

    // 1000 casos random
    repeat(1000) begin
        #20
        a = $urandom_range(2**NB-1); // [0,2^16-1]
        b = $urandom_range(2**NB-1); // [0,2^16-1]
        ci = $urandom_range(1); // [0,1]
    end

    #40
    $display("-------------------------");
    $display("Errores cometidos: %3d/%3d", test_error, test_count);
    if (test_error == 0)
        $display("Resultado: PASS");
    else
        $display("Resultado: FAIL");
    $display("-------------------------");
    $finish;
    // Usando delay en los gates: 8 gates de delay
end

endmodule