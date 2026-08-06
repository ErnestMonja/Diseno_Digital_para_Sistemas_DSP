/* LOG DE YOSYS

5.8. Executing PROC_DLATCH pass (convert process syncs to latches).                                                               
No latch inferred for signal `\alu_fix1.\y' from process                                                                          
`\alu_fix1.$proc$/home/ruben/openlane2/designs/alu_fix1/src/alu_fix1.v:13$1'.  
*/

module alu_fix1
#(
    parameter DATA_WIDTH = 8,
    parameter OP_WIDTH = 2
)
(
    input wire [DATA_WIDTH-1 : 0] a,
    input wire [DATA_WIDTH-1 : 0] b,
    input wire [OP_WIDTH-1 : 0] op,
    output reg [DATA_WIDTH-1 : 0] y
);

always @(*) begin
    case (op)
        2'b00: y = a + b;
        2'b01: y = a - b;
        2'b10: y = a & b;
        default: y = a | b;
    endcase
end
    
endmodule