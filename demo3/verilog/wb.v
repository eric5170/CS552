/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : wb.v
   Description     : This is the module for writeback logic.
*/
module wb (readData, isMemToReg, aluResult, nextPC, isJAL, writeEn, writeData, writeRegSel, writeReg);

	input wire [15:0] readData, aluResult, nextPC;
	input wire[2:0] writeRegSel;
	input wire isMemToReg, isJAL, writeEn;
	
	output wire [15:0] writeData;
	output wire [2:0] writeReg;
	wire [15:0] mem2reg_out;
	
	mux2_1 MEM2REG_MUX[15:0] (.out(mem2reg_out), .inputA(aluResult), .inputB(readData), .sel(isMemToReg));
	mux2_1 WRITE_DATA_MUX[15:0] (.out(writeData), .inputA(mem2reg_out), .inputB(nextPC), .sel(isJAL));
	
	assign writeReg = writeRegSel;
	
endmodule