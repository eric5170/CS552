/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall control unit of the decode stage of the processor.
*/
`default_nettype none
module control (instr,isNotHalt,isJump,isIType1,isSignExtend, isJR, isJAL, isBranch, memToReg,memRead, memWrite, ALU_op, branch_op, ALU_src, RegWrite, RegDist);

// instruction received
input wire [15:0] instr;

// control signals that result from the instruction
output wire isNotHalt, isJump,isIType1,isSignExtend, isJR, isJAL, isBranch, memToReg,memRead, memWrite, branch_op, ALU_src, RegWrite, RegDist;
output wire [3:0] ALU_op;

// operations
wire [4:0] opcode;
wire [1:0] func;
reg [3:0] aluOp;
reg [3:0] rotOp;

assign opcode = instr[15:11];
assign func = instr[1:0];

// I-format 1
localparam	ADDI 		= 5'b01000; 
localparam 	SUBI 		= 5'b01001; 
localparam	XORI 		= 5'b01010; 
localparam 	ANDNI 		= 5'b01011; 
localparam	ROLI  		= 5'b10100; 
localparam 	SLLI 		= 5'b10101; 
localparam	RORI 		= 5'b10110; 
localparam 	SRLI 		= 5'b10111; 
localparam	ST 			= 5'b10000; 
localparam 	LD 			= 5'b10001; 
localparam	STU 		= 5'b10011; 

//R format
localparam 	BTR 		= 5'b11001; 

//ALU for simple math
localparam	ALU_1 		= 5'b11011; 
localparam 	ADD 		= 2'b00; 
localparam 	SUB 		= 2'b01;
localparam 	XOR 		= 2'b10;
localparam 	ANDN 		= 2'b11;

//ALU for shft/rot
localparam	ALU_2 		= 5'b11010; 
localparam 	SLL 		= 2'b00;
localparam 	SRL 		= 2'b01;
localparam 	ROL 		= 2'b10;
localparam 	ROR 		= 2'b11;

localparam SEQ			= 5'b11100;
localparam SLT			= 5'b11101;
localparam SLE			= 5'b11110;
localparam SCO			= 5'b11111;

// I-format 2
localparam 	BEQZ 		= 5'b01100;
localparam 	BNEZ 		= 5'b01101;
localparam 	BLTZ 		= 5'b01110;
localparam 	BGEZ 		= 5'b01111;
localparam 	LBI 		= 5'b11000;
localparam 	SLBI 		= 5'b10010;
localparam 	J 			= 5'b00100;
localparam 	JR 			= 5'b00101;

// J-format
localparam 	JAL 		= 5'b00110;
localparam 	JALR 		= 5'b00111;

// Special instructions
localparam 	SIIC  		= 5'b00010;
localparam 	NOP 		= 5'b00001;
localparam 	NOP_RTI 	= 5'b00011;
localparam 	HALT 		= 5'b00000;

//using case statement to set control signals for each of the instructions above
always @(opcode) begin
   deafult:
	isNotHalt = 1'b1;
	isJump = 1'b0;
	isIType1 = 1'b0;
	isSignExtend = 1'b0;
	isJR = 1'b0;
	isJAL = 1'b0;
	isBranch = 1'b0;
	memToReg = 1'b0;
	memRead = 1'b0;
	memWrite = 1'b0;
    ALU_op = 1'b0; //whether it's ALU_1 or ALU_2
   //TODO: work on this.
   
endmodule
`default_nettype wire

