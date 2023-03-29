/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (clk, rst, currPC, nextPC, instr);

input wire clk, rst;
input  wire [15:0] currPC;
output wire [15:0] nextPC, instr;
   
// instruction from memory using memory2c
memory2c iMEM(.data_out(instr), .data_in(16'h0), .addr(currPC), .enable(1'b1), .wr(1'b0), .createdump(1'b0), .clk(clk), .rst(rst));

// increment PC to PC+2 
cla16b iADD(.sum(nextPC), .cOut(), .inA(currPC), .inB(16'h2),.cIn(1'b0));


endmodule
`default_nettype wire
