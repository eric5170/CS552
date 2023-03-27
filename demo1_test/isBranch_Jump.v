module isBranch_Jump(opcode, RsVal, PC, isJR, isJump, isBranch, ALU_res, imm, PC_next);

input [15:0] PC, imm,RsVal, ALU_res;
input [4:0] opcode;
input isJR, isJump, isBranch;

output [15:0] PC_next;

localparam 	BEQZ 		= 5'b01100;
localparam 	BNEZ 		= 5'b01101;
localparam 	BLTZ 		= 5'b01110;
localparam 	BGEZ 		= 5'b01111;


wire [15:0] add, mux2Out, imm_temp;

wire brAnd,cOut ;
reg zero;

cla16b iCLA(.sum(add), .cOut(cOut), .inA(PC), .inB(imm_temp), .cIn(1'b0));


assign PC_next = isJump ? mux2Out : (brAnd ? add : PC); 

assign mux2Out = isJR ? ALU_res : add;

branch_ALU ibrnch(.opcode(opcode), .zero(zero), .RsVal(RsVal));
assign brAnd = zero & isBranch; 
assign imm_temp = imm;

endmodule
	
