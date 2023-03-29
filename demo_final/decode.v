/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk,	rst, instr, currPC, new_addr, writeData, isNotHalt, isNOP, isJAL, isJR,  
					isJump, isBranch, isMemToReg, isMemRead, ALU_Op, isMemWrite, ALU_src, 
					isRegWrite, immed, rd_data1, rd_data2, PC_next);

input wire clk, rst;
input wire[15:0] instr, currPC, new_addr, writeData;

output wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite,
			ALU_src, isRegWrite;
			
output wire [3:0] ALU_Op;

output wire [15:0] immed, rd_data1, rd_data2, PC_next;

wire [1:0] isType;
wire[2:0] read_reg1, read_reg2, writeReg;
wire zero, b_or_j;
wire [15:0] PC_next_i, branchALU;
wire [4:0] opcode;


assign b_or_j = isBranch | isJump;

assign PC_next = ~(isNotHalt) ? currPC : (b_or_j ? PC_next_i : new_addr);


/* Control Unit: Yeon Jae
 * control signals:
 *  1. isNotHalt
 *  2. isNOP
 *  3. isType
 *  4. isJAL, 
 *  5. isJR 
 *  6. isJump
 *  7. isBranch
 *  8. isMemToReg
 *  9. isMemRead
 *  10. ALU_Op
 *  11. isMemWrite
 *  12. ALU_src
 *  13. isRegWrite
 */
control_unit iCtrl(.instr(instr), .isNotHalt(isNotHalt), .isNOP(isNOP), .isType(isType),.isJAL(isJAL), 
  .isJR(isJR),.isJump(isJump), .isBranch(isBranch), .isMemToReg(isMemToReg), 
 .isMemRead(isMemRead), .ALUop(ALU_Op),.isMemWrite(isMemWrite), .ALU_src(ALU_src), .isRegWrite(isRegWrite));
 
instr_decode iDecode(.isType(isType), .instr(instr), .read_reg1(read_reg1), .read_reg2(read_reg2),  
					 .writeReg(writeReg), .incr_PC(new_addr));

extension_unit iExtnd(.instr(instr), .immed(immed));

regFile regFile0(.read1Data(rd_data1), .read2Data(rd_data2), .err(), .clk(clk), .rst(rst), 
				 .read1RegSel(read_reg1), .read2RegSel(read_reg2), .writeRegSel(writeReg),
				 .writeData(writeData), .writeEn(isRegWrite));

cla16b iCLA(.sum(branchALU), .cOut(), .inA(immed), .inB(rd_data1), .cIn(1'b0));

assign opcode = instr[15:11];

isBranch_Jump iBrnchjp(.opcode(opcode), .RsVal(rd_data1), .incr_PC(new_addr), .isJR(isJR),  
					   .isJump(isJump), .isBranch(isBranch), .ALUResult(branchALU), .immed(immed),  
					   .next_PC(PC_next_i));
endmodule
