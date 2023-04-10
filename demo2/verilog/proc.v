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
	wire stall, isHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite, ALU_src, isRegWrite, flush;
	wire [3:0] ALUop;
	wire [15:0] instr, writeData, ALURes, rFm,rdData1, rdData2, immed, currPC, PC_next, PC_2;
	wire [1:0] num;
	wire[2:0] readRegSel1, readRegSel2, writeReg, writeRegSel;
	
	
	// Fetch to Decode
	wire [15:0] instr_next, PC_2_next, currPC_next;
	
	// Decode to Execute
	wire [15:0] PC_2_DX, rdData1_DX, rdData2_DX, immed_DX;
	wire [3:0] ALUop_DX;
	wire [2:0] writeRegSel_DX;
	wire isHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX, ALU_src_DX, isRegWrite_DX;
	
	// Execute to Memory
	wire [15:0] ALURes_EM, PC_2_EM,rdData2_EM;
	wire [2:0] writeRegSel_EM;
	wire isHalt_EM, isJAL_EM, isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM;
	
	// Memory to WriteBack
	wire [15:0] rFm_MW, ALURes_MW, PC_2_MW;
	wire [2:0] writeRegSel_MW;
	wire isJAL_MW, isMemToReg_MW, isRegWrite_MW, isHalt_MW;
	
	wire [15:0] PC_test, instr_in;
	
	wire en_new;
	assign en_new =  ~stall;
	
	
	register16b iPC_reg(.en(en_new), .clk(clk), .rst(rst), .data_in(PC_test), .state(currPC));
	
	// register file to load
	//register iREG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));

	// load instruction from current pc, gets next pc
	fetch fetch0(.clk(clk), 
				.rst(rst), 
				.currPC(currPC), 
				.nextPC(PC_2), 
				.instr(instr));
	
	// stalling 
	wire [15:0] stall_PC;
	assign stall_PC = 16'h0800;
	
	mux2_1 INSTR_IN_MUX([15:0] (.out(instr_in), .inputA(instr), .inputB(stall_PC), .sel(flush));
	mux2_1 PC_TEST_MUX [15:0] (.out(PC_test), .inputA(PC_2), .inputB(PC_next), .sel(flush));
	
	
	// Fetch to Decode
	I2D fetch_to_decode (.en(en_new), 
						 .clk(clk), 
						 .rst(rst), 
						 .PC_2(PC_2), 
						 .instr(instr_in), 
						 .currPC(currPC), 
						 .instr_next(instr_next), 
						 .PC_2_next(PC_2_next), 
						 .currPC_next(currPC_next));
	
	// hazard detection logic
	hazard_detect iDetect( .instr(instr_next),
                            .writeRegSel_DX(writeRegSel_DX), 
                            .writeRegSel_EM(writeRegSel_EM),
                            .readRegSel1(readRegSel1), 
                            .readRegSel2(readRegSel2), 
                            .isRegWrite_DX(isRegWrite_DX),
                            .isRegWrite_EM(isRegWrite_EM),
                            .stall(stall));

	decode decode0(.clk(clk), 
				   .rst(rst), 
				   .stall(stall), 
				   .isRegWrite_MW(isRegWrite_MW),
				   .currPC(currPC_next), 
				   .instr(instr_next), 
				   .new_addr(PC_2_next), 
				   .writeData(writeData), 
				   .isHalt(isHalt),  
				   .isNOP(isNOP), 
				   .isJAL(isJAL), 
				   .isJR(isJR), 
				   .isJump(isJump), 
				   .isBranch(isBranch), 
				   .isMemToReg(isMemToReg), 
				   .isMemRead(isMemRead), 
				   .ALU_Op(ALUop), 	
				   .isMemWrite(isMemWrite), 
				   .ALU_src(ALU_src), 
				   .isRegWrite(isRegWrite), 
				   .immed(immed),		
				   .rd_data1(rdData1), 
				   .rd_data2(rdData2), 
				   .writeRegSel(writeRegSel),
				   .writeReg(writeReg),		
				   .PC_next(PC_next), 
				   .read_reg1(readRegSel1), 
				   .read_reg2(readRegSel2), 
				   .flush(flush));

	D2X Decode_to_Execute(.clk(clk), 
					.rst(rst), 
					.en(1'b1), 
					.PC_2(PC_2_next), 
					.isHalt(isHalt), 
					.isJAL(isJAL),	
					.isMemToReg(isMemToReg), 
					.isMemRead(isMemRead), 
					.isMemWrite(isMemWrite), 
					.ALU_src(ALU_src),    
					.isRegWrite(isRegWrite), 
					.ALUop(ALUop), 
					.immed(immed), 
					.readData2(rdData2), 
					.readData1(rdData1),	
					.writeRegSel(writeRegSel), 
					.PC_2_DX(PC_2_DX), 
					.isHalt_DX(isHalt_DX),	
					.isJAL_DX(isJAL_DX), 
					.isMemToReg_DX(isMemToReg_DX), 
					.isMemRead_DX(isMemRead_DX),	
					.isMemWrite_DX(isMemWrite_DX), 
					.ALU_src_DX(ALU_src_DX), 
					.isRegWrite_DX(isRegWrite_DX),	
					.ALUop_DX(ALUop_DX), 
					.immed_DX(immed_DX), 
					.readData2_DX(rdData2_DX),	
					.readData1_DX(rdData1_DX), 
					.writeRegSel_DX(writeRegSel_DX));

	execute execute0 (.ALU_src(ALU_src_DX),
					  .ALU_Op(ALUop_DX), 
					  .rd_data1(rdData1_DX), 
					  .rd_data2(rdData2_DX), 
					  .extOut(immed_DX), 
					  .ALU_res(ALURes), 
					  .zero(), 
					  .ofl());

	// EX/MEM Pipeline Register
	E2M Execute_to_Memory(.clk(clk),
					.rst(rst), 
					.en(1'b1), 
					.ALURes(ALURes), 
					.PC_2(PC_2_DX), 	
					.isHalt(isHalt_DX), 
					.isJAL(isJAL_DX), 
					.isMemToReg(isMemToReg_DX),	
					.isMemRead(isMemRead_DX), 
					.isMemWrite(isMemWrite_DX),
					.isRegWrite(isRegWrite_DX), 
					.rdData2(rdData2_DX), 
					.writeRegSel(writeRegSel_DX),
					.ALURes_EM(ALURes_EM), 
					.isHalt_EM(isHalt_EM), 
					.PC_2_EM(PC_2_EM),
					.isJAL_EM(isJAL_EM), 
					.isMemToReg_EM(isMemToReg_EM), 
					.isMemRead_EM(isMemRead_EM),
					.isMemWrite_EM(isMemWrite_EM), 
					.isRegWrite_EM(isRegWrite_EM),
					.rdData2_EM(rdData2_EM), 
					.writeRegSel_EM(writeRegSel_EM));

	memory memory0 (.clk(clk), 
					.rst(rst), 
					.isHalt(isHalt_MW), 
					.isMemWrite(isMemWrite_EM), 
					.ALU_res(ALURes_EM), 
					.writeData(rdData2_EM), 
					.isMemRead(isMemRead_EM), 
					.rd_data(rFm));
		

	M2W Memory_to_WriteBack(.clk(clk), 
					.rst(rst), 
					.en(1'b1), 
					.isHalt(isHalt_EM), 
					.rFm(rFm), 	
					.ALURes(ALURes_EM), 
					.PC_2(PC_2_EM), 
					.isJAL(isJAL_EM), 
					.isMemToReg(isMemToReg_EM), 
					.isRegWrite(isRegWrite_EM), 
					.writeRegSel(writeRegSel_EM), 
					.rFm_MW(rFm_MW), 
					.ALURes_MW(ALURes_MW), 
					.PC_2_MW(PC_2_MW), 
					.isJAL_MW(isJAL_MW),
					.isMemToReg_MW(isMemToReg_MW), 
					.isRegWrite_MW(isRegWrite_MW), 
					.writeRegSel_MW(writeRegSel_MW), 
					.isHalt_MW(isHalt_MW));

	wb wb0(.readData(rFm_MW), 
			.isMemToReg(isMemToReg_MW),  
			.aluResult(ALURes_MW), 
			.nextPC(PC_2_MW), 
			.isJAL(isJAL_MW), 
			.writeData(writeData), 
			.writeRegSel(writeRegSel_MW), 
			.writeReg(writeReg));

	
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
