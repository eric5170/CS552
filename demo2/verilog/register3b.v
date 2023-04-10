module register3b(en, clk, rst, state, data_in);
	input wire clk, rst, en;
	input wire [2:0] data_in;
	output wire [2:0] state;
	
	
	dff_en DFF_EN_SERIES[2:0] (.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule
