/*
   CS/ECE 552 Spring '23
  
   Filename        : shifter.v
   Description     : This is the module for shifter operation.
*/
module shifter (in, bit_cnt, Op, Out);
	
	// instruction received
	input [15:0] in;
	// amount of bit to shft/rotate
	input [3:0] bit_cnt;
	// shft/rot opcode
	input [1:0] Op;
	
	output reg [15:0]  Out;

	// shift results
	wire [15:0] rotL_res, shfL_res, shfR_A_res, shfR_L_res;
	
	shftL iShftL(.in(in), .bit_cnt(bit_cnt), .Out(shfL_res));
	shfR_L iShftR(.in(in), .bit_cnt(bit_cnt), .Out(shfR_L_res));
	shfR_A iShftRA(.in(in), .bit_cnt(bit_cnt), .Out(shfR_A_res));
	rotateL iRotL(.in(in), .bit_cnt(bit_cnt), .Out(rotL_res));
	
	mux4_1 SHIFTER_MUX(.out(Out), .inputA(shfL_res), .inputB(shfR_A_res),
		.inputC(shfR_A_res), .inputD(shfR_L_res), .sel(op));

	   
endmodule
