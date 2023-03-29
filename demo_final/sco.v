module sco(A, B, Out);

input [15:0] A, B;
output [15:0] Out;
wire C_out;


cla16b sco_ADD(.sum(), .cOut(C_out), .inA(A), .inB(B), .cIn(1'b0));


assign Out = {{15{1'h0}}, C_out};

endmodule
