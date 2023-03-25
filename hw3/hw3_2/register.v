module register (clk, rst, write, write_data, read_data);

input clk;
input rst;
input write;
input [15:0] write_data;
output [15:0] read_data;

wire [15:0] in_data;


dff dff_16[15:0] (.q(read_data), .d(in_data), .clk(clk), .rst(rst));

assign in_data = write ? write_data : read_data;
endmodule
