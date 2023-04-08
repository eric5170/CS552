module register_4b(en, clk, rst, data_in, state);

    input clk, rst, en;
    input [3:0] data_in;
    output [3:0] state;
	
	dff_en DFF_SERIES(.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule