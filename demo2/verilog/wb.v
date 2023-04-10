/*
   CS/ECE 552 Spring '23
  
   Filename        : wb.v
   Description     : This is the module for writeback logic.
*/
module wb (readData,	isMemToReg, aluResult, nextPC, isJAL, writeData, writeRegSel, writeReg);

	input wire [15:0] readData, aluResult, nextPC;
	input wire[2:0] writeRegSel;
	input wire isMemToReg, isJAL;
	
	output wire [15:0] writeData;
	output wire [2:0] writeReg;
	wire mem2reg_out
	
	mux2_1 MEM2REG_MUX(.out(mem2reg_out), .inputA(aluResult), .inputB(readData), .sel(isMemToReg));
	mux2_1 WRITE_DATA_MUX[15:0] (.out(writeData), .inputA(mem2reg_out), .inputB(nextPC), .sel(isJAL));
	
	assign writeReg = writeRegSel;
	
endmodule
