/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output reg err;

   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */
   wire HALT, Jump, isIType1, SignExtend, JR, Branch,
		MemToReg, MemRead, MemWrite, ALU_Op, Branch_Op,
		ALUSrc;
   
   wire[15:0]	instr, exec_Instr, currPC, incPC, nextPC, next_PC, 
	read_data, read_data_1, read_data_2, write_data,
	
   
   fetch	FETCH_STAGE(
							.clk(clk),
							.rst(rst),
							.currPC(currPC),
							.nextPC(nextPC),
							.instr(instr));
   
   decode	DECODE_STAGE(
						.clk(clk),
						.rst(rst),
						.instr(instr), 
						.currPC(currPC),
						.incPC(incPC),
						.writeback_data(writeback_data),
						.HALT(HALT),  
						.Jump(Jump),
						.isIType1(isIType1),
						.SignExtend(SignExtend),
						.JR(JR),
						.Branch(Branch), 
						.MemToReg(MemToReg), 
						.MemRead(MemRead), 
						.MemWrite(MemWrite), 
						.ALU_Op(ALU_Op), 
						.Branch_Op(Branch_Op),
						.ALUSrc(ALUSrc), 
						.read_data_1(read_data_1),
						.read_data_2(read_data_2),
						.exec_Instr(exec_Instr));
	
	excute	EXECUTION_STAGE(
								.Jump(Jump),
								.isType1(isType1),
								.SignExtend(SignExtend),
								.JR(JR),
								.Branch(Branch),
								.MemToReg(MemToReg),
								.MemRead(MemRead),
								.MemWrite(MemWrite),
								.ALU_Op(ALU_Op),	
								.Branch_Op(Branch_Op),
								.ALUSrc(ALUSrc),
								.read_data_1(read_data_1),
								.read_data_2(read_data_2),
								.instr(instr),
								.incPC(incPC),
								.write_data(write_data),
								.ALU_result(ALU_result),
								.next_PC(next_PC));
	
	memory	MEMORY_STAGE(
							.MemWrite(MemWrite),
							.MemRead(MemRead),
							.ALUResult(ALUResult),
							.read_data_2(read_data_2),
							.writeback_data(writeback_data),
							.read_data(read_data),
							.writeback_A(writeback_A));
							
	wb		WRITE_STAGE(
							.MemToReg(MemToReg),
							.read_data(writeback_A),
							.ALUResult(ALUResult),
							.writeback_data(writeback_data));
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
