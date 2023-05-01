/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1
	Authors: Yeon Jae Cho
    Group: 18
    4-1 mux template
*/
`default_nettype none
module mux4_1(out, inputA, inputB, inputC, inputD, sel);
    output wire      out;
    input wire       inputA, inputB, inputC, inputD;
    input wire [1:0] sel;

    // YOUR CODE HERE

    wire n1, n2;

// 4-to-1 multiplexer, two levels of muxing (A or B) & (C or D)

mux2_1 Mux1(.out(n1), .inputA(inputA), .inputB(inputB), .sel(sel[0]));  //AB mux

mux2_1 Mux2(.out(n2), .inputA(inputC), .inputB(inputD), .sel(sel[0]));  //CD mux

mux2_1 Mux3(.out(out), .inputA(n1), .inputB(n2), .sel(sel[1]));  //AB or CD mux
endmodule
`default_nettype wire
