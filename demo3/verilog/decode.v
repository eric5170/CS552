/*
   CS/ECE 552 Spring '23
    
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : decode.v
   
   Description     : This is the module for the overall decode stage of the processor.
*/
module decode (clk,	rst, instr, currPC, stall, new_addr, writeData, isHalt, isNOP, isJAL, isJR,  
					isJump, isBranch, isMemToReg, isMemRead, ALU_Op, isMemWrite, ALU_src, 
					isRegWrite, isRegWrite_MW, immed, rd_data1, rd_data2, writeReg, writeRegSel, read_reg1,
					read_reg2, PC_next, flush);

	input wire clk, rst, stall, isRegWrite_MW;
	input wire[15:0] instr, currPC, new_addr, writeData;
	input wire [2:0] writeReg;

	output wire [15:0] immed, rd_data1, rd_data2, PC_next;
	output wire [3:0] ALU_Op;
	output wire [2:0] writeRegSel, read_reg1, read_reg2;
	output wire isHalt, isNOP, isJAL, isJR, isJump, isBranch, isMemToReg, isMemRead, isMemWrite,
		ALU_src, isRegWrite, flush;
	
	wire [15:0] control_instr, PC_next_i, branchALU;
	wire [4:0] opcode;
	wire [1:0] isType;
	wire zero, b_or_j;


	assign b_or_j = isBranch | isJump;

	// flush logic
	mux2_1 FLUSH_MUX (.out(flush), .inputA(0), .inputB(~(PC_next_i == new_addr)), .sel(b_or_j));

	// next PC logic
	assign PC_next = PC_next_i;

	wire [15:0] stall_PC;
	assign stall_PC = 16'h0800;
	
	// stall vs control unit logic
	mux2_1 CONTROL_INSTR_MUX[15:0] (.out(control_instr), .inputA(instr), .inputB(stall_PC), .sel(stall));
	 

	/* Control Unit: Yeon Jae
	 * control signals:
	 *  1. isHalt
	 *  2. isNOP
	 *  3. isJAL
	 *  4. isJR 
	 *  5. isJump 
	 *  6. isBranch
	 *  7. isMemToReg
	 *  8. isMemRead
	 *  9. ALU_Op
	 *  10. isMemWrite
	 *  11. ALU_src
	 *  12. isRegWrite
	 */
	 
	control iCtrl(.instr(control_instr), .isHalt(isHalt), .isNOP(isNOP), .isJAL(isJAL), 
	  .isJR(isJR),.isJump(isJump), .isBranch(isBranch), .isMemToReg(isMemToReg), 
	 .isMemRead(isMemRead), .ALUop(ALU_Op),.isMemWrite(isMemWrite), .ALU_src(ALU_src), .isRegWrite(isRegWrite));

	// module for initializing the instruction types from the instructions
	// created because of the slow processor for the original code. 
	instr_type iType(.instr(instr), .isType(isType));

	// decode instruction to ports 
	instr_decode iDecode(.isType(isType), .instr(instr), .read_reg1(read_reg1), .read_reg2(read_reg2),  
						 .writeReg(writeRegSel), .incr_PC(new_addr), .immed(immed));



	// create register file according to provided ports
	rf_bypass regFile0(.read1OutData(rd_data1), .read2OutData(rd_data2), .err(), .clk(clk), .rst(rst), 
					 .read1RegSel(read_reg1), .read2RegSel(read_reg2), .writeRegSel(writeReg),
					 .writeData(writeData), .writeEn(isRegWrite_MW));

	// branch ALU logic
	cla16b iCLA(.sum(branchALU), .cOut(), .inA(immed), .inB(rd_data1), .cIn(1'b0));


	// opcode from instruction
	assign opcode = instr[15:11];

	// determines whether to branch or jump
	isBranch_Jump iBrnchjp(.opcode(opcode), .RsVal(rd_data1), .incr_PC(new_addr), .isJR(isJR),  
						   .isJump(isJump), .isBranch(isBranch), .ALUResult(branchALU), .immed(immed),  
						   .next_PC(PC_next_i));
endmodule