/* LOG DE YOSYS

5.8. Executing PROC_DLATCH pass (convert process syncs to latches).                                                               
Latch inferred for signal `\alu_bad.\y' from process `\alu_bad.$proc$/home/ruben/openlane2/designs/alu_bad/src/alu_bad.v:15$1':   
$auto$proc_dlatch.cc:433:proc_dlatch$10       
*/

module alu_bad
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
    endcase
end
    
endmodule