module btr(inA, out);

input [15:0] inA;
output wire [15:0] out;

assign out = {inA[0],inA[1],inA[2],inA[3],inA[4],inA[5],inA[6],inA[7],inA[8],
inA[9],inA[10],inA[11],inA[12],inA[13],inA[14],inA[15]};

endmodule
