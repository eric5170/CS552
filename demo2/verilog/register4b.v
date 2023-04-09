module register4b(en, clk, rst, data_in, state);

    input wire clk, rst, en;
    input wire[3:0] data_in;
    output wire [3:0] state;

    dff_en dff0(.en(en), .clk(clk), .rst(rst), .d(data_in[0]), .q(state[0]));
    dff_en dff1(.en(en), .clk(clk), .rst(rst), .d(data_in[1]), .q(state[1]));
    dff_en dff2(.en(en), .clk(clk), .rst(rst), .d(data_in[2]), .q(state[2]));
    dff_en dff3(.en(en), .clk(clk), .rst(rst), .d(data_in[3]), .q(state[3]));

endmodule