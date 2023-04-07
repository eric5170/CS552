/*
   CS/ECE 552 Spring '23
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (clk, rst, PC, nextPC, instr);

	input wire clk, rst;
	input  wire [15:0] PC;
	output wire [15:0] nextPC, instr;
	  
	wire [15:0] PC_2 , new_instr;
	
	// instruction from memory using memory2c
	memory2c iMEM(.data_out(new_instr), .data_in(16'h0), .addr(PC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

	// increment PC to PC+2 
	cla16b iADD(.sum(PC_2), .cOut(), .inA(PC), .inB(16'h2),.cIn(1'b0));
	
	// next PC logic
	assign nextPC = rst ? PC : PC_2;
	
	// stall logic
	assign instr = rst ? 16'h0800 : new_instr;

endmodule
`default_nettype wire
