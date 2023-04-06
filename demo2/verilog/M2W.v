module M2W(
				clk,
				rst,
				en,
				isNotHalt,
				rdData2,
				ALURes,
				PC_2,
				isMemToReg,
				isRegWrite,
				writeRegSel,
				rdData2_MEM_WB,
				ALURes_MEM_WB,
				PC_2_MEM_WB,
				isMemToReg_MEM_WB,
				isRegWrite_MEM_WB,
				writeRegSel_MEM_WB,
				isNotHalt_MEM_WB);

	input [15:0] PC_2, ALURes, rdData2;
	input isMemToReg, isRegWrite, clk, rst, en, isNotHalt;
	input [2:0] writeRegSel;

	output [15:0] PC_2_MEM_WB, ALURes_MEM_WB, rdData2_MEM_WB;
	output isMemToReg_MEM_WB, isRegWrite_MEM_WB, isNotHalt_MEM_WB;
	output [2:0] writeRegSel_MEM_WB;

	register_p PC_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_MEM_WB));
	register_p READ_DATA_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(rdData2), .state(rdData2_MEM_WB));
	register_p ALURESULT_REG(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_MEM_WB));

	register_3b WRITEREGSEL_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_MEM_WB));

	register_1b MEMTOREG_REG(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_MEM_WB));
	register_1b REGWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_MEM_WB));
	register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(isNotHalt_MEM_WB));


endmodule