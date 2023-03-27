/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (clk,
					rst,
					instr, 
					currPC,
					new_addr,
					wr_data, 
					NotHalt,  
					NOP,  
					JAL,  
					JR,  
					Jump,  
					branch, 
					memToReg, 
					memRead, 
					ALU_Op, 
					memWrite, 
					ALU_src, 
					regWrite,
					imm,
					rd_data1,
					rd_data2,
					nextPC);
 
input wire clk, rst;
input wire[15:0] instr, currPC, new_addr, wr_data;

output wire NotHalt, NOP, JAL, JR, Jump, branch, memToReg, memRead, memWrite, ALU_src, regWrite;
output wire [3:0] ALU_Op;
output wire [15:0] imm, rd_data1, rd_data2, nextPC;

wire [1:0] instrType;
wire[2:0] read_reg1, read_reg2, writeReg;
wire zero, b_or_j, b_or_j_comp;
wire [15:0] nextPC_a, branchALU;
wire Halt;
// Halt = ~notHalt
not1 iNOT0(.out(Halt), .in1(NotHalt));
//b_or_j_comp = ~(branch or jmp)
nor2 iNOR0(.out(b_or_j_comp), .in1(branch),.in2(Jump));
//b_or j = ~(~branch or jmp)
not1 iNOT1(.out(b_or_j), .in1(b_or_j_comp));


assign nextPC = NotHalt ? currPC : (b_or_j ? nextPC_a: new_addr);

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
control iCtrl (.instr(instr), .isNotHalt(NotHalt), .isNOP(NOP), .isType(instrType),
 .isJAL(JAL), .isJR(JR),. isJump(Jump), .isBranch(branch), .isMemToReg(memToReg), 
 .isMemRead(memRead), .ALU_Op(ALU_Op),. isMemWrite(memWrite), .ALU_src(ALU_src), .isRegWrite(regWrite));
 
 decode_instr iInstr(.instr(instr), .instrType(instrType), .readReg_1(read_reg1), .readReg_2(read_reg2)
 , .writeReg(writeReg), .PC(new_addr));
 
 // sign/zero extension unit
 ext iExtend(instr, imm);
 
 //register: instr-> decode
 rf iRegister (
           // Outputs
           .read1OutData(rd_data1), .read2OutData(rd_data2), .err(),
           // Inputs
           .clk(clk), .rst(rst), .read1RegSel(read_reg1), .read2RegSel(read_reg2), .writeRegSel(writeReg), .writeInData(wr_data), .writeEn(regWrite));
          


cla16b iCLA(.sum(branchALU), .cOut(), .inA(imm), .inB(rd_data1), .cIn(1'b0));		   
		  
isBranch_Jump iBrnch(.opcode(instr), .RsVal(rd_data1), .PC(new_addr), .isJR(JR), .isJump(Jump), .isBranch(branch), .ALU_res(branchALU), .imm(imm), .PC_next(nextPC_a));		  
endmodule
`default_nettype wire
