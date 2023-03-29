/*
   CS/ECE 552 Spring '23
  
   Filename        : sco.v
   Description     : This is the module for sco operation.
*/
module sco(in1, in2, out);

input [15:0] in1, in2;

output [15:0] out;

wire cOut;


cla16b iCLA(.sum(), .cOut(cOut), .inA(in1), .inB(in2), .cIn(1'b0));


assign out = {{15{1'h0}}, cOut};

endmodule
