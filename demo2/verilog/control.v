/*
   CS/ECE 552 Spring '23
  
   Filename        : control.v
   Description     : This is the module for control unit where all the signals are located.
*/
module control(instr, isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, 
					isMemRead, isMemWrite, ALUop, ALU_src, isRegWrite);


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
	//consists of ADD...
	localparam	ALU_1 		= 5'b11011; 
	localparam	ALU_2 		= 5'b11010; 
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

	//ALU instructions
	localparam ADD_SLL = 2'b00;
	localparam SUB_SRL = 2'b01;
	localparam XOR_ROL = 2'b10;
	localparam ANDN_ROR = 2'b11;

	// instruction 
	input [15:0] instr;

	// determine which type: J,I1,I2,R
	//output [1:0] isType;

	// other signals
	output wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite,
				ALU_src, isRegWrite;
				
	output wire[3:0] ALUop;



	//signals in process
	reg isNotHalt_i, isNOP_i, isJAL_i, isJR_i, isJump_i, isBranch_i, isMemToReg_i, isMemRead_i, isMemWrite_i,
		ALU_src_i, isRegWrite_i;
		

	reg [3:0] ALUop_i;

	// opcode from instr
	wire [4:0] opcode;
	assign opcode = instr[15:11];

	// function from instr
	wire [1:0] func;
	assign func = instr[1:0];

	// other opcodes to distinguish
	reg [3:0] alu_op;
	reg [3:0] shift_rot_op;

	// ALU operation logic
	// ADD = 0, SUB = 1, ROL = 2,  ROR = 3, SLL = 4 , SRL =5, XOR = 7, ANDN = D
	always@(*) begin
		case(func)
			ADD_SLL: begin
				alu_op = 4'h0; //ADD
				shift_rot_op = 4'h4; //SLL
			end
			SUB_SRL: begin
				alu_op = 4'h1; //SUB
				shift_rot_op = 4'h5; //SRL
			end
			XOR_ROL: begin
				alu_op = 4'h7; //XOR
				shift_rot_op = 4'h2; //ROL
			end
			ANDN_ROR: begin
				alu_op = 4'hD; //ANDN
				shift_rot_op = 4'h3; //ROR
			end
			//if func not in these values --> err
			default: begin
				alu_op = 4'hx;
				shift_rot_op = 4'hx;
			end
		endcase
	end


	always@(*) begin
		case(opcode)
			HALT: begin			
				// Everything 0  since Halt
				isNotHalt_i = 0;  
				isNOP_i = 0;
				isJAL_i = 0;  
				isJR_i = 0;
				isJump_i = 0;
				isBranch_i = 0;
				isMemToReg_i = 0;
				isMemRead_i = 0;
				ALUop_i = 0;
				isMemWrite_i = 0;
				ALU_src_i = 0;
				isRegWrite_i = 0;
			end
					 
			NOP: begin			
				isNotHalt_i = 1;  
				isNOP_i = 1;
				isJAL_i = 0;  
				isJR_i = 0;
				isJump_i = 0;
				isBranch_i = 0;
				isMemToReg_i = 0;
				isMemRead_i = 0;
				ALUop_i = 0;
				isMemWrite_i = 0;
				ALU_src_i = 0;
				isRegWrite_i = 0;
			end
			J: begin			
				isNotHalt_i = 1;  
				isNOP_i = 0;
				isJAL_i = 0;  
				isJR_i = 0;
				isJump_i = 1;				
				isBranch_i = 0;
				isMemToReg_i = 0;
				isMemRead_i = 0;
				ALUop_i = 0;
				isMemWrite_i = 0;
				ALU_src_i = 0;
				isRegWrite_i = 0;
			end
					 
			JAL: begin
				isNotHalt_i = 1;  
				isNOP_i = 0;
				isJAL_i = 1;  		
				isJR_i = 0;
				isJump_i = 1;
				isBranch_i = 0;
				isMemToReg_i = 0;
				isMemRead_i = 0;
				ALUop_i = 0;
				isMemWrite_i = 0;
				ALU_src_i = 0;
				isRegWrite_i = 1;	//write to R7
			end
					 
			ADDI: begin	
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4'b0000;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			// immediate
						isRegWrite_i = 1;		
					 end
					 
			SUBI: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 1;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			XORI: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 7;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			ANDNI: begin			
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 13;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			ROLI: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 2;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			SLLI: begin			
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			RORI: begin		
						 		
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 3;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			SRLI: begin			
						isNotHalt_i <= 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 5;		
						isMemWrite_i = 0;
						ALU_src_i =  1;			
						isRegWrite_i = 1;		
					 end
					 
			ST: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;		
						isMemWrite_i = 1;		
						ALU_src_i = 1;			
						isRegWrite_i = 0;		
					 end
					 
			LD: begin			
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 1;		
						isMemRead_i = 1;			
						ALUop_i = 0;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			STU: begin		
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;		
						isMemWrite_i = 1;		
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			LBI: begin		
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4'hE;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;			
					 end
					 
			SLBI: begin		
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4'hC;		
						isMemWrite_i = 0;
						ALU_src_i = 1;			
						isRegWrite_i = 1;		
					 end
					 
			JR: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 1;			
						isJump_i = 1;				// still "jump"s
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;
					 end
					 
			JALR: begin			
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 1;  		
						isJR_i = 1;			
						isJump_i = 1;				// still "jump"s
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			BEQZ: begin		
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 1;			
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;
					 end
					 
			BNEZ: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 1;			
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;
					 end
					 
			BLTZ: begin			
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 1;			
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;
					 end
					 
			BGEZ: begin			
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 1;			
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;
					 end
					 
			BTR: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 6;			
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			ALU_1: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = alu_op;		
						isMemWrite_i = 0;
						ALU_src_i = 0;			
						isRegWrite_i = 1; 		
					 end
					 
			ALU_2: begin			
						isNotHalt_i = 1;  
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = shift_rot_op;
						isMemWrite_i = 0;
						ALU_src_i = 0;			
						isRegWrite_i = 1;	
					 end
					 
			SEQ: begin		
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 8;		
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			SLT: begin		
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 9;		
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			SLE: begin			
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4'hA;		
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			SCO: begin			
						isNotHalt_i = 1;   
						isNOP_i = 0;
						isJAL_i = 0;  
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 4'hB;		
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 1;		
					 end
					 
			default: begin
						isNotHalt_i = 1; 
						isNOP_i = 0;
						isJAL_i = 0;
						isJR_i = 0;
						isJump_i = 0;
						isBranch_i = 0;
						isMemToReg_i = 0;
						isMemRead_i = 0;
						ALUop_i = 0;               
						isMemWrite_i = 0;
						ALU_src_i = 0;
						isRegWrite_i = 0;         
					end
		endcase
	end

	// assign signals to modify
	assign ALUop = ALUop_i;
	assign isNotHalt = isNotHalt_i;
	assign isNOP = isNOP_i;
	assign isJAL = isJAL_i;
	assign isJR = isJR_i;
	assign isJump = isJump_i;
	assign isBranch = isBranch_i;
	assign isMemToReg = isMemToReg_i;
	assign isMemRead = isMemRead_i;
	assign isMemWrite = isMemWrite_i;
	assign ALU_src = ALU_src_i;
	assign isRegWrite = isRegWrite_i;


endmodule
