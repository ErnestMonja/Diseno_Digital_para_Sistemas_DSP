module reg_ce 
#(
    parameter DATA_WIDTH = 8
)
(
    output reg [DATA_WIDTH-1 : 0] q,
    input wire [DATA_WIDTH-1 : 0] d,
    input wire clk,
    input wire rst_n,
    input wire ce
);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        q <= {DATA_WIDTH{1'b0}};
    else if (ce) 
        q <= d;
    else 
        q <= q;
end
    
endmodule