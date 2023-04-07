
module register_p(en, clk, rst, data_in, state);

	input clk, rst, en;
	input [15:0] data_in;
	output [15:0] state;
	wire [15:0] data;

	//NOP
	assign data = rst ? 16'h0800 : data_in;


	dff_en dff0(.en(en), .q(state[0]), .d(data[0]), .clk(clk), .rst(1'b0));
	dff_en dff1(.en(en), .q(state[1]), .d(data[1]), .clk(clk), .rst(1'b0));
	dff_en dff2(.en(en), .q(state[2]), .d(data[2]), .clk(clk), .rst(1'b0));
	dff_en dff3(.en(en), .q(state[3]), .d(data[3]), .clk(clk), .rst(1'b0));
	dff_en dff4(.en(en), .q(state[4]), .d(data[4]), .clk(clk), .rst(1'b0));
	dff_en dff5(.en(en), .q(state[5]), .d(data[5]), .clk(clk), .rst(1'b0));
	dff_en dff6(.en(en), .q(state[6]), .d(data[6]), .clk(clk), .rst(1'b0));
	dff_en dff7(.en(en), .q(state[7]), .d(data[7]), .clk(clk), .rst(1'b0));
	dff_en dff8(.en(en), .q(state[8]), .d(data[8]), .clk(clk), .rst(1'b0));
	dff_en dff9(.en(en), .q(state[9]), .d(data[9]), .clk(clk), .rst(1'b0));
	dff_en dff10(.en(en), .q(state[10]), .d(data[10]), .clk(clk), .rst(1'b0));
	dff_en dff11(.en(en), .q(state[11]), .d(data[11]), .clk(clk), .rst(1'b0));
	dff_en dff12(.en(en), .q(state[12]), .d(data[12]), .clk(clk), .rst(1'b0));
	dff_en dff13(.en(en), .q(state[13]), .d(data[13]), .clk(clk), .rst(1'b0));
	dff_en dff14(.en(en), .q(state[14]), .d(data[14]), .clk(clk), .rst(1'b0));
	dff_en dff15(.en(en), .q(state[15]), .d(data[15]), .clk(clk), .rst(1'b0));



endmodule