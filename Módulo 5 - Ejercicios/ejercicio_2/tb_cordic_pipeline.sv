`timescale 1ns/100ps

module tb_cordic_pipeline ();

parameter NB = 16;
parameter NBF = 14;
parameter N_ITER = 14;

// Nro de casos random. Debe coincidir con el Nro elegido en el script
parameter M = 10;

logic clk;
logic rst;
logic signed [NB - 1 : 0] x_i;
logic signed [NB - 1 : 0] y_i;
logic signed [NB - 1 : 0] z_i;
logic signed [NB - 1 : 0] x_o;
logic signed [NB - 1 : 0] y_o;
logic signed [NB - 1 : 0] z_o;

parameter PI = 3.141592654;

real k_float;
real tan;
logic signed [NB - 1 : 0] k;

integer i;

// DEBUG
// logic signed [NB - 1 : 0] arctan [N_ITER - 1 : 0];

// initial begin
//     for (i = 0; i < N_ITER; i = i + 1) begin
//         arctan[i] = dut.arctan[i];
//     end
// end

// logic signed [NB - 1 : 0] x;
// logic signed [NB - 1 : 0] y;
// logic signed [NB - 1 : 0] z;

// always @(x_o) begin
//     for (i = 0; i < N_ITER; i = i + 1) begin
//         x = dut.x[i];
//         y = dut.y[i];
//         z = dut.z[i];
//         $display("%d - x: %d \t y: %d \t z: %d", $time, x, y, z);
//     end
// end

logic signed [NB - 1 : 0] z_i_test [M - 1 : 0];
logic signed [NB - 1 : 0] x_o_test [M - 1 : 0];
logic signed [NB - 1 : 0] y_o_test [M - 1 : 0];

initial begin
    $readmemh("z_i.mem", z_i_test, 0, M-1);
    $readmemh("x_o.mem", x_o_test, 0, M-1);
    $readmemh("y_o.mem", y_o_test, 0, M-1);
end
// FIN DEBUG

cordic_pipeline #(
    .NB(NB),
    .NBF(NBF),
    .N_ITER(N_ITER)
) 
dut (
    .clk(clk),
    .rst(rst),
    .x_i(x_i),
    .y_i(y_i),
    .z_i(z_i),
    .x_o(x_o),
    .y_o(y_o),
    .z_o(z_o)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("tb_cordic_pipeline.vcd");
    $dumpvars(0, tb_cordic_pipeline);

    k_float = 1.0;
    for (i = 0; i < N_ITER; i = i + 1) begin
        tan = 1.0 / 2.0**(2*i);
        k_float = k_float * $sqrt(1 + tan);

        // $display("%d", arctan[i]);
    end
    k = k_float * 2**NBF;
    $display("\nk float = %0.10f", k_float);
    $display("k integer = %d\n", k);
    
    clk = 1'b0;
    rst = 1'b1;
    x_i = 0;
    y_i = 0;
    z_i = 0;
    
    #200
    @(posedge clk);
    rst = 1'b0;
    
    @(posedge clk);

    // Angulo cero
    x_i = 1/k_float * 2**NBF;
    y_i = {NB{1'b0}};
    z_i = 0 * PI/180 * 2**NBF;
    @(posedge clk);

    // Angulo positivo
    x_i = 1/k_float * 2**NBF;
    y_i = {NB{1'b0}};
    z_i = 45 * PI/180 * 2**NBF;
    @(posedge clk);

    // Maximo angulo
    z_i = 90 * PI/180 * 2**NBF;
    @(posedge clk);
    
    // Angulo negativo
    z_i = -30 * PI/180 * 2**NBF;
    @(posedge clk);
    
    // Minimo angulo
    z_i = -90 * PI/180 * 2**NBF;
    @(posedge clk);

    // M casos random
    for (i = 0; i < M; i = i + 1) begin
        z_i = z_i_test[i];
        @(posedge clk);
    end

    repeat(20) @(posedge clk);
    @(posedge clk);
    $finish;
end

endmodule