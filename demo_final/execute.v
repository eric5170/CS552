module execute (ALU_src, ALU_Op,extOut, rd_data1, rd_data2,  ALU_res, zero, ofl);
	//MUX with ALUSrc
   //ALU with ALUOp 
   //INPUTS: ReadData1, ReadData2, Extension Unit output, ALUOp, ALUSrc, Zero
   //OUTPUTS: Zero? (might not need), ALUResult
	
	localparam SLT = 4'b1001;
	localparam SLE = 4'b1010;
	localparam SUB = 4'b0001;
	localparam ANDN = 4'b1101;
	
	input ALU_src;
	input [3:0] ALU_Op;
	input [15:0] extOut, rd_data1, rd_data2;
	output [15:0] ALU_res;
	output zero, ofl;

	wire [15:0] muxOutput;
	wire invA, invB, SLTflag, SLEflag, SUBflag, ANDNflag;
	wire carryIn;	

	
	assign muxOutput = ALU_src ? extOut : rd_data2;
	assign SLTflag = |(ALU_Op ^ SLT);
	assign SLEflag = |(ALU_Op ^ SLE);
	assign SUBflag = |(ALU_Op ^ SUB);
	assign ANDNflag = |(ALU_Op ^ ANDN);
	assign carryIn = ~SLTflag | ~SUBflag | ~SLEflag;
	
	assign invA = (~SUBflag) ? 1 : 0;
	assign invB = (~ANDNflag | ~SLTflag | ~SLEflag) ? 1 : 0;
	
	alu_optimal ALU (.opcode(ALU_Op), .inA(rd_data1), .inB(muxOutput), .Cin(carryIn),
	.invA(invA), .invB(invB), .sign(1'b1), .zero(zero), .ofl(ofl), .aluOut(ALU_res));
	
endmodule
