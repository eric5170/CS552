/*
   CS/ECE 552 Spring '23
  
   Filename        : isBranch_ALU.v
   Description     : This is the module for branch logic.
*/
module isBranch_ALU(opcode, RsVal, zero);

input [4:0] opcode;
input [15:0] RsVal;
output wire zero;


mux4_1 BRANCH_MUX(.out(zero), .inputA(RsVal ? 0 : 1), .inputB(RsVal ? 1 : 0),
	.inputC((RsVal[15]) ? 1 : 0), .inputD((RsVal[15]) ? 0 : 1), .sel(opcode[1:0]));

endmodule	
