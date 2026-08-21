`timescale 1ns/100ps

module tb_cla();

parameter NB = 4;

logic [NB-1 : 0] a ; // Sumando A
logic [NB-1 : 0] b ; // Sumando B
logic            ci; // Carry in
logic [NB-1 : 0] s ; // Resultado
logic            co; // Carry out
logic [NB-1 : 0] pg; // Group propagate
logic [NB-1 : 0] gg; // Group generate

integer i;
integer j;
integer test_count;
integer test_error;

cla4
#(
    .NB(NB)
)
u_cla4
(
    .a (a ),
    .b (b ),
    .ci(ci),
    .s (s ),
    .co(co),
    .pg(pg),
    .gg(gg)
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
    // Todo 1
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
    a = 4'd6;
    b = 4'd12;
    ci = 1'b0;

    // Cout 1 y Cin 1
    #20
    a = 4'd6;
    b = 4'd12;
    ci = 1'b1;

    // Cout 0 y Cin 0
    #20
    a = 4'd5;
    b = 4'd5;
    ci = 1'b0;

    // Todos los casos posibles

    // Carry in 0
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            #20
            ci = 1'b0;
            a = i;
            b = j;
        end
    end

    // Carry in 1
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            #20
            ci = 1'b1;
            a = i;
            b = j;
        end
    end

    #40
    $display("-------------------------");
    $display("Casos correctos: %3d/%3d", test_error, test_count);
    if (test_error == 0)
        $display("Resultado: PASS");
    else
        $display("Resultado: FAIL");
    $display("-------------------------");
    $finish;
end

endmodule