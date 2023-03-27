/*
   CS/ECE 552 Spring '23
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (	//	INPUTS:
					
					//	Control Unit output to Execute (Exec) inputs
					Jump,
					isType1,
					SignExtend,
					JR,
					Branch,
					MemToReg,
					MemRead,
					MemWrite,
					ALU_Op,			//	4 bits
					Branch_Op,		//	2 bits
					ALUSrc,
					
					//	Register File Output to Exec inputs
					read_data_1,	//	16 bits
					read_data_2,	//	16 bits
					
					//	I Type 1 & 2, and J Type inputs
					instr,
					
					//	PC + 2 input
					incPC,
					
					//	OUTPUTS:
					
					//	Execute Outputs to Data Memory
					write_data,
					
					//	ALU output
					ALU_result,
					
					//	Exec Output to Fetch Stage
					next_PC);
					
	input wire	Jump, isType1, SignExtend, JR, Branch,
	MemToReg, MemRead, MemWrite, ALUSrc;
	
	input wire[3:0]	ALU_Op;
	input wire[1:0]	Branch_Op;
	
	input wire[15:0]	read_data_1, read_data_2, instr, incPC;
	
	output wire[15:0]	write_data,	ALU_result, next_PC;
	
	wire	ALU_B, IT1_sign_extend, IT1_zero_extend, IT1_extend,
			IT2_extend, IType, J_extend, 
			offset, inc_Offset, notJR_PC, zero, isTaken, toBranch;
			
	wire	IT1, IT2, J;
	
	assign	IT1	=	instr[4:0];
	assign	IT2 =	instr[7:0];
	assign	J	=	instr[10:0];
	
	assign	IT1_sign_extend = { {11{IT1[4]}}, IT1 };
	assign	IT1_zero_extend = { {11{1'b0}}, IT1 };
	mux2_1	ITYPE_EXTEND(.out(IT1_extend), .inputA(IT1_zero_extend),
		.inputB(IT1_sign_extend), .sel(SignExtend));
	
	assign	IT2_extend = { {8{IT2[7]}}, IT2 };
	mux2_1	ITYPE_MUX(.out(IType), .inputA(IT2_extend), 
		.inputB(IT1_extend), .sel(isType1));
	
	assign	J_extend = 	{ {5{J[10]}}, J };
	mux2_1 OFFSET_MUX(.out(offset), .inputA(J_extend),
		.inputB(IType), .sel(Branch));
	
	cla16b OFFSET_ADDER(.sum(inc_Offset), .cOut(), .inA(offset),
		.inB(incPC), .cIn(1'b0));
	
	assign isTaken = zero & Branch;
	
	assign toBranch = isTaken | Jump;
	
	mux2_1 NOTJR_MUX(.out(notJR_PC), .inputA(incPC), 
		.inputB(inc_Offset), .sel(toBranch));
	
	mux2_1 ALU_B_MUX (.out(ALU_B), .inputA(IType),
		.inputB(read_data_2), .sel(ALUSrc));
	
	aluhier(.InA(read_data_1), .InB(ALU_B), .Cin(),
		.Oper(ALU_Op), .sign(SignExtend), .Out(ALU_Result),
		.Zero(zero), .Of1());
	
	mux2_1 NEXT_PC_MUX(.out(next_PC), .inputA(notJR_PC),
		.inputB(ALU_Result), .sel(JR));
	
	assign	write_data = read_data_2;
	
   
endmodule
`default_nettype wire
