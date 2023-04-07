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
		isMemToReg, isMemRead, isMemWrite, ALUSrc, isRegWrite, stall, flush;
	wire [3:0] ALUop;
	wire [15:0] instr, wr_data, ALURes, rFm, rdData1, rdData2, immed, currPC, PC_next, PC_2;
	wire [1:0] num_reg_reads;
	
	// writeReg7 is isJAL

	wire [15:0] instr_IF_ID, PC_2_IF_ID, currPC_IF_ID, flush_instr;
	
	wire [2:0] writeRegSel, readRegSel1, readRegSel2, writeReg;

	wire [15:0] PC_2_ID_EX, immed_ID_EX, rdData1_ID_EX, rdData2_ID_EX;
	wire [2:0] writeRegSel_ID_EX;
	wire [3:0] ALUop_ID_EX;
	wire isNotHalt_ID_EX, isJAL_ID_EX, isMemToReg_ID_EX, isMemRead_ID_EX, isMemWrite_ID_EX, 
		ALUsrc_ID_EX, isRegWrite_ID_EX;

	wire [15:0] aluResult_EX_MEM, PC_2_EX_MEM, rdData2_EX_MEM;
	wire [2:0] writeRegSel_EX_MEM;
	wire isNotHalt_EX_MEM, isJAL_EX_MEM, isMemToReg_EX_MEM, isMemRead_EX_MEM, 
	isMemWrite_EX_MEM, isRegWrite_EX_MEM; // ALUsrc_EX_MEM?
	

	wire [15:0] rFm_MEM_WB, ALURes_MEM_WB, PC_2_MEM_WB;
	wire [2:0] writeRegSel_MEM_WB;
	wire isJAL_MEM_WB, isMemToReg_MEM_WB, isRegWrite_MWB, isNotHalt_MEM_WB;

	wire [15:0] PC_Test, instr_in;
	
	register_16b PC_REG(.en(~stall), .clk(clk), .rst(rst), .data_in(PC_Test), .state(currPC));

fetch FETCH_STAGE (.clk(clk), .rst(rst), .PC(currPC), .PC_next(PC_2), .instr(instr)); 
// CHANGE NEXTPC TO PC_NEXT

assign instr_in = flush ? 16'h0800 : instr;
assign PC_Test = flush ? PC_next: PC_2;

// IF/ID
IF_ID IF_ID_PIPE(.en(~stall), .clk(clk), .rst(rst), .currPC(currPC),.PC_2(PC_2), .instr(instr_in), 
	.instr_IF_ID(instr_IF_ID), .PC_2_IF_ID(PC_2_IF_ID), .currPC_IF_ID(currPC_IF_ID));
			
// TODO: Hazard Detection Unit // TODO:
hazard_detection_unit HD_unit(.instruction(instr_FD), .writeRegSel_ID_EX(writeRegSel_ID_EX),
	.writeRegSel_EX_MEM(writeRegSel_EX_MEM), .writeRegSel_MEM_WB(writeRegSel_MEM_WB), 
	.readRegSel1(readRegSel1), .readRegSel2(readRegSel2), .isRegWrite_ID_EX(isRegWrite_ID_EX),
	.isRegWrite_EX_MEM(isRegWrite_EX_MEM), .isRegWrite_MEM_WB(isRegWrite_MEM_WB), .stall(stall));

decode DECODE_STAGE(.clk(clk), .rst(rst), .stall(stall), .isRegWrite_MEM_WB(isRegWrite_MEM_WB),
	.currPC(currPC_IF_ID), .instr(instr_IF_ID), .new_addr(PC_2_IF_ID), .write_data(writeData), 
	.isNotHalt(isNotHalt),  .isNOP(isNOP), .isJAL(isJAL), .isJR(isJR), .isJump(isJump),  
	.isBranch(isBranch), .isMemToReg(isMemToReg), .isMemRead(isMemRead), .ALUop(ALUop), 
	.isMemWrite(isMemWrite), .ALUsrc(ALUsrc), .isRegWrite(isRegWrite), .immed(immed),
	.rd_data1(rdData1), .rd_data2(readData2), .writeRegSel(writeRegSel), .writeReg(writeReg),
	.PC_next(PC_next), .readReg1(readRegSel1), .readReg2(readRegSel2), .flush(flush));
	// ADD STALL AND FLUSH TO DECODE

