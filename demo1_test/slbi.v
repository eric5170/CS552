module slbi(inA, inB, Out);

input [15:0] inA, inB;

output wire [15:0] Out;

assign Out = (inA << 8) | inB;

endmodule