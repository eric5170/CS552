/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (ALU_src, ALU_Op, extOut, rd_data1, rd_data2, ALU_res, zero, ofl);
	input wire ALU_src;
	input wire [3:0] ALU_Op;
	input wire [15:0] extOut, rd_data1, rd_data2;

	output wire [15:0] ALU_res;
	output wire zero,ofl;
	
	localparam 	SUB 		= 4'b0001;
	localparam 	SLT 		= 4'b1001;
	localparam 	SLE 		= 4'b1010;
	localparam 	ANDN 		= 4'b1101;


    wire [15:0] muxOut;
	wire invA, invB, SUB_f, ANDN_f, SLT_f, SLE_f, cIn;
   
    assign muxOut = ALU_src ? extOut : rd_data2;
   
	alu_optimal iALU_op (.opcode(ALU_Op), .inA(rd_data1), .inB(rd_data2), .Cin(cIn),
	.invA(invA), .invB(invB), .sign(1'b1), .zero(zero), .ofl(ofl), .aluOut(ALU_res));
   
    assign cIn = ~SLT_f | ~SUB_f | ~SLE_f;
	assign SLT_f = |(ALU_Op ^ SLT);
	assign SLE_f = |(ALU_Op ^ SLE);
	assign SUB_f = |(ALU_Op ^ SUB);
	assign ANDN_f = |(ALU_Op ^ ANDN);
	assign invA = (~SUB_f) ? 1 : 0;
	assign invB = (~ANDN_f | ~SLT_f | ~SLE_f) ? 1 : 0;
   
endmodule
`default_nettype wire
