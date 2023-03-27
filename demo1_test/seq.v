module seq(inA, inB, Out);

input [15:0] inA, inB;

output [15:0] Out;

wire cmp;

assign cmp = |(inA ^ inB);
assign Out = (~cmp) ? 1 : 0;

endmodule
