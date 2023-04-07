/*
   CS/ECE 552 Spring '23
  
   Filename        : register.v
   Description     : This is the module for register logic using dff provided
*/

module register(clk, rst, data_in, state);
	input clk, rst;
	input [15:0] data_in;

	output [15:0] state;

	dff DFF_SERIES[15:0] (.q(state), .d(data_in), .clk(clk), .rst(rst));

endmodule
