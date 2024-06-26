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

	// register file to load
	register iREG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));

	// load instruction from current pc, gets next pc
	fetch fetch0(.clk(clk), .rst(rst), .PC(currPC), .nextPC(PC_2), .instr(instr));

	// decodes the instructions, sets signals for control unit
	decode decode0(.clk(clk), .rst(rst), .instr(instr), .currPC(currPC), .new_addr(PC_2),
					.writeData(wr_data), .isNotHalt(isNotHalt), .isNOP(isNOP), .isJAL(isJAL),  
					.isJR(isJR), .isJump(isJump), .isBranch(isBranch), .isMemToReg(isMemToReg), 
					.isMemRead(isMemRead), .ALU_Op(ALUop), .isMemWrite(isMemWrite), 
					.ALU_src(ALUSrc), .isRegWrite(isRegWrite), .immed(immed),
					.rd_data1(rdData1), .rd_data2(rdData2), .PC_next(PC_next));
	
	// executes using ALU
	execute execute0(.ALU_src(ALUSrc), .ALU_Op(ALUop), .extOut(immed), .rd_data1(rdData1), 
					.rd_data2(rdData2), .ALU_res(ALURes),.zero(), .ofl());

	// retrieves the data to memory
	memory memory0 (.clk(clk), .rst(rst), .isNotHalt(isNotHalt), .isMemWrite(isMemWrite), 
					.isMemRead(isMemRead), .ALU_res(ALURes), .rd_data(rFm), .writeData(rdData2));

	// reads data from memory and write when Enabled
	wb wb0(.readData(rFm), .isMemToReg(isMemToReg), .isMemRead(isMemRead), .aluResult(ALURes),
					.isJAL(isJAL), .nextPC(PC_2), .writeEn(isRegWrite), .writeData(wr_data));

   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
