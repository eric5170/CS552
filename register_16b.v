module register_16b(en, clk, rst, data_in, state);

input clk, rst, en;
input [15:0] data_in;
output [15:0] state;
wire [15:0] data;

assign data = rst ? 16'h0800 : data_in;

dff_en DFF[15:0] (.en(en), .q(state), .d(data), .clk(clk), .rst(1'b0));

endmodule