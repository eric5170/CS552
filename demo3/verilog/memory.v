/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
module memory (
						clk,
						rst,
						isHalt,
						isMemWrite,
						ALU_res,
						writeData,
						isMemRead,
						rd_data,
						stall,
						done,
						err			
					);

input wire clk, rst;
input wire isMemWrite, isMemRead;			// Control signals: ST / LD
input wire [15:0] writeData;				// Data written to mem
input wire [15:0] ALU_res;			// Calculated address
input wire isHalt;

output wire [15:0] rd_data;				// Data read from mem
output wire stall;
output wire done;
output wire err;

wire done_i;
wire mem_row;
assign mem_row = isMemRead | isMemWrite;


/* data_mem = 1, inst_mem = 0 *
* needed for cache parameter */
parameter memtype = 1;

mem_system_hier #(memtype) DATA_MEM(
				.Addr(ALU_res),
				.DataIn(writeData),
				.Rd(isMemRead),
				.Wr(isMemWrite),
				.createdump(isHalt),
				.DataOut(rd_data),
				.Done(done), 
				.Stall(stall),
				.CacheHit()
);

assign done = done_i;

   
endmodule
