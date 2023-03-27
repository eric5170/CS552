/*
   CS/ECE 552 Spring '23
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (
					//	INPUTS:
					clk,
					rst,
					
					//	Control Unit
					HALT,
					MemWrite,
					MemRead,
					
					//	ALU
					ALU_Result,
					read_data_2,
					
					//	WriteBack
					writeback_data,
					
					//	OUTPUTS:
					read_data,
					writeback_A);
	
	input wire	MemWrite, MemRead;
	input wire[15:0]	ALUResult, read_data_2, writeback_data;
	
	output wire[15:0]	read_data, write_data, writeback_A;
	
	wire	MemReadOrWrite;
	
	assign	MemReadOrWrite = MemRead | MemWrite;
	
	memory2c DATA_MEMORY(.data_out(read_data), .data_in(read_data_2), 
		.addr(ALU_Result), .enable(MemReadOrWrite), .wr(MemWrite), 
		.createdump(HALT), .clk(clk), .rst(rst));

	assign writeback_A = ALU_Result;
	assign write_data = writeback_data;

   
endmodule
`default_nettype wire
