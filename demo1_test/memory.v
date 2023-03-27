/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
module memory (clk, rst, isNotHalt, isMemWrite, isMemRead, ALU_res, rd_data,wr_data);

input wire clk,rst;
input wire isNotHalt, isMemWrite, isMemRead;
input wire [15:0] wr_data, ALU_res;

output wire [15:0] rd_data;

wire Halt, memRd_Wr, val;

not1 iNOT0(.out(Halt), .in1(isNotHalt));

nor2 iNOR(.out(val), .in1(isMemWrite), .in2(isMemRead));
not1 iNOT(.out(memRd_Wr), .in1(val));
	
memory2c iMem2C(.data_out(rd_data),.data_in(wr_data), .addr(ALU_res), .enable(memRd_Wr),
 .wr(isMemWrite), .createdump(Halt), .clk(clk), .rst(rst));
 
endmodule
`default_nettype wire
