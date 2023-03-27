/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (rd_data, isMemToReg, isMemRead, ALU_res, isJAL, nextPC, wrEN, wr_data);

input wire [15:0] rd_data, ALU_res, nextPC;
input wire isMemToReg, isMemRead, isJAL,wrEN;

output wire [15:0] wr_data;

assign wr_data = wrEN? (isJAL ? nextPC : (isMemToReg ? rd_data : ALU_res)) : wr_data;

endmodule
`default_nettype wire
