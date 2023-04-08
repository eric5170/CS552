module isBranch_Jump(opcode, RsVal, PC_inc, isJR, isJump, isBranch, ALUResult, immed, PC_next);

input [15:0] PC_inc;
input isJR, isJump, isBranch;
input [15:0] ALUResult; 
input [15:0] immed;
input [4:0] opcode;
input [15:0] RsVal;
output [15:0] PC_next;

wire [15:0] immedWire;
wire [15:0] sum;
wire [15:0] muxJR;
wire b_and_z;
wire zero;
wire C_out;


cla16b ADD(.sum(sum), .cOut(C_out), .inA(PC_inc), .inB(immedWire), .cIn(1'b0));

assign muxJR = isJR ? ALUResult : sum;

assign PC_next = isJump ? muxJR : (b_and_z ? sum : PC_inc); 

isBranch_ALU iBrnch(.opcode(opcode), .RsVal(RsVal), .zero(zero));
assign b_and_z = zero & isBranch; 
assign immedWire = immed;

endmodule
	
