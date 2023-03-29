/*
   CS/ECE 552 Spring '23
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/

module memory (clk, rst, isNotHalt, isMemWrite, ALU_res, writeData, isMemRead, rd_data);

input clk, rst, isNotHalt, isMemWrite, isMemRead;
input [15:0] writeData, ALU_res;				
output [15:0] rd_data;	

wire memRoW;
assign memRoW = isMemRead | isMemWrite;

wire Halt;
assign Halt = ~isNotHalt;
memory2c DATA_MEM(.data_out(rd_data), .data_in(writeData), .addr(ALU_res), .enable(memRoW),
			   	.wr(isMemWrite), .createdump(Halt),	.clk(clk), .rst(rst));

   
endmodule
