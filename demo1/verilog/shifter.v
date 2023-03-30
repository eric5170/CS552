/*
   CS/ECE 552 Spring '23
  
   Filename        : shifter.v
   Description     : This is the module for shifter operation.
*/
module shifter (in, bit_cnt, Op, Out);

	localparam rotL = 2'b00;
	localparam shfL = 2'b01;
	localparam shfRA = 2'b10;
	localparam shfRL = 2'b11;
	
	// instruction received
	input [15:0] in;
	// amount of bit to shft/rotate
	input [3:0] bit_cnt;
	// shft/rot opcode
	input [1:0] Op;
	
	output reg [15:0]  Out;

	// shift results
	wire [15:0] rotL_res;
	wire [15:0] shfL_res;
	wire [15:0] shfR_A_res;
	wire [15:0] shfR_L_res;
	
	rotateL iRotL(.in(in), .bit_cnt(bit_cnt), .Out(rotL_res));
	shftL iShftL(.in(in), .bit_cnt(bit_cnt), .Out(shfL_res));
	shfR_A iShftRA(.in(in), .bit_cnt(bit_cnt), .Out(shfR_A_res));
	shfR_L iShftR(.in(in), .bit_cnt(bit_cnt), .Out(shfR_L_res));

	always@(*) begin
	   case(Op)
		rotL: assign Out = rotL_res;
		shfL: assign Out = shfL_res;
		shfRA: assign Out = shfR_A_res;
		shfRL: assign Out = shfR_L_res;
		default: Out = 16'hx;
	   endcase
	end
	   
endmodule
