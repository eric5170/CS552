/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : fetch.v
   
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (clk, rst, currPC, nextPC, instr, stall_fetch, stall_data, flush, err);

	input wire clk, rst, stall_data, flush;
	input  wire [15:0] currPC;
	output wire [15:0] nextPC, instr;
	output wire stall_fetch, err; 
	
	wire [15:0] PC_2 , new_instr, stall_PC;
	wire done, flush_i;
	
	localparam memtype = 0;
	
	mem_system_hier #(memtype) INSTR_MEM(
				.Addr(currPC),
				.DataIn(16'h0),
				.Rd(1'b1),
				.Wr(1'b0),
				.createdump(1'b0),
				.DataOut(new_instr),
				.Done(done), 
				.Stall(stall_fetch), 
				.CacheHit()
				
);
	assign stall_PC = 16'h0800;
	
	// instruction from memory using memory2c
	memory2c iMEM(.data_out(new_instr), .data_in(16'h0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

	// increment PC to PC+2 
	cla16b iADD(.sum(PC_2), .cOut(), .inA(currPC), .inB(16'h2),.cIn(1'b0));
	
	// next PC logic
	assign nextPC = (rst | stall_data | ~done | flush_i) ? currPC : PC_2;
	
	
	// stall logic
	assign instr = (rst | ~done | flush_i) ? 16'h0800 : new_instr;
	dff_en iFlush(.en(flush | ~stall_fetch), .q(flush_i), .d(flush), .clk(clk), .rst(rst));

endmodule
`default_nettype wire
