/*
   CS/ECE 552 Spring '23
   
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : alu_optimal.v
   
   Description     : This is the module for alu operation that includes overflow detection logic.
*/
module alu_optimal (opcode, inA, inB, Cin, invA, invB, sign, zero, ofl, aluOut);

	localparam 	ADD 		= 4'b0000;
	localparam 	SUB 		= 4'b0001;
	localparam 	ROL 		= 4'b0010;
	localparam 	ROR 		= 4'b0011;
	localparam 	SLL 		= 4'b0100;
	localparam 	SRL 		= 4'b0101;
	localparam 	BTR 		= 4'b0110;
	localparam 	XOR 		= 4'b0111;
	localparam 	SEQ 		= 4'b1000;
	localparam 	SLT 		= 4'b1001;
	localparam 	SLE 		= 4'b1010;
	localparam 	SCO 		= 4'b1011;
	localparam 	SLBI 		= 4'b1100;
	localparam 	ANDN 		= 4'b1101;
	localparam 	LBI 		= 4'b1110;
	
	input wire [3:0] opcode;
	input wire [15:0] inA, inB;
	input wire Cin,invA,invB,sign;
	
	output wire zero, ofl;
	output wire [15:0] aluOut;

	wire [15:0] sum, A_inp, B_inp;
	wire cOut;

	// inverse values 
	assign A_inp = invA ? ~inA : inA;
	assign B_inp = invB ? ~inB : inB;
	
	wire [15:0] shL, rotL, shR_A, shR_L, rotR_out, btrOut;
	wire [15:0] sco_out, seq_out, slbi_out;
	reg [15:0] aluOut_inp;
	reg ofl_inp;
	//used for determining negative or zero
	wire neg, noz;
	//used for the overflow logic calculation
	wire diffS, allPos, allNeg, negFPos, posFNeg;
	wire cOut_i;

	assign neg = sum[15];
	
	// NEGATIVE OR ZERO
	assign noz = neg | zero;
	
	//amount of shft/rot
	wire [3:0] bit_cnt;
	assign bit_cnt = B_inp[3:0];
	
	//Instantiation of all ALU submodules
	shifter iShft0(.in(A_inp), .bit_cnt(bit_cnt), .Op(2'b00), .Out(rotL));
	shifter iShft1(.in(A_inp), .bit_cnt(bit_cnt), .Op(2'b01), .Out(shL));
	shifter iShft2(.in(A_inp), .bit_cnt(bit_cnt), .Op(2'b10), .Out(shR_A));
	shifter iShft3( .in(A_inp), .bit_cnt(bit_cnt), .Op(2'b11), .Out(shR_L));
	rotateR iROR(.in(A_inp), .bit_cnt(bit_cnt), .Out(rotR_out));
	btr iBTR(.in1(A_inp), .out(btrOut));
	sco iSCO(.in1(A_inp), .in2(B_inp), .out(sco_out));
	seq iSEQ(.in1(A_inp), .in2(B_inp), .out(seq_out));
	slbi iSLBI(.in1(A_inp), .in2(B_inp), .out(slbi_out));
	
	// Jay's CLA
	cla16b CLA_16(.sum(sum), .cOut(cOut), .inA(A_inp), .inB(B_inp), .cIn(Cin));
     
	//different Sign
	assign diffS = A_inp[15] ^ B_inp[15];
	//all positive
	assign allPos = ~A_inp[15] & ~B_inp[15];
	//all negative
	assign allNeg = A_inp[15] & B_inp[15];
	//neagtive value from positive values
	assign negFPos = sum[15] & allPos;
	//positive value from negative values
	assign posFNeg = ~sum[15] & allNeg & ~zero;
	//carryout calcuation
	assign cOut_i = cOut ? ( sum[15] ? 0 : 1 ) : 0;
 
	always@(*) begin
	   case(opcode) 
			ADD: begin
				aluOut_inp = sum;
				ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
			end
			//THIS IS PROBLEM!! FIX IT!
			SUB: begin 
				aluOut_inp = sum;
				ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
			end

			XOR: begin 
				aluOut_inp = A_inp^ B_inp;
				ofl_inp = 0;
			end

			ANDN: begin 
				aluOut_inp = A_inp& B_inp;
				ofl_inp = 0;
			end

			ROL: begin 
				aluOut_inp = rotL;
				ofl_inp = 0;
			end

			SLL: begin 
				aluOut_inp = shL;
				ofl_inp = 0;
			end

			ROR: begin 
				aluOut_inp = rotR_out;
				ofl_inp = 0;
			end

			SRL: begin 
				aluOut_inp = shR_L;
				ofl_inp = 0;
			end

			BTR: begin 
				aluOut_inp = btrOut;
				ofl_inp = 0;
			end

			SEQ: begin 
				aluOut_inp = seq_out;
				ofl_inp = 0;
			end

			SCO: begin
				aluOut_inp = sco_out;
				ofl_inp = 0;
			end

			SLBI: begin
				aluOut_inp = slbi_out;
				ofl_inp = 0;
			end

			
			SLT: begin	
				ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
				aluOut_inp = ofl_inp ? (neg ? 16'h0 : 16'h1) : (neg ? 16'h1 : 16'h0);
			end
			
			SLE: begin
				ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
				aluOut_inp = ofl_inp ? (neg ? 16'h0 : 16'h1) : noz ? 16'h1 : 16'h0;
			end

			LBI: begin
				aluOut_inp = B_inp; 
				ofl_inp = 0;
			end
			default: begin
				aluOut_inp = 16'hx;
				ofl_inp = 1'bx;
			end
			
	   endcase
	end

   assign zero = ~|sum;
   assign ofl = ofl_inp;
   assign aluOut = aluOut_inp;
       
endmodule
