/*
   CS/ECE 552 Spring '23
  
   Filename        : control.v
   Description     : This is the module for the overall control unit of the decode stage of the processor.
*/
`default_nettype none
module control (instr,isNotHalt, isNOP, isType, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, ALU_Op, isMemWrite, ALU_src, isRegWrite);

// instruction received
input wire [15:0] instr;

// control signals that result from the instruction
output wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite, ALU_src, isRegWrite;
output wire [1:0] isType;
output wire [3:0] ALU_Op;

// control signals in process
reg isNotHalt_reg, isNOP_reg, isJAL_reg, isJR_reg, isJump_reg, isBranch_reg, isMemToReg_reg, isMemRead_reg, isMemWrite_reg, ALU_src_reg, isRegWrite_reg;
reg [1:0] isType_reg;
reg [3:0] ALU_Op_reg;

// control signals at the end of process
assign isNotHalt = isNotHalt_reg;
assign isNOP = isNOP_reg;
assign isType = isType_reg;
assign isJAL = isJAL_reg;
assign isJR = isJR_reg;
assign isJump = isJump_reg;
assign isBranch = isBranch_reg;
assign isMemToReg = isMemToReg_reg;
assign isMemRead = isMemRead_reg;
assign isMemWrite = isMemWrite_reg;
assign ALU_src = ALU_src_reg;
assign ALU_Op = ALU_Op_reg;
assign isRegWrite = isRegWrite_reg;

// instruction opcode
wire [4:0] opcode;
// func determines which operation to do
wire [1:0] func;

// aluOp = ALU_1: ADD,SUB...
reg [3:0] addOp;
// rotOp = ALU_2: SLL, SRL...
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

// R-format 

localparam 	BTR 		= 5'b11001; 

localparam	ALU_1 		= 5'b11011; 
localparam 	ADD 		= 2'b00; 
localparam 	SUB 		= 2'b01;
localparam 	XOR 		= 2'b10;
localparam 	ANDN 		= 2'b11;

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

//ALU operation logic
always@(*) begin
	case(func)
		2'b00: begin
			addOp = 4'h0; //ADD
			rotOp = 4'h4; //SLL
		end
		2'b01: begin
			addOp = 4'h1; //SUB
			rotOp = 4'h5; //SRL
		end
		2'b10: begin
			addOp = 4'h7; //XOR
			rotOp = 4'h2; //ROL
		end
		2'b11: begin
			addOp = 4'hD; //ANDN
			rotOp = 4'h3; //ROR
		end
	endcase
end

always @(*) begin
	case(opcode)
		HALT: begin
			isNotHalt_reg = 0;
			isNOP_reg = 0;
			isType_reg = 0;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		NOP: begin
			isNotHalt_reg = 1;
			isNOP_reg = 1;
			isType_reg = 0;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		J: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 0;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 1;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		JAL: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 0;
			isJAL_reg = 1;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		ADDI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		SUBI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd1;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		XORI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd7;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		ANDNI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		
		ROLI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd2;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		SLLI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd4;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		RORI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd3;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		SRLI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd5;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		ST: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 1;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 1;
			isRegWrite_reg = 0;
		end
		LD: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		STU: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1; //I-1
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 1;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		LBI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2; //I-2
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'hE;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		SLBI: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'hC;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		JR: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 0;
			isJR_reg = 1;
			isJump_reg = 1;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		JALR: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 1;
			isJR_reg = 1;
			isJump_reg = 1;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		BEQZ: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2; 
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 1;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		BNEZ: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 1;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		BLTZ: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 1;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		BGEZ: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 2;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 1;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
		BTR: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 6;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		ALU_1: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = addOp;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		ALU_2: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = rotOp;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		SEQ: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd8;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		SLT: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd9;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		SLE: begin	
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'hA;
			ALU_src_reg = 0;
			isRegWrite_reg = 1;
		end
		SCO: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 3;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'hB;
			ALU_src_reg = 1;
			isRegWrite_reg = 1;
		end
		default: begin
			isNotHalt_reg = 1;
			isNOP_reg = 0;
			isType_reg = 1;
			isJAL_reg = 0;
			isJR_reg = 0;
			isJump_reg = 0;
			isBranch_reg = 0;
			isMemToReg_reg = 0;
			isMemRead_reg = 0;
			isMemWrite_reg = 0;
			ALU_Op_reg = 4'd0;
			ALU_src_reg = 0;
			isRegWrite_reg = 0;
		end
	endcase
end
   
endmodule
`default_nettype wire

