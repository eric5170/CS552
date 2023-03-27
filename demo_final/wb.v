/*
   CS/ECE 552 Spring '20
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
module wb(
					readData,
					memToReg,
					memRead,
					aluResult,
					nextPC,
					writeR7,
					writeData,
					writeEn			
				);

// Passing REG FILE ???

// Inputs:
//	1. Read Data
//	2. MemtoReg
//	3. ALU Result

input [15:0] readData, aluResult, nextPC;
input memRead, memToReg, writeR7, writeEn;

// Outputs:
// 	1. Write Data [15:0]

output [15:0] writeData;

assign writeData = writeEn? (writeR7 ? nextPC : (memToReg ? readData : aluResult)) : writeData;

endmodule
