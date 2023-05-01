/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : register4b.v
   
   Description     : This is the module for 4bit register logic using dff provided
*/
module register4b(en, clk, rst, data_in, state);

    input wire clk, rst, en;
    input wire[3:0] data_in;
    output wire [3:0] state;

    dff_en DFF_EN_SERIES[3:0] (.en(en), .clk(clk), .rst(rst), .d(data_in), .q(state));

endmodule