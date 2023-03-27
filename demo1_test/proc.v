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
   //control signals and other wires 
   wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite, ALUSrc, isRegWrite;
   wire [3:0] ALUop;
   wire [15:0] instr, wr_data, ALURes, rFm,rdData1, rdData2, immed, currPC, PC_next, PC_2;
   
   reg_dff iREG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));
   
   fetch iFetch(.clk(clk), .rst(rst), .currPC(currPC), .nextPC(PC_next), .instr(instr));
   
   decode iDecode(.clk(clk),
					.rst(rst),
					.instr(instr), 
					.currPC(currPC),
					.new_addr(PC_2),
					.wr_data(wr_data), 
					.NotHalt(isNotHalt),  
					.NOP(isNOP),  
					.JAL(isJAL),  
					.JR(isJR),  
					.Jump(isJump),  
					.branch(isBranch), 
					.memToReg(isMemToReg), 
					.memRead(isMemRead), 
					.ALU_Op(ALUop), 
					.memWrite(isMemWrite), 
					.ALU_src(ALUSrc), 
					.regWrite(isRegWrite),
					.imm(immed),
					.rd_data1(rdData1),
					.rd_data2(rdData2),
					.nextPC(PC_next)
					);
					
	 execute iExec(.ALU_src(ALUSrc), .ALU_Op(ALUop), .extOut(immed), .rd_data1(rdData1), 
	 .rd_data2(rdData2), .ALU_res(ALURes),.zero(), .ofl());
	 
	 memory iMem (.clk(clk), .rst(rst), .isNotHalt(isNotHalt), .isMemWrite(isMemWrite), 
	 .isMemRead(isMemRead), .ALU_res(ALURes), .rd_data(rFm), .wr_data(rdData2));
	 
	 wb iWb(.rd_data(rFm), .isMemToReg(isMemToReg), .isMemRead(isMemRead), .ALU_res(ALURes),
	 .isJAL(isJAL), .nextPC(PC_2), .wrEN(isRegWrite), .wr_data(wr_data));
 
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
