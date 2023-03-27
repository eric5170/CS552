/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

	wire isNotHalT;
	wire isNOP;
	wire isJAL;
	wire isJR;
	wire isJump;
	wire isBranch;
	wire isMemToReg; 
	wire isMemRead;
	wire [3:0] ALUop;
	wire isMemWrite; 
	wire ALU_src;
	wire isRegWrite;

	wire [15:0] rdData1, rdData2, immed, currPC, PC_next, PC_2;
	wire [15:0] instr, writeData, ALURes, rFm;
	
	// PC dff
	register PC_REG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));
   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */


fetch fetch0(.clk(clk), .rst(rst), .PC_current(currPC), .instr(instr), .PC_next(PC_2));


decode decode0(.clk(clk),
					.rst(rst),
					.instr(instr), 
					.currPC(currPC),
					.new_addr(PC_2),
					.writeData(writeData), 
					.isNotHalt(isNotHalt),  
					.isNOP(isNOP),  
					.isJAL(isJAL),  
					.isJR(isJR),  
					.isJump(isJump),  
					.isBranch(isBranch), 
					.isMemToReg(isMemToReg), 
					.isMemRead(isMemRead), 
					.ALUop(ALUop), 
					.isMemWrite(isMemWrite), 
					.ALU_src(ALU_src), 
					.isRegWrite(isRegWrite),
					.immed(immed),
					.rdData1(rdData1),
					.rdData2(rdData2),
					.PC_next(PC_next)
					);


execute execute0(
					.ALU_src(ALU_src), 
					.ALUop(ALUop), 
					.ReadData1(rdData1), 
					.ReadData2(rdData2), 
					.extOutput(immed), 
					.ALUResult(ALURes), 
					.Zero(), 
					.Ofl()
		);

memory memory0 (
					.clk(clk),
					.rst(rst),
					.isNotHalT(isNotHalT),
					.isMemWrite(isMemWrite),
					.aluResult(ALURes),
					.writeData(rdData2),
					.isMemRead(isMemRead),
					.readData(rFm)		
		);

wb wb0 (
					.readData(rFm),
					.isMemToReg(isMemToReg),
					.isMemRead(isMemRead),
					.aluResult(ALURes),
					.nextPC(PC_2),
					.isJAL(isJAL),
					.writeData(writeData),
					.writeEn(regWrite)		
		);

   
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
