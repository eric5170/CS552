/*
   CS/ECE 552 Spring '22
  
   Filename        : control.v
   Description     : This is the module for the overall control unit of the decode stage of the processor.
*/
`default_nettype none
module control (instr,isNotHalt,isJump,isIType1,isSignExtend, isJR, isJAL, isBranch, memToReg,memRead, memWrite, ALU_op, branch_op, ALU_src, RegWrite, RegDist, isTaken);

//instruction received
input wire [15:0] instr;

//control signals that result from the instruction
output wire isNotHalt, isJump,isIType1,isSignExtend, isJR, isJAL, isBranch, memToReg,memRead, memWrite, branch_op, ALU_src, RegWrite, RegDist, isTaken;
output wire [3:0] ALU_op;

//opcode
wire [4:0] opcode;
wire [3:0] aluOp;


//isIType1
//01000, 01001, 01010, 01011, 10100, 10101, 10110, 10111, 10000, 10001, 10011


   
endmodule
`default_nettype wire

