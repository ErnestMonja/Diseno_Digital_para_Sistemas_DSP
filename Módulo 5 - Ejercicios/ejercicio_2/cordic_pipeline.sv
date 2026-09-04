module cordic_pipeline
#(
    parameter NB = 16,
    parameter NBF = 14,
    parameter N_ITER = 14
)
(
    input  logic clk,
    input  logic rst,
    input  logic signed [NB - 1 : 0] x_i,
    input  logic signed [NB - 1 : 0] y_i,
    input  logic signed [NB - 1 : 0] z_i,
    output logic signed [NB - 1 : 0] x_o,
    output logic signed [NB - 1 : 0] y_o,
    output logic signed [NB - 1 : 0] z_o
);

// 15 registros (N_ITER + 1)
logic signed [NB - 1 : 0] x [N_ITER : 0];
logic signed [NB - 1 : 0] y [N_ITER : 0];
logic signed [NB - 1 : 0] z [N_ITER : 0];
logic signed [NB - 1 : 0] arctan [N_ITER - 1 : 0];

initial begin
    $readmemh("arctan.mem", arctan, 0, N_ITER-1);
end

always_comb begin
    x[0] = x_i;
    y[0] = y_i;
    z[0] = z_i;
end

generate
    genvar i;
    
    // 14 iteraciones
    for(i = 1; i < (N_ITER + 1); i = i + 1) begin
        always_ff @( posedge clk ) begin
            if(rst) begin
                x[i] <= {NB{1'b0}};
                y[i] <= {NB{1'b0}};
                z[i] <= {NB{1'b0}};
            end
            else begin
                x[i] <= (z[i-1][NB-1]) ? (x[i-1] + (y[i-1] >>> (i-1))) : (x[i-1] - (y[i-1] >>> (i-1)));
                y[i] <= (z[i-1][NB-1]) ? (y[i-1] - (x[i-1] >>> (i-1))) : (y[i-1] + (x[i-1] >>> (i-1)));
                z[i] <= (z[i-1][NB-1]) ? (z[i-1] + arctan[i-1]) : (z[i-1] - arctan[i-1]);
            end
        end
    end
endgenerate

assign x_o = x[N_ITER];
assign y_o = y[N_ITER];
assign z_o = z[N_ITER];

endmodule