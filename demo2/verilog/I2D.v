/*
   CS/ECE 552 Spring '23
  
   Filename        : I2D.v
   Description     : This is the module for Instruction Fetch to Decode Pipeline Logic.
					 
*/
module I2D(en, clk, rst, PC_2, instr, currPC, instr_next, PC_2_next, currPC_next);
   
	input wire clk, rst, en;
	input  wire[15:0] PC_2, instr, currPC;
	output wire [15:0] instr_next, PC_2_next, currPC_next;

	// instruction register that accounts for NOP
    register_p instr_reg(.en(en), .clk(clk), .rst(rst), .data_in(instr), .state(instr_next));
	// PC+2 register 
    register16b PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_next));
	// current PC register
    register16b currPC_reg(.en(en), .clk(clk), .rst(rst), .data_in(currPC), .state(currPC_next));

endmodule