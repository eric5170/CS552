
module register_p(en, clk, rst, data_in, state);

	input wire clk, rst, en;
	input wire[15:0] data_in;
	output wire [15:0] state;
	wire [15:0] data;

	//NOP
	assign data = rst ? 16'h0800 : data_in;


	dff_en DFF_EN_SERIES[15:0] (.en(en), .q(state), .d(data), .clk(clk), .rst(1'b0));

endmodule
