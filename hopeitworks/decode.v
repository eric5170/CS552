/*
   CS/ECE 552 Spring '20
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk,
					rst,
					instr, 
					currPC,
					new_addr,
					writeData, 
					isNotHalt,  
					isNOP,  
					isJAL,  
					isJR,  
					isJump,  
					isBranch, 
					isMemToReg, 
					isMemRead, 
					ALUop, 
					isMemWrite, 
					ALU_src, 
					isRegWrite,
					immed,
					rdData1,
					rdData2,
					PC_next);

// Inputs:
//	1. Instruction [15:0]
//	2. incremented address (PC+2)
//	3. Write Data [15:0]
// clk, rst (for regfile)
   
input wire clk, rst;
input wire[15:0] instr, currPC, new_addr, writeData;

output wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite,
 ALU_src, isRegWrite;
output wire [3:0] ALUop;

output wire [15:0] immed, rdData1, rdData2, PC_next;

wire [1:0] isType;
wire[2:0] read_reg1, read_reg2, writeReg;
wire zero, b_or_j;
wire [15:0] PC_next_i, branchALU;


assign b_or_j = isBranch | isJump;

assign PC_next = ~isNotHalt ? currPC : (b_or_j ? PC_next_i : new_addr);


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
control_unit iCtrl(.instr(instr), .isNotHalt(isNotHalt), .isNOP(isNOP), .isType(isType),
 .isJAL(isJAL), .isJR(isJR),. isJump(isJump), .isBranch(isBranch), .isMemToReg(isMemToReg), 
 .isMemRead(isMemRead), .ALUop(ALUop),. isMemWrite(isMemWrite), .ALU_src(ALU_src), .isRegWrite(isRegWrite));
 
instr_decode DECODE_REGS(.isType(isType),  
								.instr(instr),  
								.read_reg1(read_reg1),  
								.read_reg2(read_reg2),  
								.writeReg(writeReg),  
								.incr_PC(new_addr));
// Extension unit: ALEX
// 	Determine if SIGN extend or ZERO extend
extension_unit EXTEND_IMM(instr, immed);

//	Determine num bits
// Register File:
// 	From the instruction-decode unit - read from 2 regs.
regFile regFile0(
                // Outputs
                .read1Data(rdData1), .read2Data(rdData2), .err(),
                // Inputs
                .clk(clk), .rst(rst), .read1RegSel(read_reg1), .read2RegSel(read_reg2), .writeRegSel(writeReg), .writeData(writeData), .writeEn(regWrite)
                );


// BRANCH AND JUMPS: ABBY
// Additional ALU
//	Has operations for all branches (4)
// Word align (shift 2)
// Adder for curr instr and branch offset
// 2 Muxes (2-1, 4-1)
// AND gate for branch instruction

// branch_ALU BRANCH_ALU(.opcode(instruction[15:11]), .RsVal(read_data_1), .zero(zero));
//A, B, C_in, S, C_out

//cla16b iCLA(.sum(branchALU), .cOut(), .inA(immed), .inB(rdData1), .cIn(1'b0));
cla_16b ADD(.A(immed), .B(rdData1), .C_in(1'b0), .S(branchALU), .C_out());


isBranch_Jump BRANCH_JUMP(.opcode(instr[15:11]), 
								.RsVal(rdData1), 
								.incr_PC(new_addr),  
								.isJR(isJR),  
								.isJump(isJump),   
								.isBranch(isBranch),  
								.ALUResult(branchALU),  
								.immed(immed),  
								.next_PC(PC_next_i));
endmodule
