/*
   CS/ECE 552 Spring '23
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/

module memory (clk, rst, isHalt, isMemWrite, ALU_res, writeData, isMemRead, rd_data);

	input wire clk, rst, isHalt, isMemWrite, isMemRead;
	input wire [15:0] writeData, ALU_res;				
	output wire[15:0] rd_data;	

	wire memRoW;
	assign memRoW = isMemRead | isMemWrite;


	memory2c DATA_MEM(.data_out(rd_data), .data_in(writeData), .addr(ALU_res), .enable(memRoW),
					.wr(isMemWrite), .createdump(isHalt), .clk(clk), .rst(rst));

   
endmodule
