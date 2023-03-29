module shifter (In, Cnt, Op, Out);

	localparam rotL = 2'b00;
	localparam shfL = 2'b01;
	localparam shfRA = 2'b10;
	localparam shfRL = 2'b11;
	
	
	input [15:0] In;
	input [3:0] Cnt;
	input [1:0] Op;
	output reg [15:0]  Out;

	wire [15:0] shiftLeftResult;
	wire [15:0] shiftRightLogical;
	wire [15:0] shiftRightArithmetic;
	wire [15:0] rotateLeftResult;

	shiftLeft SHFT1(In, Cnt, shiftLeftResult);
	shiftRight_Logical SHFT_RL(In, Cnt, shiftRightLogical);
	shiftRight_Arithmetic SHFT_RA(In, Cnt, shiftRightArithmetic);
	rotateLeft ROTL(In, Cnt, rotateLeftResult);

	always@(*) begin
	   case(Op)
		rotL: assign Out = rotateLeftResult;
		shfL: assign Out = shiftLeftResult;
		shfRA: assign Out = shiftRightArithmetic;
		shfRL: assign Out = shiftRightLogical;
		default: Out = 16'hx;
	   endcase
	end
	   
endmodule
