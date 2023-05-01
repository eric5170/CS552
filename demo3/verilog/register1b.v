/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : register1b.v
   
   Description     : This is the module for 1 bit register logic
*/
module register1b(en, clk, rst, state, data_in);
	input wire clk, rst, en;
	input wire data_in;
	output wire  state;

	dff_en iDff_enable(.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule