module MEM_WB(
				clk,
				rst,
				en,
				HALT_MEM,
				data_MEM,
				aluResult_MEM,
				inc_PC_MEM,
				memToReg_MEM,
				regWrite_MEM,
				writeRegSel_MEM,
				data_WB,
				aluResult_WB,
				inc_PC_WB,
				memToReg_WB,
				regWrite_WB,
				writeRegSel_WB,
				HALT_WB);

input [15:0] inc_PC_MEM, aluResult_MEM, data_MEM;
input memToReg_MEM, regWrite_MEM, clk, rst, en, HALT;
input [2:0] writeRegSel_MEM;

output [15:0] inc_PC_WB, aluResult_WB, data_WB;
output memToReg_WB, regWrite_WB, HALT_WB;
output [2:0] writeRegSel_WB;

register_16b IN_PC_REG(.en(en), .clk(clk), .rst(rst), .data_in(inc_PC_MEM), .state(inc_PC_WB));
register_16b DATA_REG(.en(en), .clk(clk), .rst(rst), .data_in(data_MEM), .state(data_WB));
register_16b ALURESULT_REG(.en(en), .clk(clk), .rst(rst), .data_in(aluResult_MEM), .state(aluResult_WB));

register_3b WRITEREGSEL_REG(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel_MEM), .state(writeRegSel_WB));

register_1b MEMTOREG_REG(.en(en), .clk(clk), .rst(rst), .data_in(MemToReg_MEM), .state(MemToReg_WB));
register_1b REGWRITE_REG(.en(en), .clk(clk), .rst(rst), .data_in(RegWrite_MEM), .state(RegWrite_WB));
register_1b HALT_REG(.en(en), .clk(clk), .rst(rst), .data_in(HALT_MEM), .state(HALT_WB));


endmodule