module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;
   
   
   // None of the above lines can be modified

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines
   
   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

	wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, 
		isMemToReg, isMemRead, isMemWrite, ALUSrc, isRegWrite, stall;
	wire [3:0] ALUop;
	wire [15:0] instr, wr_data, ALURes, rFm, rdData1, rdData2, immed, currPC, PC_next, PC_2;
	wire [1:0] num_reg_reads;

	wire flush;
	//wire [15:0] readData1, readData2, immediate, currPC, nextPC, pc_plus_2;
	//wire [15:0] instruction, writeData, aluResult, readFromMem;
	wire [15:0] instr_IF_ID, PC_2_IF_ID, currPC_IF_ID, flush_instr;
	
	wire [2:0] writeRegSel, readRegSel1, readRegSel2, writeReg;	// KEEP writeRegSel?

	wire [15:0] PC_2_ID_EX, immed_ID_EX, rdData1_ID_EX, rdData2_ID_EX;
	wire [2:0] writeRegSel_ID_EX;	//	KEEP?
	wire [3:0] ALUop_ID_EX;
	wire isNotHalt_ID_EX, isMemToReg_ID_EX, isMemRead_ID_EX, isMemWrite_ID_EX, 
		ALUsrc_ID_EX, isRegWrite_ID_EX;

	wire [15:0] aluResult_EX_MEM, PC_2_EX_MEM, rdData2_EX_MEM;
	wire [2:0] writeRegSel_EX_MEM;	// KEEP?
	wire isNotHalt_EX_MEM, isMemToReg_EX_MEM, isMemRead_EX_MEM, isMemWrite_EX_MEM, 
		ALUsrc_EX_MEM, isRegWrite_EX_MEM;

	wire [15:0] rFm_MEM_WB, aluResult_MEM_WB, PC_2_MEM_WB;
	wire [2:0] writeRegSel_MEM_WB;	//	KEEP?
	wire isMemToReg_MEM_WB, isRegWrite_MWB, isNotHalt_MEM_WB;

	wire [15:0] testPC;
	wire [15:0] instr_in;
	
	// PC DFF
	register_16b PC_REG(.en(~stall), .clk(clk), .rst(rst), .data_in(testPC), .state(currPC));

fetch fetch0 (
			.clk(clk),
			.rst(rst),
			.currPC(currPC),
			.nextPC(PC_2),
			.instruction(instr)
		);

assign instr_in = flush ? 16'h0800 : instruction;
assign testPC = flush ? nextPC: PC_2;

// IF/ID
IF_ID if_id(
			.en(~stall), 
			.clk(clk), 
			.rst(rst), 
			.currPC(currPC),
			.PC_2(PC_2), 
			.instr(instr_in), 
			.instr_IF_ID(inst_IF_ID), 
			.PC_2_IF_ID(PC_2_IF_ID),
			.currPC_IF_ID(currPC_IF_ID));
			
// TODO: Hazard Detection Unit // TODO:
hazard_detection_unit HD_unit(
			.instruction(instruction_FD),
			.writeRegSel_DX(writeRegSel_DX), 	//	KEEP?
			.writeRegSel_XM(writeRegSel_XM), 	//	KEEP?
			.writeRegSel_MWB(writeRegSel_MWB), //	KEEP?
			.readRegSel1(readRegSel1), 
			.readRegSel2(readRegSel2), 
			.regWrite_DX(regWrite_DX),
			.regWrite_XM(regWrite_XM),
			.regWrite_MWB(regWrite_MWB),
			.stall(stall)
			);

decode decode0(			
			.clk(clk),
			.rst(rst),
			.stall(stall), // ADD STALL
			.isRegWrite_MEM_WB(isRegWrite_MEM_WB),
			.currPC(currPC_IF_ID),
			.instr(instruction_IF_ID), 
			.new_addr(PC_2_IF_ID),
			.write_data(writeData), 
			.isNotHalt(isNotHalt),  
			.isNOP(isNOP), 
			.isJR(isJR),  
			.isJump(isJump),  
			.isBranch(isBranch), 
			.isMemToReg(isMemToReg), 
			.isMemRead(isMemRead), 
			.ALUop(ALUop), 
			.isMemWrite(isMemWrite), 
			.ALUsrc(ALUsrc), 
			.isRegWrite(isRegWrite),
			.immed(immed),
			.rd_data1(rdData1),
			.rd_data2(readData2),
			.writeRegSel(writeRegSel),
			.writeReg(writeReg),	//	KEEP?
			.nextPC(nextPC),
			.readReg1(readRegSel1),
			.readReg2(readRegSel2),
			.flush(flush)
		);

