`define SLT 9
`define SLE 10
`define SUB 1
`define ANDN 13

// Inputs:
// 	1. Read Data 1
//	2. Read Data 2
// 	3. Extend unit output
//	4. ALUOp
// 	5. ALUSrc

// Outputs:
//	1. ALU result [15:0]
//	2. Zero ???

// Mux 2-1
//	AluSrc is the select
// ALU
//	ALUop as select

module execute (ALU_src, ALUop, ReadData1, ReadData2, extOutput, ALUResult, Zero, Ofl);
	//MUX with ALUSrc
   //ALU with ALUOp 
   //INPUTS: ReadData1, ReadData2, Extension Unit output, ALUOp, ALUSrc, Zero
   //OUTPUTS: Zero? (might not need), ALUResult

	input ALU_src;
	input [3:0] ALUop;
	input [15:0] extOutput, ReadData1, ReadData2;
	output [15:0] ALUResult;
	output Zero, Ofl;

	wire [15:0] muxOutput;
	wire invA, invB, SLTflag, SLEflag, SUBflag, ANDNflag;
	wire carryIn;	
	// mux2_1 mux(.InA(ReadData2), .InB(extOutput), .S(ALUSrc), .Out(muxOutput));
	assign muxOutput = ALU_src ? extOutput : ReadData2;
 	alu_optimal ALU (.opcode(ALUop), .inA(ReadData1), .inB(muxOutput), .Cin(carryIn),
	.invA(invA), .invB(invB), .sign(1'b1), .zero(Zero), .ofl(Ofl), .aluOut(ALUResult));
	assign carryIn = ~SLTflag | ~SUBflag | ~SLEflag;
	assign SLTflag = |(ALUop ^ `SLT);
	assign SLEflag = |(ALUop ^ `SLE);
	assign SUBflag = |(ALUop ^ `SUB);
	assign ANDNflag = |(ALUop ^ `ANDN);
	assign invA = (~SUBflag) ? 1 : 0;
	assign invB = (~ANDNflag | ~SLTflag | ~SLEflag) ? 1 : 0;
	
endmodule
