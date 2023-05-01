/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
     
    Authors: Yeon Jae Cho
    Group: 18
    a 16-bit CLA module
*/
`default_nettype none
module cla16b(sum, cOut, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    // YOUR CODE HERE
 wire carry1, carry2, carry3;
    cla4b iDUT0(.sum(sum[3:0]), .cOut(carry1), .inA(inA[3:0]), .inB(inB[3:0]), .cIn(cIn));
    cla4b iDUT1(.sum(sum[7:4]), .cOut(carry2), .inA(inA[7:4]), .inB(inB[7:4]), .cIn(carry1));
    cla4b iDUT2(.sum(sum[11:8]), .cOut(carry3), .inA(inA[11:8]), .inB(inB[11:8]), .cIn(carry2));
    cla4b iDUT3(.sum(sum[15:12]), .cOut(cOut), .inA(inA[15:12]), .inB(inB[15:12]), .cIn(carry3));

endmodule
`default_nettype wire
