/*
   CS/ECE 552 Spring '23
  
   Filename        : wb.v
   Description     : This is the module for writeback logic.
*/
module wb(readData,	isMemToReg, isMemRead, aluResult, nextPC, isJAL, writeData, writeRegSel, writeReg);

	input [15:0] readData, aluResult, nextPC;
	input [2:0] writeRegSel;
	input isMemRead, isMemToReg, isJAL;
	
	output [15:0] writeData;
	output [2:0] writeReg;
	
	assign writeData = isJAL ? nextPC : (isMemToReg ? readData : aluResult);
	assign writeReg = writeRegSel;
	
endmodule