// TODO: ID/EX, TODO: STALL, WRITEREGSEL, VARIABLE NAMES
// pc_plus_2 to PC_2
ID_EX ID_EX_PIPE(.clk(clk), .rst(rst), .en(1'b1), .PC_2(PC_2_IF_ID), .isNotHalt(isNotHalt), .isJAL(isJAL),
	.isMemToReg(isMemToReg), .isMemRead(isMemRead), .isMemWrite(isMemWrite), .ALUsrc(ALUsrc),
    .isRegWrite(isRegWrite), .ALUop(ALUop), .immed(immed), .rdData2(rdData2), .rdData1(rdData1),
	.writeRegSel(writeRegSel), .PC_2_ID_EX(PC_2_ID_EX), .isNotHalt_ID_EX(isNotHalt_ID_EX),
	.isJAL_EX_MEM(isJAL_EX_MEM), .isMemToReg_ID_EX(isMemToReg_ID_EX), .isMemRead_ID_EX(isMemRead_ID_EX),
	.isMemWrite_ID_EX(isMemWrite_ID_EX), .ALUsrc_ID_EX(ALUsrc_ID_EX), .isRegWrite_ID_EX(isRegWrite_ID_EX),
	.ALUop_ID_EX(ALUop_ID_EX), .immed_ID_EX(immed_ID_EX), .rdData2_ID_EX(rdData2_ID_EX),
	.rdData1_ID_EX(rdData1_ID_EX), .writeRegSel_ID_EX(writeRegSel_ID_EX));

// ALUSRC, ALUop, rdData1, rdData2, ALURes, extOutput
execute EXECUTE_STAGE(.ALUSrc(ALUSrc_ID_EX), .ALUop(ALUop_ID_EX, .rd_data1(rdData1_ID_EX), 
	.rd_data2(rdData2_ID_EX), .extOut(immed_ID_EX), .ALU_res(ALURes), .zero(), .ofl());

// EX/MEM Pipeline Register
EX_MEM EX_MEM_PIPE(.clk(clk), .rst(rst), .en(1'b1), .ALURes(ALURes), .PC_2(PC_2_ID_EX), 
	.isNotHalt(isNotHalt_ID_EX), .isJAL(.isJAL_ID_EX), .isMemToReg(isMemToReg_ID_EX), 
	.isMemRead(isMemRead_ID_EX), .isMemWrite(isMemWrite_ID_EX),
	.isRegWrite(isRegWrite_ID_EX), .rdData2(rdData2_ID_EX), .writeRegSel(writeRegSel_ID_EX),
	.ALURes_EX_MEM(ALURes_EX_MEM), .isNotHalt_EX_MEM(isNotHalt_EX_MEM), .PC_2_EX_MEM(PC_2_EX_MEM),
	.isJAL_EX_MEM(isJAL_EX_MEM), .isMemToReg_EX_MEM(isMemToReg_EX_MEM), .isMemRead_EX_MEM(isMemRead_EX_MEM),
	.isMemWrite_EX_MEM(isMemWrite_EX_MEM), .isRegWrite_EX_MEM(isRegWrite_EX_MEM),
	.rdData2_EX_MEM(rdData2_EX_MEM), .writeRegSel_EX_MEM(writeRegSel_EX_MEM));

memory MEMORY_STAGE (.clk(clk), .rst(rst), .isNotHalt(isNotHalt_MEM_WB), .isMemWrite(isMemWrite_EX_MEM), 
	.ALU_res(ALURes_EX_MEM), .writeData(rdData2_EX_MEM), .isMemRead(isMemRead_EX_MEM), .rd_data(rFm));
	// Change rd_data?

MEM_WB MEM_Wb_PIPE(.clk(clk), .rst(rst), .en(1'b1), .isNotHalt(isNotHalt_EX_MEM), .rFm(rFm), 
	.ALURes(ALURes_EX_MEM), .PC_2(PC_2_EX_MEM), .isJAL(isJAL), .isMemToReg(isMemToReg_EX_MEM), 
	.isRegWrite(isRegWrite_EX_MEM), .writeRegSel(writeRegSel_EX_MEM), .rFm_MEM_WB(rFm_MEM_WB), 
	.ALURes_MEM_WB(ALURes_MEM_WB), .PC_2_MEM_WB(PC_2_MEM_WB), .isMemToReg_MEM_WB(isMemToReg_MEM_WB), 
	.isRegWrite_MEM_WB(isRegWrite_MEM_WB), .writeRegSel_MEM_WB(writeRegSel_MEM_WB), 
	.isNotHalt_MEM_WB(isNotHalt_MEM_WB));

wb WRITE_BACK_STAGE (.readData(rFm_MEM_WB), .isMemToReg(isMemToReg_MEM_WB), .isMemRead(isMemRead), 
	.aluResult(ALURes_MEM_WB), .PC_next(PC_2_MEM_WB), .isJAL(isJAL_MEM_WB), .writeEn(isRegWrite_MEM_WB), 
	.writeRegSel(writeRegSel_MEM_WB), .writeData(wr_data));
	// CHANGE NEXTPC TO PC_NEXT

   
endmodule
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
