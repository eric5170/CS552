/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 1

    a 4-bit (quad) 4-1 Mux template
*/
`default_nettype none
module mux4_1_4b(out, inputA, inputB, inputC, inputD, sel);

    // parameter N for length of inputs and outputs (to use with larger inputs/outputs)
    parameter N = 4;

    output wire [N-1:0]  out;
    input wire [N-1:0]   inputA, inputB, inputC, inputD;
    input wire [1:0]     sel;

    // YOUR CODE HERE
// 4_1-bit multiplexers
mux4_1 mux[3:0](.inputA(inputA), .inputB(inputB), .inputC(inputC), .inputD(inputD), .sel(sel), .out(out));
endmodule
`default_nettype wire
