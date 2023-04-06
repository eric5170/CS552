module E2M(
				clk,
				rst,
				en, 
				ALURes,
				PC_2,
				isNotHalt,
				isMemToReg,
				isMemRead,
				isMemWrite,
				isRegWrite,
				rdData2,
				writeRegSel,
				ALURes_EX_MEM,
				isNotHalt_EX_MEM,
				PC_2_EX_MEM,
				isMemToReg_EX_MEM,
				isMemRead_EX_MEM,
				isMemWrite_EX_MEM,
				isRegWrite_EX_MEM,
				rdData2_EX_MEM,
				writeRegSel_EX_MEM);

	input wire[15:0] PC_2, rdData2, ALURes;
	input  wire isRegWrite, isNotHalt, isMemToReg, isMemRead, isMemWrite, clk, rst, en;
	input wire[2:0] writeRegSel;

	output wire[15:0] PC_2_EX_MEM, rdData2_EX_MEM, ALURes_EX_MEM;
	output wire isNotHalt_EX_MEM, isMemToReg_EX_MEM, isMemRead_EX_MEM, isMemWrite_EX_MEM, isRegWrite_EX_MEM;
	output wire [2:0] writeRegSel_EX_MEM;

	register_p PC_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_EX_MEM));
	register_p READ_DATA_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(rdData2), .state(rdData2_EX_MEM));
	register_p ALURESULT_REG(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_EX_MEM));

	register_3b WRITEREGSEL_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_EX_MEM));

	register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(isNotHalt_EX_MEM));
	register_1b MEMTOREG_REG(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_EX_MEM));
	register_1b MEMREAD_REG(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead), .state(isMemRead_EX_MEM));
	register_1b MEMWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(isMemWrite), .state(isMemWrite_EX_MEM));
	register_1b REGWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_EX_MEM));

endmodule