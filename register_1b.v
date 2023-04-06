module register_1b(en, clk, rst, state, data_in);
input clk, rst, en;
input data_in;
output state;

dff_en DFF(.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule