/*
    CS/ECE 552 Spring '20
    Homework #1, Problem 2

    3 input XOR
*/
module xor3 (in1,in2,in3,out);
   input wire in1,in2,in3;
   output wire out;
   assign out = in1 ^ in2 ^ in3;
endmodule
