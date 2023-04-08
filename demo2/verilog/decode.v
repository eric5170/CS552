/*
   CS/ECE 552 Spring '23
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk,	rst, instr, currPC, stall, new_addr, writeData, isNotHalt, isNOP, isJAL, isJR,  
					isJump, isBranch, isMemToReg, isMemRead, ALU_Op, isMemWrite, ALU_src, 
					isRegWrite, isRegWrite_MW, immed, rd_data1, rd_data2, writeReg, writeRegSel, read_reg1, read_reg2, PC_next, flush);

	input wire clk, rst, stall, isRegWrite_MW;
	input wire[15:0] instr, currPC, new_addr, writeData;
	input wire [2:0] writeReg;
	

	output wire isNotHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite,
				ALU_src, isRegWrite, flush;
				
	output wire [3:0] ALU_Op;

	output wire [15:0] immed, rd_data1, rd_data2, PC_next;
	output wire [2:0] writeRegSel, read_reg1, read_reg2;
	
	wire [1:0] isType;
	
	wire zero, b_or_j;
	wire [15:0] control_instr;
	wire [15:0] PC_next_i, branchALU;
	wire [4:0] opcode;


	assign b_or_j = isBranch | isJump;

	// flush logic
	assign flush =  b_or_j ? ((PC_next_i == new_addr) ? 0 : 1) : 0;

	// next PC logic
	assign PC_next = ~(isNotHalt) ? currPC : (b_or_j ? PC_next_i : new_addr);



	/* Control Unit: Yeon Jae
	 * control signals:
	 *  1. isNotHalt
	 *  2. isNOP
	 *  3. isType
	 *  4. isJAL 
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
	 
	// stall vs control unit logic
	assign control_instr = stall ? 16'h0800: instr;
	 
	control iCtrl(.instr(control_instr), .isNotHalt(isNotHalt), .isNOP(isNOP), .isType(isType),.isJAL(isJAL), 
	  .isJR(isJR),.isJump(isJump), .isBranch(isBranch), .isMemToReg(isMemToReg), 
	 .isMemRead(isMemRead), .ALUop(ALU_Op),.isMemWrite(isMemWrite), .ALU_src(ALU_src), .isRegWrite(isRegWrite));

	// decode instruction to ports 
	instr_decode iDecode(.instr(instr), .isType(isType), .read_reg1(read_reg1), .read_reg2(read_reg2),  
			     .writeReg(writeRegSel), .immed(immed));



	// create register file according to provided ports
	rf_bypass regFile0(.read1OutData(rd_data1), .read2OutData(rd_data2), .err(), .clk(clk), .rst(rst), 
					 .read1RegSel(read_reg1), .read2RegSel(read_reg2), .writeRegSel(writeReg),
					 .writeInData(writeData), .writeEn(isRegWrite_MW));

	// branch ALU logic
	cla16b iCLA(.sum(branchALU), .cOut(), .inA(immed), .inB(rd_data1), .cIn(1'b0));


	// opcode from instruction
	assign opcode = instr[15:11];

	// determines whether to branch or jump
	isBranch_Jump iBrnchjp(.opcode(opcode), .RsVal(rd_data1), .PC_inc(new_addr), .isJR(isJR),  
						   .isJump(isJump), .isBranch(isBranch), .ALUResult(branchALU), .immed(immed),  
						   .PC_next(PC_next_i));
endmodule
