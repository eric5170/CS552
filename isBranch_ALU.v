/*
   CS/ECE 552 Spring '23
  
   Filename        : isBranch_ALU.v
   Description     : This is the module for branch logic.
*/
module isBranch_ALU(opcode, RsVal, zero);

input [4:0] opcode;
input [15:0] RsVal;
output wire zero;

wire beqz, bnez, bltz, bgez;

assign beqz = RsVal ? 0 : 1;
assign bnez = RsVal ? 1 : 0;
assign bltz = (RsVal[15]) ? 1 : 0;
assign bgez = (RsVal[15]) ? 0 : 1;


mux4_1 BRANCH_MUX(.out(zero), .inputA(beqz), .inputB(bnez),
	.inputC(bltz), .inputD(bgez), .sel(opcode[1:0]));

endmodule	
	
	