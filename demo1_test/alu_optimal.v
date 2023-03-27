module alu_optimal (opcode, inA, inB, Cin, invA, invB, sign, zero, ofl, aluOut);
	input [3:0] opcode;
	input wire [15:0] inA, inB;
	input wire Cin,invA,invB,sign;
	
	output wire zero, ofl;
	output wire [15:0] aluOut;
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

	wire [15:0] sum, A_inp, B_inp;
	wire cOut;

	assign A_inp = invA ? ~inA : inA;
	assign B_inp = invB ? ~inB : inB;
	
	wire [15:0] shL, rotL, shR_A, shR_L, rotR_out, btrOut;
	wire [15:0] sco_out, seq_out, slb_out;
	reg [15:0] aluOut_inp;
	reg ofl_inp;
  
	wire neg, noz, neg_inp, noz_inp;

	// Calculate neg (for lesumsum than), neg OR zero (for lesumsum than or equal)
	// neg
	//nor2 NOR_NEG(sum[15], ofl_inp, neg_inp);
	//not1 NOT_NEG(neg_inp, neg);
	assign neg = sum[15];
	
	// neg OR ZERO
	nor2 iNOR(.out(noz_inp), .in1(neg), .in2(zero));
	not1 iNOT(.out(noz), .in1(noz_inp));
	

	//shfter instantiation
	shifter iShft0 (.InBS(A_inp), .ShAmt(B_inp[3:0]), .ShiftOper(2'b00), .OutBS(rotL));
	shifter iShft1 (.InBS(A_inp), .ShAmt(B_inp[3:0]), .ShiftOper(2'b01), .OutBS(shL));
	shifter iShft2 (.InBS(A_inp), .ShAmt(B_inp[3:0]), .ShiftOper(2'b10), .OutBS(shR_A));
	shifter iShft3 (.InBS(A_inp), .ShAmt(B_inp[3:0]), .ShiftOper(2'b11), .OutBS(shR_L));
	
	//additional rotation and instructions
	rotR iRotR(.instr(A_inp), .cnt(B_inp[3:0]), .out(rotR_out));
	btr iBtr(.inA(A_inp), .out(btrOut));
	sco iSco(.inA(A_inp), .inB(B_inp), .Out(sco_out));
	seq iSeq(.inA(A_inp), .inB(B_inp), .Out(seq_out));
	slbi iSlb(.inA(A_inp), .inB(B_inp), .Out(slb_out));

	cla16b iCLA(.sum(sum), .cOut(cOut), .inA(A_inp), .inB(B_inp), .cIn(Cin));
  

  
	wire diffS, allPos, allNeg, negFPos, posFNeg;
	wire cOut_i;
	assign diffS = A_inp[15] ^ B_inp[15];
	assign allPos = ~A_inp[15] & ~B_inp[15];
	assign allNeg = A_inp[15] & B_inp[15];
	assign negFPos = sum[15] & allPos;
	assign posFNeg = ~sum[15] & allNeg & ~zero;
	assign cOut_i = cOut ? ( sum[15] ? 0 : 1 ) : 0;
  	

	always@(*) begin
	   case(opcode) 
		ADD: begin
			aluOut_inp = sum;
			ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
		end
		
		SUB: begin 
			aluOut_inp = sum;
			ofl_inp = sign ? ( negFPos | posFNeg ? 1 : diffS ? 0 : cOut_i ) : cOut;
		end
		
		XOR: begin 
			aluOut_inp = A_inp ^ B_inp;
			ofl_inp = 0;
		end
		
		ANDN: begin 
			aluOut_inp = A_inp & B_inp;
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
			aluOut_inp = slb_out;
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
		
	   endcase
	end

   assign zero = ~|sum;
   assign ofl = ofl_inp;
   assign aluOut = aluOut_inp;
       
endmodule

