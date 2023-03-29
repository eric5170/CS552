module isBranch_Jump(opcode, RsVal, incr_PC, isJR, isJump, isBranch, ALUResult, immed, next_PC);

input [15:0] incr_PC;
input isJR, isJump, isBranch;
input [15:0] ALUResult; 
input [15:0] immed;
input [4:0] opcode;
input [15:0] RsVal;
output [15:0] next_PC;

wire [15:0] immedWire;
wire [15:0] addOutput;
wire [15:0] mux2Output;
wire b_and_z;
wire zero;
wire C_out;


cla16b ADD(.sum(addOutput), .cOut(C_out), .inA(incr_PC), .inB(immedWire), .cIn(1'b0));

assign mux2Output = isJR ? ALUResult : addOutput;

assign next_PC = isJump ? mux2Output : (b_and_z ? addOutput : incr_PC); 



isBranch_ALU iBrnch(.opcode(opcode), .RsVal(RsVal), .zero(zero));
assign b_and_z = zero & isBranch; 
assign immedWire = immed;



endmodule
	