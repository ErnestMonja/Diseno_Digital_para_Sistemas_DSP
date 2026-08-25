`timescale 1ns/100ps

module tb_booth();

parameter NB_IN = 8;
parameter NB_OUT = 2 * NB_IN;

logic signed [NB_IN -1 : 0] a;  // Multiplicando
logic signed [NB_IN -1 : 0] b;  // Multiplicador
logic signed [NB_OUT-1 : 0] m;  // Producto

integer i;
integer j;
integer test_count;
integer test_error;

booth_r2
#(
    .NB_IN (NB_IN ),
    .NB_OUT(NB_OUT)
)
u_booth_r2
(
    .a    (a    ),
    .b    (b    ),
    .m    (m    )
);

logic [NB_OUT-1 : 0] test_m;

always #20 begin
    test_count = test_count + 1;

    test_m = a * b;
    if (m != test_m) begin
        test_error = test_error + 1;
    end
    
end

initial begin
    $dumpfile("tb_booth.vcd");
    $dumpvars(0, tb_booth);
    test_count = 0;
    test_error = 0;

    // Todo 0
    a = {NB_IN{1'b0}};
    b = {NB_IN{1'b0}};
    
    // Todo 1
    #5                  // Delay para comparar bien
    #20
    a = {NB_IN{1'b1}};
    b = {NB_IN{1'b1}};

    #20
    a = {NB_IN{1'b1}};
    b = {NB_IN{1'b0}};

    #20
    a = {NB_IN{1'b0}};
    b = {NB_IN{1'b1}};

    #20
    a = {1'b0, {NB_IN-1{1'b1}}};
    b = {1'b0, {NB_IN-1{1'b1}}};

    #20
    a = {1'b1, {NB_IN-1{1'b0}}};
    b = {1'b1, {NB_IN-1{1'b0}}};

    // 1000 casos random
    repeat(1000) begin
        #20
        a = $urandom_range(2**NB_IN-1); // [0,2^8-1]
        b = $urandom_range(2**NB_IN-1); // [0,2^8-1]
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
end

endmodule