
module wb(readData,	isMemToReg, isMemRead, aluResult, nextPC, isJAL, writeData,	writeEn);

	input [15:0] readData, aluResult, nextPC;
	input isMemRead, isMemToReg, isJAL, writeEn;

	output [15:0] writeData;

	assign writeData = writeEn? (isJAL ? nextPC : (isMemToReg ? readData : aluResult)) : writeData;

endmodule
