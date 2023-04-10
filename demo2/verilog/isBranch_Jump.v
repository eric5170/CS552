/*
   CS/ECE 552 Spring '23
  
   Filename        : isBranch_Jump.v
   Description     : This is the module for the Jump/Branch instruction logics.
*/
module isBranch_Jump(opcode, RsVal, incr_PC, isJR, isJump, isBranch, ALUResult, immed, next_PC);

	input [15:0] incr_PC;
	input isJR, isJump, isBranch;
	input [15:0] ALUResult; 
	input [15:0] immed;
	input [4:0] opcode;
	input [15:0] RsVal;
	output [15:0] next_PC;

	wire [15:0] immedWire;
	wire [15:0] addOutput;
	wire [15:0] JR_out;
	wire BZ, BZ_out;
	wire zero;
	wire C_out;


	cla16b ADD(.sum(addOutput), .cOut(C_out), .inA(incr_PC), .inB(immedWire), .cIn(1'b0));

	mux2_1 JR_OUT_MUX[15:0] (.out(JR_out), .inputA(addOutput), .inputB(ALUResult), .sel(isJR));

	mux2_1 B_AND_Z_MUX[15:0] (.out(BZ_out), .inputA(incr_PC), .inputB(addOutput), .sel(BZ));
	mux2_1 NEXT_PC_MUX[15:0] (.out(next_PC), .inputA(BZ_out), .inputB(JR_out), .sel(isJump));
	
	isBranch_ALU iBrnch(.opcode(opcode), .RsVal(RsVal), .zero(zero));
	assign BZ= zero & isBranch; 
	assign immedWire = immed;



endmodule
	
