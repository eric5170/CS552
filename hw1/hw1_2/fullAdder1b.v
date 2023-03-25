/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
    
    a 1-bit full adder
*/
`default_nettype none
module fullAdder1b(s, cOut, inA, inB, cIn);
    output wire s;
    output wire cOut;
    input  wire inA, inB;
    input  wire cIn;

    // YOUR CODE HERE
wire AxorB, AB, AxBnC;
wire wire1, wire2, wire3;

//a^b
xor2 iXOR1(.out(AxorB), .in1(inA), .in2(inB));

//s = AxorB ^ c_in;
xor2 iXOR2(.out(s), .in1(AxorB), .in2(cIn));
//(a^b)&c_in
nand2 iNAND1(.out(wire1), .in1(AxorB), .in2(cIn));
nand2 iNAND2(.out(AxBnC), .in1(wire1), .in2(wire1));
//a&b
nand2 iNAND3(.out(wire2), .in1(inA),.in2(inB));
nand2 iNAND4(.out(AB), .in1(wire2), .in2(wire2));
//((a^b) & c) | (a&b)
nor2 iNOR1(.out(wire3), .in1(AxBnC), .in2(AB));
nor2 iNOR2(.out(cOut) ,.in1(wire3), .in2(wire3));

endmodule
`default_nettype wire
