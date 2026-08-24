`timescale 1ns/100ps

module tb_mul_seq();

parameter NB_IN = 8;
parameter NB_OUT = 2 * NB_IN;

logic                clk;
logic                rst;
logic [NB_IN -1 : 0] a;  // Multiplicando
logic [NB_IN -1 : 0] b;  // Multiplicador
logic                start; // Iniciar producto
logic [NB_OUT-1 : 0] m;   // Producto
logic                done; // Flag de producto listo

integer i;
integer j;
integer test_count;
integer test_error;

always #5 clk = ~clk;

mul_seq
#(
    .NB_IN (NB_IN ),
    .NB_OUT(NB_OUT)
)
u_mul_seq
(
    .clk  (clk  ),
    .rst  (rst  ),
    .a    (a    ),
    .b    (b    ),
    .start(start),
    .m    (m    ),
    .done (done )
);

logic [NB_OUT-1 : 0] test_m;

always @(posedge done) begin
    test_count = test_count + 1;

    test_m = a * b;
    if (m != test_m) begin
        test_error = test_error + 1;
    end
    
end

initial begin
    $dumpfile("tb_mul_seq.vcd");
    $dumpvars(0, tb_mul_seq);
    test_count = 0;
    test_error = 0;
    a = {NB_IN{1'b0}};
    b = {NB_IN{1'b0}};
    start = 1'b0;
    clk = 1'b0;
    rst = 1'b1;

    #100
    @(posedge clk);
    rst = 1'b0;
    
    // Todo 0
    a = {NB_IN{1'b0}};
    b = {NB_IN{1'b0}};
    start = 1'b1;
    #1
    @(posedge clk);
    start = 1'b0;
    
    // Todo 1
    #20
    @(negedge done);
    @(posedge clk);
    a = {NB_IN{1'b1}};
    b = {NB_IN{1'b1}};
    start = 1'b1;
    #1
    @(posedge clk);
    start = 1'b0;

    #20
    @(negedge done);
    @(posedge clk);
    a = {NB_IN{1'b1}};
    b = {NB_IN{1'b0}};
    start = 1'b1;
    #1
    @(posedge clk);
    start = 1'b0;

    #20
    @(negedge done);
    @(posedge clk);
    a = {NB_IN{1'b0}};
    b = {NB_IN{1'b1}};
    start = 1'b1;
    #1
    @(posedge clk);
    start = 1'b0;

    #20
    @(negedge done);
    @(posedge clk);
    a = 8'd5;
    b = 8'd5;
    start = 1'b1;
    #1
    @(posedge clk);
    start = 1'b0;

    // 1000 casos random
    repeat(200) begin
        #20
        @(negedge done);
        @(posedge clk);
        a = $urandom_range(2**NB_IN-1); // [0,2^8-1]
        b = $urandom_range(2**NB_IN-1); // [0,2^8-1]
        start = 1'b1;
        #1
        @(posedge clk);
        start = 1'b0;
    end

    #40
    @(negedge done);
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