// TODO: ID/EX, TODO: STALL, WRITEREGSEL, VARIABLE NAMES
ID_EX id_ex(
			.clk(clk),
            .rst(rst),
            .en(1'b1),
            .pc_plus_2(pc_plus_2_FD),
            .HALT(HALT),
            .writeR7(writeR7),
            .memToReg(memToReg),
            .memRead(memRead),
            .memWrite(memWrite),
            .ALUsrc(ALUsrc),
            .regWrite(regWrite),
            .ALUop(ALUop),
            .immediate(immediate),
            .readData2(readData2),
            .readData1(readData1),
            .writeRegSel(writeRegSel),
            .pc_plus_2_DX(pc_plus_2_DX),
            .HALT_DX(HALT_DX),
        	.writeR7_DX(writeR7_DX),
            .memToReg_DX(memToReg_DX),
            .memRead_DX(memRead_DX),
            .memWrite_DX(memWrite_DX),
            .ALUsrc_DX(ALUsrc_DX),
            .regWrite_DX(regWrite_DX),
            .ALUop_DX(ALUop_DX),
            .immediate_DX(immediate_DX),
            .readData2_DX(readData2_DX),
            .readData1_DX(readData1_DX),
            .writeRegSel_DX(writeRegSel_DX)	//	KEEP?
);

execute execute0(.ALU_src(ALUSrc_ID_EX), .ALU_Op(ALUop_ID_EX, .extOut(immed_ID_EX), 
	.rd_data1(rdData1_ID_EX), .rd_data2(rdData2_ID_EX), .ALU_res(ALURes),.zero(), .ofl());

// EX/MEM Pipeline Register
EX_MEM ex_mem(
            .clk(clk),
            .rst(rst),
            .en(1'b1), 
            .ALURes(ALURes),
            .PC_2(PC_2_ID_EX),
            .isNotHalt(isNotHalt_ID_EX),
            .isMemToReg(isMemToReg_ID_EX),
            .isMemRead(isMemRead_ID_EX),
            .isMemWrite(isMemWrite_ID_EX),
            .isRegWrite(isRegWrite_ID_EX),
            .rdData2(rdData2_ID_EX),
            .writeRegSel(writeRegSel_DX),	//	KEEP?
            .ALURes_EX_MEM(ALURes_EX_MEM),
            .isNotHalt_EX_MEM(isNotHalt_EX_MEM),
            .PC_2_EX_MEM(PC_2_EX_MEM),
            .isMemToReg_EX_MEM(isMemToReg_EX_MEM),
            .isMemRead_EX_MEM(isMemRead_EX_MEM),
            .isMemWrite_EX_MEM(isMemWrite_EX_MEM),
            .isRegWrite_EX_MEM(isRegWrite_EX_MEM),
            .rdData2_EX_MEM(rdData2_EX_MEM),
            .writeRegSel_XM(writeRegSel_XM)	//	KEEP?
            );

memory memory0 (.clk(clk), .rst(rst), .isNotHalt(isNotHalt_MEM_WB), .isMemWrite(isMemWrite_EX_MEM), 
	.isMemRead(isMemRead_EX_MEM), .ALU_res(ALURes_EX_MEM), .rd_data(rFm), .writeData(rdData2_EX_MEM));

MEM_WB mem_wb(
            .clk(clk),
            .rst(rst),
            .en(1'b1),
			.isNotHalt(isNotHalt_EX_MEM),
            .rFm(rFm),
            .ALURes(ALURes_EX_MEM),
            .PC_2(PC_2_EX_MEM),
            .isMemToReg(isMemToReg_EX_MEM),
            .isRegWrite(isRegWrite_EX_MEM),
            .writeRegSel(writeRegSel_XM),	//	KEEP?
            .rFm_MEM_WB(rFm_MEM_WB),
            .ALURes_MEM_WB(ALURes_MEM_WB),
            .PC_2_MEM_WB(PC_2_MEM_WB),
            .isMemToReg_MEM_WB(isMemToReg_MEM_WB),
            .isRegWrite_MEM_WB(isRegWrite_MEM_WB),
            .writeRegSel_MWB(writeRegSel_MWB),	//	KEEP?
			.isNotHalt_MEM_WB(isNotHalt_MEM_WB)
			);

wb wb0 (.readData(rFm_MEM_WB), .isMemToReg(isMemToReg_MEM_WB), .isMemRead(isMemRead), .aluResult(ALURes_MEM_WB),
	.isJAL(isJAL), .nextPC(PC_2_MEM_WB), .writeEn(isRegWrite_MEM_WB), .writeData(wr_data));

   
endmodule