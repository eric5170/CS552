/*
    CS/ECE 552 Spring '23
    Homework #1, Problem 2
     
    Authors: Yeon Jae Cho 
    Group: 18
    a 4-bit CLA module
*/
`default_nettype none
module cla4b(sum, cOut, inA, inB, cIn);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output wire [N-1:0] sum;
    output wire         cOut;
    input wire [N-1: 0] inA, inB;
    input wire          cIn;

    // YOUR CODE HERE
 // YOUR CODE HERE
    wire [N-1:0]P,G;
    wire [N:0]C;
    
    wire PnCin, medA,G0nP1, CnP0nP1, G1nP2, P0P1P2, CnPs, G0nP1nP2, Gs, G2nP3,G1nP2nP3, Ps, GnPs,CnPPP;
//generate propagetes (P) and generates (G)
//GENERATE 
// G[0] = a[0] & b[0]
//nand2 iNAND0(.out(med[0]), .in1(inA[0]) ,.in2(inB[0]));
//nand2 iNAND1(.out(G[0]), .in1(med[0]) ,.in2(med[0]));
and2 iand0(.out(G[0]), .in1(inA[0]) ,.in2(inB[0]));

// G[1] = a[1] & b[1]
//nand2 iNAND2(.out(med[1]), .in1(inA[1]), .in2(inB[1]));
//nand2 iNAND3(.out(G[1]), .in1(med[1]), .in2(med[1]));
and2 iand1(.out(G[1]), .in1(inA[1]) ,.in2(inB[1]));

// G[2] = a[2] & b[2]
//nand2 iNAND4(.out(med[2]), .in1(inA[2]), .in2(inB[2]));
//nand2 iNAND5(.out(G[2]), .in1(med[2]), .in2(med[2]));
and2 iand2(.out(G[2]), .in1(inA[2]) ,.in2(inB[2]));

// G[3] = a[3] & b[3]
//nand2 iNAND6(.out(med[3]), .in1(inA[3]), .in2(inB[3]));
//nand2 iNAND7(.out(G[3]), .in1(med[3]), .in2(med[3]));
and2 iand3(.out(G[3]), .in1(inA[3]) ,.in2(inB[3]));

//PROPOGATE
// P[0] = a[0] | b[0]
//nor2 iNOR0(.out(med[4]), .in1(inA[0]), .in2(inB[0]));
//nor2 iNOR1(.out(P[0]), .in1(med[4]), .in2(med[4]));
or2 ior0(.out(P[0]), .in1(inA[0]), .in2(inB[0]));

// P[1] = a[1] | b[1]
//nor2 iNOR2(.out(med[5]), .in1(inA[1]), .in2(inB[1]));
//nor2 iNOR3(.out(P[1]), .in1(med[5]), .in2(med[5]));
or2 ior1(.out(P[1]), .in1(inA[1]), .in2(inB[1]));


// P[2] = a[2] | b[2]
//nor2 iNOR4(.out(med[6]), .in1(inA[2]), .in2(inB[2]));
//nor2 iNOR5(.out(P[2]), .in1(med[6]), .in2(med[6]));
or2 ior2(.out(P[2]), .in1(inA[2]), .in2(inB[2]));

// P[3] = a[3] | b[3]
//nor2 iNOR6(.out(med[7]), .in1(inA[3]), .in2(inB[3]));
//nor2 iNOR7(.out(P[3]), .in1(med[7]), .in2(med[7]));
or2 ior3(.out(P[3]), .in1(inA[3]), .in2(inB[3]));

//assign C[0] = G[0] | (P[0] & c_in);
//(P[0] & c_in)
//nand2 iNAND8(.out(med[8]), .in1(P[0]), .in2(cIn));
//nand2 iNAND9(.out(PnCin), .in1(med[8]), .in2(med[8]));
and2 iand4(.out(PnCin), .in1(P[0]), .in2(cIn));

// C[0]
//nor2 iNOR8(.out(med[9]), .in1(G[0]), .in2(PnCin));
//nor2 iNOR9(.out(C[0]), .in1(med[9]), .in2(med[9]));
or2 ior4(.out(C[0]), .in1(G[0]), .in2(PnCin));

//assign C[1] = G[1] | (G[0] & P[1]) | (c_in & P[0] & P[1]);
// (G[0] & P[1])
//nand2 iNAND10(.out(med[10]), .in1(G[0]), .in2(P[1]));
//nand2 iNAND11(.out(G0nP1), .in1(med[10]), .in2(med[10]));
and2 iAND0(.out(G0nP1), .in1(G[0]), .in2(P[1]));

// (c_in & P[0] & P[1])
//nand3 in0(.out(med[11]), .in1(cIn), .in2(P[0]), .in3(P[1]));
//nand3 in1(.out(CnP0nP1), .in1(med[11]), .in2(med[11]), .in3(med[11]));
and3 in0(.out(CnP0nP1), .in1(cIn), .in2(P[0]), .in3(P[1]));

// C[1]
//nor3 ino0(.out(med[12]), .in1(G[1]), .in2(G0nP1), .in3(CnP0nP1));
//nor3 ino1(.out(C[1]), .in1(med[12]), .in2(med[12]), .in3(med[12]));
or3 ino0(.out(C[1]), .in1(G[1]), .in2(G0nP1), .in3(CnP0nP1));

//assign C[2] =  G[2] | (G[1] & P[2]) | (c_in & P[0] & P[1] & P[2]);
// (G[1] & P[2])
//nand2 iNAND12(.out(med[13]), .in1(G[1]), .in2(P[2]));
//nand2 iNAND13(.out(G1nP2), .in1(med[13]), .in2(med[13]));
and2  iand5(.out(G1nP2), .in1(G[1]), .in2(P[2]));
 
// (G[0] & P[1] & P[2])
// nand3 in2(.out(med[14]), .in1(G[0]), .in2(P[1]), .in3(P[2]));
// nand3 in3(.out(G0nP1nP2), .in1(med[14]), .in2(med[14]), .in3(med[14]));
and3 iN0 (.out(G0nP1nP2), .in1(G[0]), .in2(P[1]), .in3(P[2]));


//(P[0] & P[1] & P[2])
and3 in1(.out(P0P1P2), .in1(P[0]), .in2(P[1]), .in3(P[2]));



// (c_in & P[0] & P[1] & P[2])
//nand3 in4(.out(med[15]), .in1(P[0]), .in2(P[1]), .in3(P[2]));
//nand3 in5(.out(P0P1P2), .in1(med[15]), .in2(med[15]), .in3(med[15]));
//nand2 iNAND14(.out(med[16]), .in1(cIn), .in2(P0P1P2));
//nand2 iNAND15(.out(CnPs), .in1(med[16]), .in2(med[16]));
and2 iand6(.out(CnPs), .in1(P0P1P2), .in2(cIn));

// C[2]
//nor3 ino2(.out(med[17]), .in1(G[2]), .in2(G1nP2), .in3(G0nP1nP2));
//nor3 ino3(.out(Gs), .in1(med[17]), .in2(med[17]), .in3(med[17]));

//nor2 iNOR10(.out(med[18]), .in1(Gs), .in2(CnPs));
//nor2 iNOR11(.out(C[2]), .in1(med[18]), .in2(med[18]));
or3 ino1(.out(Gs) ,.in1(G[2]), .in2(G1nP2), .in3(G0nP1nP2));
or2 io0(.out(C[2]), .in1(Gs), .in2(CnPs));


//assign c_out = G[3] | (G[2] & P[3]) | (G[1] & P[2] & P[3]) | (G[0] & P[1] & P[2] & P[3]) | (c_in & P[0] & P[1] & P[2] & P[3]);
//(G[2] & P[3])
//nand2 iNAND16(.out(med[19]), .in1(G[2]), .in2(P[3]));
//nand2 iNAND17(.out(G2nP3), .in1(med[19]) ,.in2(med[19]));
and2 iand7(.out(G2nP3), .in1(G[2]), .in2(P[3]));

//(G[1] & P[2] & P[3])
//nand3 in6(.out(med[20]), .in1(G[1]), .in2(P[2]), .in3(P[3]));
//nand3 in7(.out(G1nP2nP3) ,.in1(med[20]), .in2(med[20]), .in3(med[20]));
and3 in2(.out(G1nP2nP3) ,.in1(G[1]), .in2(P[2]), .in3(P[3]));

//(G[0] & P[1] & P[2] & P[3])
//nand3 in8(.out(med[21]), .in1(P[1]), .in2(P[2]), .in3(P[3]));
//nand3 in9(.out(Ps), .in1(med[21]), .in2(med[21]), .in3(med[21]));
//nand2 iNAND18(.out(med[22]), .in1(Ps), .in2(G[0]));
//nand2 iNAND19(.out(GnPs), .in1(med[22]), .in2(med[22]));
and3 in3(.out(Ps), .in1(P[1]) , .in2(P[2]), .in3(P[3]));
and2 iand8(.out(GnPs), .in1(G[0]), .in2(Ps));

//(c_in & P[0] & P[1] & P[2] & P[3])
//nand3 in10(.out(med[23]), .in1(P0P1P2), .in2(cIn), .in3(P[3]));
//nand3 in11(.out(CnPPP), .in1(med[23]), .in2(med[23]), .in3(med[23]));
and3 in4(.out(CnPPP), .in1(cIn), .in2(P0P1P2), .in3(P[3]));

//c_out
//nor3 ino4(.out(med[24]), .in1(G[3]), .in2(G2nP3), .in3(G1nP2nP3));
//nor3 ino5(.out(medA), .in1(med[24]), .in2(med[24]), .in3(med[24]));
//nor3 ino6(.out(med[25]), .in1(medA), .in2(GnPs), .in3(CnPPP));
//nor3 ino7(.out(cOut), .in1(med[25]), .in2(med[25]), .in3(med[25]));
or3 ino2(.out(medA), .in1(G[3]), .in2(G2nP3), .in3(G1nP2nP3));
or3 ino3(.out(cOut), .in1(medA), .in2(GnPs), .in3(CnPPP));


//assign C[3] = c_out;
//nand2 iNAND20(.out(med[26]), .in1(cOut) ,.in2(1'b1));
//nand2 iNAND21(.out(C[3]), .in1(med[26]), .in2(med[26]));
and2 iand9(.out(C[3]), .in1(cOut), .in2(1'b1));

//instantiate 1 bit full adder modules
fullAdder1b FA0 (.s(sum[0]), .cOut(), .inA(inA[0]), .inB(inB[0]) ,.cIn(cIn));
fullAdder1b FA1 (.s(sum[1]), .cOut(), .inA(inA[1]), .inB(inB[1]) ,.cIn(C[0]));
fullAdder1b FA2 (.s(sum[2]), .cOut(), .inA(inA[2]), .inB(inB[2]) ,.cIn(C[1]));
fullAdder1b FA3 (.s(sum[3]), .cOut(), .inA(inA[3]), .inB(inB[3]) ,.cIn(C[2]));

endmodule
`default_nettype wire
