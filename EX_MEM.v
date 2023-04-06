module EX_MEM(
				clk,
				rst,
				en, 
				aluResult_EX,
				inc_PC_EX,// pc_plus_2,
				HALT_EX,
				MemToReg_EX,
				MemRead_EX,
				MemWrite_EX,
				RegWrite_EX,
				rdData2_EX,
				writeRegSel_EX,
				aluResult_MEM,
				HALT_MEM,
				inc_PC_MEM,
				MemToReg_MEM,
				MemRead_MEM,
				MemWrite_MEM,
				RegWrite_MEM,
				rdData2_MEM,
				writeRegSel_MEM);

input [15:0] inc_PC_EX, rdData2_EX, aluResult_EX;
input HALT_EX, MemToReg_EX, MemRead_EX, MemWrite_EX, 
	RegWrite_EX, clk, rst, en;
input [2:0] writeRegSel_EX;

output [15:0] inc_PC_MEM, rdData2_MEM, aluResult_MEM;
output HALT_MEM, MemToReg_MEM, MemRead_MEM, MemWrite_MEM, RegWrite_MEM;
output [2:0] writeRegSel_MEM;

register_16b INC_PC_REG(.en(en), .clk(clk), .rst(rst), .data_in(inc_PC_EX), .state(inc_PC_MEM));
register_16b READDATA2_REG(.en(en), .clk(clk), .rst(rst), .data_in(rdData2_EX), .state(rdData2_MEM));
register_16b ALURESULT_REG(.en(en), .clk(clk), .rst(rst), .data_in(aluResult_EX), .state(aluResult_MEM));

register_3b WRITEREGSEL_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel_EX), .state(writeRegSel_MEM));

register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(HALT_EX), .state(HALT_MEM));
register_1b MEMTOREG_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemToReg_EX), .state(MemToReg_MEM));
register_1b MEMREAD_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemRead_EX), .state(MemRead_MEM));
register_1b MEMWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemWrite_EX), .state(MemWrite_MEM));
register_1b REGWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(RegWrite_EX), .state(RegWrite_MEM));

endmodule