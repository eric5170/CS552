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
wire isBranchAND;
wire zero;
   wire C_out;

//A, B, C_in, S, C_out
//cla16b iCLA(.sum(addOutput), .cOut(C_out), .inA(incr_PC), .inB(immedWire), .cIn(1'b0));
cla_16b ADD(.A(incr_PC), .B(immedWire), .C_in(1'b0), .S(addOutput), .C_out(C_out));


//InA, InB, InC, InD, S, Out
//mux4_1 MUX4_1(.InD(incr_PC), .InC(addOutput), .InB(mux2Output), .InA(), .S({isJump, isBranchAND}), .Out(next_PC));
// if(isJump) 
// {
// 	if(isBranchAND) 
//		{
//			next_PC = x;
//		}
//		else
//		{
//			next_PC = mux2Output;
//		}
// }
// else
// {
// 	if(isBranchAND) 
//		{
//			next_PC = addOutput;
//		}
//		else next_PC = incr_PC
// }
assign next_PC = isJump ? mux2Output : (isBranchAND ? addOutput : incr_PC); 

assign mux2Output = isJR ? ALUResult : addOutput;

isBranch_ALU ALU(.opcode(opcode), .zero(zero), .RsVal(RsVal));

assign isBranchAND = zero & isBranch; 
assign immedWire = immed;

endmodule
	
