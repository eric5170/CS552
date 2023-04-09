module register1b(en, clk, rst, state, data_in);
	input wire clk, rst, en;
	input wire data_in;
	output wire  state;

	dff_en iDff_enable(.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule