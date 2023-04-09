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
	wire stall, isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite, ALU_src, isRegWrite, flush;
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
	wire isNotHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX, ALU_src_DX, isRegWrite_DX;
	
	// Execute to Memory
	wire [15:0] ALURes_EM, PC_2_EM,rdData2_EM;
	wire [2:0] writeRegSel_EM;
	wire isNotHalt_EM, isJAL_EM, isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM;
	
	// Memory to WriteBack
	wire [15:0] rFm_MW, ALURes_MW, PC_2_MW;
	wire [2:0] writeRegSel_MW;
	wire isJAL_MW, isMemToReg_MW, isRegWrite_MW, isNotHalt_MW;
	
	wire [15:0] PC_test, instr_in;
	
	//wire en_new;
	//assign en_new =  ~stall;
	
	//PC_DFF
	register_16b PC_reg(.en(~stall), .clk(clk), .rst(rst), .data_in(PC_test), .state(currPC));
	
	// register file to load
	//register iREG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));

	// load instruction from current pc, gets next pc
	fetch fetch0(.clk(clk), 
				.rst(rst), 
				.currPC(currPC), 
				.nextPC(PC_2), 
				.instr(instr));

	assign instr_in  =  flush ? 16'h0800 : instr;
	assign PC_test =  flush ? PC_next : PC_2;
	
	
	// Fetch to Decode
	I2D fetch_to_decode (.en(~stall), 
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
							.writeRegSel_MW(writeRegSel_MW),
                            .readRegSel1(readRegSel1), 
                            .readRegSel2(readRegSel2), 
                            .isRegWrite_DX(isRegWrite_DX),
                            .isRegWrite_EM(isRegWrite_EM),
							.isRegWrite_MW(isRegWrite_MW),
                            .stall(stall));

	decode decode0(.clk(clk), 
				   .rst(rst), 
				   .stall(stall), 
				   .isRegWrite_MW(isRegWrite_MW),
				   .currPC(currPC_next), 
				   .instr(instr_next), 
				   .new_addr(PC_2_next), 
				   .writeData(writeData), 
				   .isNotHalt(isNotHalt),  
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
		// ADD STALL AND FLUSH TO DECODE

// TODO: ID/EX, TODO: STALL, WRITEREGSEL, VARIABLE NAMES
// pc_plus_2 to PC_2
D2X ID_EX_PIPE(.clk(clk), 
				.rst(rst), 
				.en(1'b1), 
				.PC_2(PC_2_next), 
				.isNotHalt(isNotHalt), 
				.isJAL(isJAL),	
				.isMemToReg(isMemToReg), 
				.isMemRead(isMemRead), 
				.isMemWrite(isMemWrite), 
				.ALU_src(ALU_src),    
				.isRegWrite(isRegWrite), 
				.ALUop(ALUop), 
				.imm(immed), 
				.readData2(rdData2), 
				.readData1(rdData1),	
				.writeRegSel(writeRegSel), 
				.PC_2_DX(PC_2_DX), 
				.isNotHalt_DX(isNotHalt_DX),	
				.isJAL_DX(isJAL_DX), 
				.isMemToReg_DX(isMemToReg_DX), 
				.isMemRead_DX(isMemRead_DX),	
				.isMemWrite_DX(isMemWrite_DX), 
				.ALU_src_DX(ALU_src_DX), 
				.isRegWrite_DX(isRegWrite_DX),	
				.ALUop_DX(ALUop_DX), 
				.imm_DX(immed_DX), 
				.readData2_DX(rdData2_DX),	
				.readData1_DX(rdData1_DX), 
				.writeRegSel_DX(writeRegSel_DX));

// ALUSRC, ALUop, rdData1, rdData2, ALURes, extOutput
execute execute0 (.ALU_src(ALU_src_DX),
				  .ALU_Op(ALUop_DX), 
				  .rd_data1(rdData1_DX), 
				  .rd_data2(rdData2_DX), 
				  .extOut(immed_DX), 
				  .ALU_res(ALURes), 
				  .zero(), 
				  .ofl());

// EX/MEM Pipeline Register
E2M EX_MEM_PIPE(.clk(clk),
			    .rst(rst), 
				.en(1'b1), 
				.ALURes(ALURes), 
				.PC_2(PC_2_DX), 	
				.isNotHalt(isNotHalt_DX), 
				.isJAL(isJAL_DX), 
				.isMemToReg(isMemToReg_DX),	
				.isMemRead(isMemRead_DX), 
				.isMemWrite(isMemWrite_DX),
				.isRegWrite(isRegWrite_DX), 
				.rdData2(rdData2_DX), 
				.writeRegSel(writeRegSel_DX),
				.ALURes_EM(ALURes_EM), 
				.isNotHalt_EM(isNotHalt_EM), 
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
				.isNotHalt(isNotHalt_MW), 
				.isMemWrite(isMemWrite_EM), 
				.ALU_res(ALURes_EM), 
				.writeData(rdData2_EM), 
				.isMemRead(isMemRead_EM), 
				.rd_data(rFm));
	// Change rd_data?

M2W MEM_Wb_PIPE(.clk(clk), 
				.rst(rst), 
				.en(1'b1), 
				.isNotHalt(isNotHalt_EM), 
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
				.isNotHalt_MW(isNotHalt_MW));

wb wb0(.readData(rFm_MW), 
		.isMemToReg(isMemToReg_MW), 
		.isMemRead(isMemRead), 
		.aluResult(ALURes_MW), 
		.nextPC(PC_2_MW), 
		.isJAL(isJAL_MW), 
		.writeData(writeData), 
		.writeRegSel(writeRegSel_MW), 
		.writeReg(writeReg));
	// CHANGE NEXTPC TO PC_NEXT

   
   
endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
