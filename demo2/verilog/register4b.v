module register4b(en, clk, rst, data_in, state);

    input wire clk, rst, en;
    input wire[3:0] data_in;
    output wire [3:0] state;

    dff_en DFF_EN_SERIES[3:0] (.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule
