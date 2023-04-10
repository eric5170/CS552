module register16b(en, clk, rst, data_in, state);

	input wire clk, rst, en;
	input wire [15:0] data_in;
	output wire [15:0] state;

	dff_en DFF_EN_SERIES[15:0] (.en(en), .q(state), .d(data_in), .clk(clk), .rst(rst));

endmodule
