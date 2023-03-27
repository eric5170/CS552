/*
   CS/ECE 552 Spring '23
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
module fetch(clk, rst, PC_current, instr, PC_next);

input clk, rst;
input [15:0] PC_current;
output [15:0] instr, PC_next;


wire [15:0] blank_instr;
assign blank_instr = 16'h0;

wire assrt, deassrt;
assign assrt = 1'b1;
assign deassrt = 1'b0;


// get instr from mem
memory2c iMEM2C(.data_out(instr), .data_in(blank_instr), .addr(PC_current), .enable(assrt),
				.wr(deassrt), .createdump(assrt), .clk(clk), .rst(rst));


// PC_next = PC+2 
 cla16b ADDER(.sum(PC_next), .cOut(), .inA(PC_current), .inB(16'h2), .cIn(deassrt));

endmodule
