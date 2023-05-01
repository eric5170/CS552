/*
   CS/ECE 552 Spring '23
   
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : btr.v
   
   Description     : This is the module for btr logic.
*/
module btr(in1, out);

input [15:0] in1;
output wire [15:0] out;

assign out = {in1[0],in1[1],in1[2],in1[3],in1[4],in1[5],in1[6],in1[7],in1[8],
			  in1[9],in1[10],in1[11],in1[12],in1[13],in1[14],in1[15]};

endmodule
