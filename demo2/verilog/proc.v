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
	wire stall, isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite, ALUSrc, isRegWrite, flush;
	wire [3:0] ALUop;
	wire [15:0] instr, wr_data, ALURes, rFm,rdData1, rdData2, immed, currPC, PC_next, PC_2;
	wire [1:0] num;
	wire[2:0] readRegSel1, readRegSel2, writeReg;
	
	
	// Fetch to Decode
	wire [2:0] instr_FD, PC_2_FD, currPC_FD, instr_flush;
	
	// Decode to Execute
	wire [15:0] PC_2_DX, imm_DX, readData1_DX, readData2_DX;
	wire [3:0] ALUop_DX;
	wire [2:0] writeRegSel_DX;
	wire isNotHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX, ALU_src_DX, isRegWrite_DX;
	
	// Execute to Memory
	wire [15:0] ALURes_EM, PC_2_EM,rdData2_EM;
	wire [2:0] writeRegSel_EM;
	wire isNotHalt_EM, isJAL_EM, isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM;
	
	// Memory to WriteBack
	wire [15:0] rFm_MW, ALURes_MW, PC_2_MW;
	wire[2:0] writeRegSel_MW;
	wire isJAL_MW, isMemToReg_MW, isRegWrite_MW, isNotHalt_MW;
	
	wire [15:0] PC_test, instr_in;
	
	wire en_new;
	assign en_new =  ~stall;
	
	register_p PC_reg(.en(en_new), .clk(clk), .rst(rst), .data_in(testPC), .state(currPC));
	
	// register file to load
	//register iREG(.clk(clk), .rst(rst), .data_in(PC_next), .state(currPC));

	// load instruction from current pc, gets next pc
	fetch fetch0(.clk(clk), .rst(rst), .PC(currPC), .nextPC(PC_2), .instr(instr));

	assign instr_in  =  flush ? 16'h0800 : instr;
	assign PC_test =  flush ? PC_next : PC_2;
	
	// Fetch to Decode
	I2D fetch_to_decode (.en(en_new), .clk(clk), .rst(rst), .PC_2(PC_2), .instr(instr_in), .currPC(currPC), .instr_next(instr_FD), .PC_2_next(PC_2_FD), .currPC_next(currPC_FD));
	
	// hazard detection logic
	hazard_detect iDetect ( .instr(instr_FD),
                            .writeRegSel_DX(writeRegSel_DX), 
                            .writeRegSel_XM(writeRegSel_EM),
							.writeRegSel_MW(writeRegSel_MW),
                            .readRegSel1(, 
                            readRegSel2, 
                            isRegWrite_DX,
                            isRegWrite_XM,
                            stall(stall),
							

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
