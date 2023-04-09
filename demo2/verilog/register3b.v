module register3b(en, clk, rst, state, data_in);
	input wire clk, rst, en;
	input wire [2:0] data_in;
	output wire [2:0] state;
		
	dff_en dff0(.en(en), .clk(clk), .rst(rst), .d(data_in[0]), .q(state[0]));
	dff_en dff1(.en(en), .clk(clk), .rst(rst), .d(data_in[1]), .q(state[1]));
	dff_en dff2(.en(en), .clk(clk), .rst(rst), .d(data_in[2]), .q(state[2]));

endmodule