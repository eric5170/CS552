module control_unit(	instr, 
			isNotHalt, 
			isNOP,  
			isType,  
			isJAL,  
			isJR,  
			isJump,  
			isBranch, 
			isMemToReg, 
			isMemRead, 
			ALUop, 
			isMemWrite, 
			ALU_src, 
			isRegWrite	);

input [15:0] instr;

// 4 instr types:
// 0 = J
// 1 = I-1
// 2 = I-2
// 3 = R
output [1:0] isType;

// Control signals
output wire isNotHalt;
output isNOP;
output isJAL;
output isJR;
output wire isJump;
output isBranch;
output isMemToReg; 
output isMemRead;
output [3:0] ALUop;
output isMemWrite; 
output ALU_src;
output isRegWrite;

// Intermediate control signals
reg isNotHalt_i;
reg isNOP_i;
reg isJAL_i;
reg isJR_i;
reg isJump_i;
reg isBranch_i;
reg isMemToReg_i; 
reg isMemRead_i;
reg [3:0] ALUop_i;
reg isMemWrite_i; 
reg ALU_src_i;
reg isRegWrite_i;
reg [1:0] isType_i;

// Assign outputs:

assign isJAL = isJAL_i;
assign isJR = isJR_i;
assign isJump = isJump_i;
assign isBranch = isBranch_i;
assign isMemToReg = isMemToReg_i;
assign isMemRead = isMemRead_i;
assign ALUop = ALUop_i;
assign isMemWrite = isMemWrite_i;
assign ALU_src = ALU_src_i;
assign isRegWrite = isRegWrite_i;
assign isType = isType_i;

// Opcodes and operations
// wire [1:0]alu_op_sel;
wire [4:0] opcode;
reg [3:0] alu_op;
reg [3:0] shift_rot_op;
wire [1:0] func;

assign func = instr[1:0];
assign opcode = instr[15:11];
assign isNotHalt = isNotHalt_i;
assign isNOP = isNOP_i;

