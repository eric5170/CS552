/*
   CS/ECE 552 Spring '23
  
   Filename        : slbi.v
   Description     : This is the module for slbi logic
*/
module slbi(in1, in2, out);

input [15:0] in1, in2;

output wire [15:0] out;

//shfting allowed by rule
assign out = (in1 << 8) | in2;

endmodule