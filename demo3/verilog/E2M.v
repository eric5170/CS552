/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : E2M.v
   h
   Description     : This is the module for Execute to Memory Pipeline logic.
*/
module E2M(clk,	rst, en, ALURes, PC_2, isHalt, isJAL, isMemToReg, isMemRead, isMemWrite,
		   isRegWrite, rdData2, writeRegSel, ALURes_EM, isHalt_EM, PC_2_EM, isJAL_EM,
		   isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM, rdData2_EM,
		   writeRegSel_EM);

	input wire[15:0] PC_2, rdData2, ALURes;
	input wire[2:0] writeRegSel;
	input  wire isRegWrite, isHalt, isJAL, isMemToReg, isMemRead, isMemWrite, clk, rst, en;
	

	output wire[15:0] PC_2_EM, rdData2_EM, ALURes_EM;
	output wire [2:0] writeRegSel_EM;
	output wire isHalt_EM, isJAL_EM, isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM;
	

	// PC_2 Execute --> Memory
	register16b PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_EM));
	//rdData2 Execute --> Memory
	register16b Read_data_reg(.en(en), .clk(clk), .rst(rst), .data_in(rdData2), .state(rdData2_EM));
	//ALURes Execute --> Memory
	register16b ALURes_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_EM));
	// WriteRegSel Execute --> Memory
	register3b WriteRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_EM));
	
	// signals
	register1b isNotHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isHalt), .state(isHalt_EM));
	register1b isMemToReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_EM));
	register1b isMemRead_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead), .state(isMemRead_EM));
	register1b isMemWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemWrite), .state(isMemWrite_EM));
	register1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_EM));
	register1b isJAL_reg(.en(en), .clk(clk), .rst(rst),. data_in(isJAL), .state(isJAL_EM));
	
	

endmodule
