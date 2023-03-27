/*
   CS/ECE 552 Spring '20
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/

module memory (
						clk,
						rst,
						isNotHalT,
						isMemWrite,
						aluResult,
						writeData,
						isMemRead,
						readData				
					);

input clk, rst;
input isMemWrite, isMemRead;			// Control signals: ST / LD
input [15:0] writeData;				// Data written to mem
input [15:0] aluResult;			// Calculated address
input isNotHalT;

wire memReadorWrite, mrow_i;
nor2 READ_OR_WRITE(memRead, memWrite, mrow_i);
not1 NOT0(mrow_i, memReadorWrite);

output [15:0] readData;				// Data read from mem


memory2c DATA_MEM(
				.data_out(readData), 
				.data_in(writeData),  
				.addr(aluResult),  
				.enable(memReadorWrite),// Is it a load or a stor (mem read / write)
				.wr(isMemWrite),  
				.createdump(~isNotHalT),  		// HALT should dump data mem
				.clk(clk),  
				.rst(rst)
			);

   
endmodule
