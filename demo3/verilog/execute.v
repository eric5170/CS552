/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : execute.v
   
   Description     : This is the module for the ALU execution.
*/
module execute (ALU_src, ALU_Op,extOut, rd_data1, rd_data2,  ALU_res, zero, ofl);
	localparam SLT = 4'b1001;
	localparam SLE = 4'b1010;
	localparam SUB = 4'b0001;
	localparam ANDN = 4'b1101;
	
	input wire ALU_src;
	input wire[3:0] ALU_Op;
	input wire[15:0] extOut, rd_data1, rd_data2;
	output wire[15:0] ALU_res;
	output wire zero, ofl;

	wire [15:0] muxOutput;
	wire invA, invB, SLT_f, SLE_f, SUB_f, ANDN_f;
	wire carryIn;	

	
	assign muxOutput = ALU_src ? extOut : rd_data2;
	assign SLT_f = |(ALU_Op ^ SLT);
	assign SLE_f = |(ALU_Op ^ SLE);
	assign SUB_f = |(ALU_Op ^ SUB);
	assign ANDN_f = |(ALU_Op ^ ANDN);
	assign carryIn = ~(SLT_f & SUB_f & SLE_f);
	
	mux2_1 INV_A_MUX (.out(invA), .inputA(1'b1), .inputB(1'b0), .sel(SUB_f));
	mux2_1 INV_B_MUX (.out(invB), .inputA(1'b1), .inputB(1'b0), .sel(ANDN_f & SLT_f & SLE_f));
 	
	//instantiate the alu module 
	alu_optimal ALU (.opcode(ALU_Op), .inA(rd_data1), .inB(muxOutput), .Cin(carryIn),
	.invA(invA), .invB(invB), .sign(1'b1), .zero(zero), .ofl(ofl), .aluOut(ALU_res));
	
endmodule