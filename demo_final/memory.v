/*
   CS/ECE 552 Spring '23
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/

module memory (
						clk,
						rst,
						isNotHalt,
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
input isNotHalt;
output [15:0] readData;	

wire memReadorWrite;
assign memReadorWrite = isMemRead | isMemWrite;

memory2c DATA_MEM(
				.data_out(readData), 
				.data_in(writeData),  
				.addr(aluResult),  
				.enable(memReadorWrite),// Is it a load or a stor (mem read / write)
				.wr(isMemWrite),  
				.createdump(~isNotHalt),  		// HALT should dump data mem
				.clk(clk),  
				.rst(rst)
			);

   
endmodule
