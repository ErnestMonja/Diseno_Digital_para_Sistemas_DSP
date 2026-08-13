`timescale 1ns/1ps

module tb_csd;

parameter NB_X = 4;
parameter NB_K_EST = 5;
parameter NB_K_CSD = 6;
parameter NB_Y_EST = NB_X + NB_K_EST;
parameter NB_Y_CSD = NB_X + NB_K_CSD;

logic signed [NB_X    -1 : 0] x;
logic signed [NB_Y_EST-1 : 0] y_est;
logic signed [NB_Y_CSD-1 : 0] y_csd;

csd
#(
    .NB_X(NB_X),
    .NB_K_EST(NB_K_EST),
    .NB_K_CSD(NB_K_CSD),
    .NB_Y_EST(NB_Y_EST),
    .NB_Y_CSD(NB_Y_CSD)
)
u_csd
(
    .x(x),
    .y_est(y_est),
    .y_csd(y_csd)
);

integer i;

initial begin
    $monitor("x: %4b (%0d) \t| y (est): %9b (%0d) \t| y (csd): %10b (%0d)", x, x, y_est, y_est, y_csd, y_csd);

    for (i = 0; i < 16; i = i + 1) begin
        x = i;
        #10;
    end
    
    $finish;
end

endmodule