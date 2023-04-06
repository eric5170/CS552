module EX_MEM(
				clk,
				rst,
				en, 
				aluResult,
				PC_2,
				isNotHalt,
				MemToReg,
				MemRead,
				MemWrite,
				RegWrite,
				rdData2,
				writeRegSel,
				aluResult_EX_MEM,
				isNotHalt_EX_MEM,
				PC_2_EX_MEM,
				MemToReg_EX_MEM,
				MemRead_EX_MEM,
				MemWrite_EX_MEM,
				RegWrite_EX_MEM,
				rdData2_EX_MEM,
				writeRegSel_EX_MEM);

input [15:0] PC_2, rdData2, aluResult;
input isNotHalt, MemToReg, MemRead, MemWrite, 
	RegWrite, clk, rst, en;
input [2:0] writeRegSel;

output [15:0] PC_2_EX_MEM, rdData2_EX_MEM, aluResult_EX_MEM;
output isNotHalt_EX_MEM, MemToReg_EX_MEM, MemRead_EX_MEM, MemWrite_EX_MEM, RegWrite_EX_MEM;
output [2:0] writeRegSel_EX_MEM;

register_16b PC_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(inc_PC_EX_MEM));
register_16b READ_DATA_2_REG(.en(en), .clk(clk), .rst(rst), .data_in(rdData2), .state(rdData2_EX_MEM));
register_16b ALURESULT_REG(.en(en), .clk(clk), .rst(rst), .data_in(aluResult), .state(aluResult_EX_MEM));

register_3b WRITEREGSEL_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_EX_MEM));

register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(HALT_EX_MEM));
register_1b MEMTOREG_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemToReg), .state(MemToReg_EX_MEM));
register_1b MEMREAD_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemRead), .state(MemRead_EX_MEM));
register_1b MEMWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemWrite), .state(MemWrite_EX_MEM));
register_1b REGWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(RegWrite), .state(RegWrite_EX_MEM));

endmodule
