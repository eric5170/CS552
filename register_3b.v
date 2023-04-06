module register_3b(en, clk, rst, state, data_in);
input clk, rst, en;
input [2:0] data_in;
output [2:0] state;

dff_en DFF[2:0] (.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state))

endmodule