// Logic to determine ALU operations
// ADD, SUB, XOR, ANDN
// ROL, SLL, ROR, SRL
//ALU operation logic
always@(*) begin
	case(func)
		2'b00: begin
			alu_op = 4'h0; //ADD
			shift_rot_op = 4'h4; //SLL
		end
		2'b01: begin
			alu_op = 4'h1; //SUB
			shift_rot_op = 4'h5; //SRL
		end
		2'b10: begin
			alu_op = 4'h7; //XOR
			shift_rot_op = 4'h2; //ROL
		end
		2'b11: begin
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
		5'b00000: begin			/************************************ isNotHalt */
					// Everything 0  since Halt
					isType_i = 0;
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
		5'b00001: begin			/************************************ NOP */
					// NOP
					isType_i = 0;
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
		5'b00100: begin			/************************************ J */
					isType_i = 0;
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 1;				// isJump instr
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b00110: begin			/************************************ JAL */
					isType_i = 0;
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 1;  		// Writing to R7
					isJR_i = 0;
					isJump_i = 1;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// Writing to reg R7
				 end
		5'b01000: begin			/************************************ ADDI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4'd0;		// ALU OP 0
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Add immediate
					isRegWrite_i = 1;		// Rd <- Rs + I(zero ext.)
				 end
		5'b01001: begin			/************************************ SUBI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 1;		// ALU OP 1
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Sub immediate
					isRegWrite_i = 1;		// Rd <- I(sign ext.) - Rs
				 end
		5'b01010: begin			/************************************ XORI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 7;		// ALU OP 7
					isMemWrite_i = 0;
					ALU_src_i = 1;			// xor immediate
					isRegWrite_i = 1;		// Rd <- Rs XOR I(zero ext.)
				 end
		5'b01011: begin			/************************************ ANDNI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 13;		// ALU OP 13
					isMemWrite_i = 0;
					ALU_src_i = 1;			// AND NOT immediate 
					isRegWrite_i = 1;		// Rd <- Rs AND ~I(zero ext.)
				 end
		5'b10100: begin			/************************************ ROLI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 2;		// ALU OP 2
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Rotate left by immediate 
					isRegWrite_i = 1;		// Rd <- Rs << (rotate) I(lowest 4 bits)
				 end
		5'b10101: begin			/************************************ SLLI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4;		// ALU OP 4
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Shift left by immediate 
					isRegWrite_i = 1;		// Rd <- Rs << I(lowest 4 bits)
				 end
		5'b10110: begin			/************************************ RORI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 3;		// ALU OP 3	
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Rotate right by immediate 
					isRegWrite_i = 1;		// Rd <- Rs >> (rotate) I(lowest 4 bits)
				 end
		5'b10111: begin			/************************************ SRLI */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i <= 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 5;		// ALU OP 5
					isMemWrite_i = 0;
					ALU_src_i =  1;			// Shift right by immediate 
					isRegWrite_i = 1;		// Rd <- Rs >> I(lowest 4 bits)
				 end
		5'b10000: begin			/************************************ ST */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;		// ALU OP 0
					isMemWrite_i = 1;		// STORE writes to memory
					ALU_src_i = 1;			// Offset memory by immediate
					isRegWrite_i = 0;		// NO REG WRITE:	Mem[Rs + I(sign ext.)] <- Rd
				 end
		5'b10001: begin			/************************************ LD */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 1;		// Reading from memory, writing to REG
					isMemRead_i = 1;			// LOAD reads from memory
					ALUop_i = 0;		// ALU OP 0
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Offset memory by immediate
					isRegWrite_i = 1;		// Rd <- Mem[Rs + I(sign ext.)]
				 end
		5'b10011: begin			/************************************ STU */
					isType_i = 1;		// Format I-1 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;		// ALU OP 0
					isMemWrite_i = 1;		// STU writes to memory
					ALU_src_i = 1;			// Offset memory by immediate
					isRegWrite_i = 1;		// Mem[Rs + I(sign ext.)] <- Rd, Rs <- Rs + I(ssign ext.)
				 end
		5'b11000: begin			/************************************ LBI */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4'hE;		// ALU OP 14
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Immediate is read into reg
					isRegWrite_i = 1;			// Rs <- I(sign ext.)
				 end
		5'b10010: begin			/************************************ SLBI */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4'hC;		// ALU OP 12
					isMemWrite_i = 0;
					ALU_src_i = 1;			// Immediate user for OR
					isRegWrite_i = 1;		// Rs <- (Rs << 8) | I(zero ext.)
				 end
		5'b00101: begin			/************************************ JR */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 1;			// Reading from Rs
					isJump_i = 1;				// isJump instr
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b00111: begin			/************************************ JALR */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 1;  		// Writing to R7
					isJR_i = 1;			// Reading from Rs
					isJump_i = 1;				// isJump instr
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// Writing to reg R7
				 end
		5'b01100: begin			/************************************ BEQZ */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 1;			// isBranch INSTR
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b01101: begin			/************************************ BNEZ */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 1;			// isBranch INSTR
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b01110: begin			/************************************ BLTZ */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 1;			// isBranch INSTR
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b01111: begin			/************************************ BGEZ */
					isType_i = 2;		// Format I-2 instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 1;			// isBranch INSTR
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;
				 end
		5'b11001: begin			/************************************ BTR */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 6;			// ALU OP 6
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// Rd[bit i] <- Rs[bit 15-i] for i = 0..15
				 end
		5'b11011: begin			/************************************ ADD, SUB, XOR, ANDN */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = alu_op;		// ALU OP (decided in case statement)
					isMemWrite_i = 0;
					ALU_src_i = 0;			// ALU src 0: Reading from 2 regs
					isRegWrite_i = 1; 		// Rd <- Rs + Rt (for add)
				 end
		5'b11010: begin			/************************************ ROL, SLL, ROR, SRL */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1;  
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = shift_rot_op;	// Shift/ROTATE OP (decided in case statement)
					isMemWrite_i = 0;
					ALU_src_i = 0;			// ALU src 0: Reading from 2 regs
					isRegWrite_i = 1;		// Rd <- Rs << (rotate) Rt (lowest 4 bits)
				 end
		5'b11100: begin			/************************************ SEQ */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 8;		// ALU OP 8
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// if (Rs == Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11101: begin			/************************************ SLT */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 9;		// ALU OP 9
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// if (Rs < Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11110: begin			/************************************ SLE */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4'hA;		// ALU OP 10
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// if (Rs <= Rt) then Rd <- 1 else Rd <- 0
				 end
		5'b11111: begin			/************************************ SCO */
					isType_i = 3;		// Format R instr
					isNotHalt_i = 1;   
					isNOP_i = 0;
					isJAL_i = 0;  
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 4'hB;		// ALU OP 11
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 1;		// Writing Rd
				 end
   		default: begin
					isType_i = 0;               // Format R instr
                    isNotHalt_i = 1; 
					isNOP_i = 0;
					isJAL_i = 0;
					isJR_i = 0;
					isJump_i = 0;
					isBranch_i = 0;
					isMemToReg_i = 0;
					isMemRead_i = 0;
					ALUop_i = 0;                // ALU OP 11
					isMemWrite_i = 0;
					ALU_src_i = 0;
					isRegWrite_i = 0;         // Writing Rd
				end
	endcase
end

endmodule
