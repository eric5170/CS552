module register16b(en, clk, rst, data_in, state);

	input wire clk, rst, en;
	input wire [15:0] data_in;
	output wire [15:0] state;

//	dff_en dff0 [15:0] (.en(en), .q(state), .d(data_in), .clk(clk), .rst(rst));

	dff_en dff0(.en(en), .q(state[0]), .d(data_in[0]), .clk(clk), .rst(rst));
	dff_en dff1(.en(en), .q(state[1]), .d(data_in[1]), .clk(clk), .rst(rst));
	dff_en dff2(.en(en), .q(state[2]), .d(data_in[2]), .clk(clk), .rst(rst));
	dff_en dff3(.en(en), .q(state[3]), .d(data_in[3]), .clk(clk), .rst(rst));
	dff_en dff4(.en(en), .q(state[4]), .d(data_in[4]), .clk(clk), .rst(rst));
	dff_en dff5(.en(en), .q(state[5]), .d(data_in[5]), .clk(clk), .rst(rst));
	dff_en dff6(.en(en), .q(state[6]), .d(data_in[6]), .clk(clk), .rst(rst));
	dff_en dff7(.en(en), .q(state[7]), .d(data_in[7]), .clk(clk), .rst(rst));
	dff_en dff8(.en(en), .q(state[8]), .d(data_in[8]), .clk(clk), .rst(rst));
	dff_en dff9(.en(en), .q(state[9]), .d(data_in[9]), .clk(clk), .rst(rst));
	dff_en dff10(.en(en), .q(state[10]), .d(data_in[10]), .clk(clk), .rst(rst));
	dff_en dff11(.en(en), .q(state[11]), .d(data_in[11]), .clk(clk), .rst(rst));
	dff_en dff12(.en(en), .q(state[12]), .d(data_in[12]), .clk(clk), .rst(rst));
	dff_en dff13(.en(en), .q(state[13]), .d(data_in[13]), .clk(clk), .rst(rst));
	dff_en dff14(.en(en), .q(state[14]), .d(data_in[14]), .clk(clk), .rst(rst));
	dff_en dff15(.en(en), .q(state[15]), .d(data_in[15]), .clk(clk), .rst(rst));



endmodule