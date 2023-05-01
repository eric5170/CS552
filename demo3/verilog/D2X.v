/*
   CS/ECE 552 Spring '23
   
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : D2X.v
   
   Description     : This is the module for Decode to Execute Pipeline Logic.
					 It uses the registers to pass out the values.
*/
module D2X(clk, rst, en, PC_2, isHalt, isJAL, isMemToReg, isMemRead, isMemWrite,
           ALU_src, isRegWrite, ALUop, immed, readData1, readData2, writeRegSel,
           PC_2_DX, isHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX,
           ALU_src_DX, isRegWrite_DX, ALUop_DX, immed_DX, readData1_DX, readData2_DX,
           writeRegSel_DX);

    input wire [15:0] PC_2, immed, readData1, readData2;
	input wire[3:0] ALUop;
    input wire[2:0] writeRegSel;
    input wire en, clk, rst, isHalt, isJAL, isMemToReg, isMemRead, isMemWrite, ALU_src, isRegWrite;
    
    output wire[15:0] PC_2_DX, immed_DX, readData1_DX, readData2_DX ;
	output wire[3:0] ALUop_DX;
	output wire[2:0] writeRegSel_DX;
    output wire isHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX, ALU_src_DX, isRegWrite_DX;
 
  
	// PC + 2 Decode --> Execute
    register16b PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_DX));
	// Immediate Decode --> Execute
    register16b imm_reg(.en(en), .clk(clk), .rst(rst), .data_in(immed), .state(immed_DX));
	// readData2 Decode --> Execute
    register16b readData2_reg(.en(en), .clk(clk), .rst(rst), .data_in(readData2), .state(readData2_DX));
	// readData1 Decode --> Execute
    register16b readData1_reg(.en(en), .clk(clk), .rst(rst), .data_in(readData1), .state(readData1_DX));

	// ALU Opcode Decode --> Execute
	register4b ALUop_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALUop), .state(ALUop_DX));
	
	// writeRegSel Decode --> Execute
    register3b writeRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_DX));
	
	// control signals Decode --> Execute
    register1b isHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isHalt), .state(isHalt_DX));
    register1b isJAL_reg(.en(en), .clk(clk), .rst(rst), .data_in(isJAL), .state(isJAL_DX));
    register1b isMemToReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_DX));
    register1b isMemToRead_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead), .state(isMemRead_DX));
    register1b isMemWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemWrite), .state(isMemWrite_DX));
    register1b ALU_src_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALU_src), .state(ALU_src_DX));
    register1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_DX));
    
    

endmodule