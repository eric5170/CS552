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

// increment PC to PC+2 for the nextPC
cla_16b iADD(.A(currPC), .B(16'h2), .C_in(1'b0),.S(nextPC), .C_out());

endmodule
`default_nettype wire
