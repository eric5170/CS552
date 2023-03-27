module sco(inA, inB, Out);

input [15:0] inA, inB;
output [15:0] Out;

wire cOut;

cla16b iCLA(.sum(), .cOut(cOut), .inA(inA), .inB(inB), .cIn(1'b0));

assign Out = {{15{1'b0}}, cOut};

endmodule
