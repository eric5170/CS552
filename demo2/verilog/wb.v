/*
   CS/ECE 552 Spring '23
  
   Filename        : wb.v
   Description     : This is the module for writeback logic.
*/
module wb(readData,	isMemToReg, aluResult, nextPC, isJAL, writeData, writeRegSel, writeReg);

	input wire [15:0] readData, aluResult, nextPC;
	input wire[2:0] writeRegSel;
	input wire isMemToReg, isJAL;
	
	output wire [15:0] writeData;
	output wire [2:0] writeReg;
	
	assign writeData = isJAL ? nextPC : (isMemToReg ? readData : aluResult);
	assign writeReg = writeRegSel;
	
endmodule
