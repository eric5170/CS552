/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1
	Authors: Yeon Jae Cho
    Group: 18
    2-1 mux template
*/
`default_nettype none
module mux2_1(out, inputA, inputB, sel);
    output wire  out;
    input wire  inputA, inputB;
    input wire  sel;

    // YOUR CODE HERE
wire n1, n2, n3;

not1 N1(.in1(sel), .out(n1));

nand2 NA1(.in1(inputA), .in2(n1), .out(n2));
nand2 NA2(.in1(inputB), .in2(sel), .out(n3));

nand2 NA3(.in1(n2), .in2(n3), .out(out));

    
endmodule
`default_nettype wire
