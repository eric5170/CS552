/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : seq.v
   Description     : This is the module for seq logic.
*/
module seq(in1, in2, out);

input [15:0] in1, in2;

output [15:0] out;

wire comp;

assign comp = |(in1 ^ in2);
assign out = (~comp) ? 1 : 0;

endmodule
