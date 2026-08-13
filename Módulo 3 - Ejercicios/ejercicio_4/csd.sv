`timescale 1ns/1ps

module csd
#(
    parameter NB_X = 4,
    parameter NB_K_EST = 5,
    parameter NB_K_CSD = 6,
    parameter NB_Y_EST = NB_X + NB_K_EST,
    parameter NB_Y_CSD = NB_X + NB_K_CSD
)
(
    input  logic signed [NB_X    -1 : 0] x,
    output logic signed [NB_Y_EST-1 : 0] y_est,
    output logic signed [NB_Y_CSD-1 : 0] y_csd
);

assign y_est = (x <<< 4) + (x <<< 2) + (x <<< 1) + x;
assign y_csd = (x <<< 5) - (x <<< 3) - x;

endmodule