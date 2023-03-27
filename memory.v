/*
   CS/ECE 552 Spring '23
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (/* TODO: Add appropriate inputs/outputs for your memory stage here*/
					//	INPUTS:
					
					//	Control Unit
					MemWrite,
					MemRead,
					
					//	ALU
					ALUResult,
					read_data_2,
					
					//	WriteBack
					writeback_data,
					
					//	OUTPUTS:
					read_data,
					writeback_A);
	
	input	MemWrite, MemRead;
	input[15:0]	ALUResult, read_data_2, writeback_data;
	
	output[15:0]	read_data, write_data, writeback_A;
	
	memory2c DATA_MEMORY(.data_out(read_data), .data_in(read_data_2), 
		.addr(ALUResult), .enable(MemRead), .wr(MemWrite), 
		.createdump(), .clk(), .rst());

	assign writeback_A = ALUResult;
	assign write_data = writeback_data;

   // TODO: Your code here
   
endmodule
`default_nettype wire
