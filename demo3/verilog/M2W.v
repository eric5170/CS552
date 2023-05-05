/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : M2W.v
   
   Description     : This is the module for Memory to WriteBack Piepline Logic.
*/
module M2W(clk,	rst, err, en, isHalt, rFm, ALURes, PC_2, isJAL, isMemToReg, isRegWrite,
		   writeRegSel, isMemRead_EM, rFm_MW, ALURes_MW, PC_2_MW, isJAL_MW, isMemToReg_MW,
		   isRegWrite_MW, writeRegSel_MW, isHalt_MW, data_en, err_MW, isMemRead_MW);
		   	

	input wire [15:0] PC_2, ALURes, rFm;
	input wire [2:0] writeRegSel;
	input wire isJAL, isMemToReg, isRegWrite, clk, rst, en, isHalt, err, isMemRead_EM, data_en ;

	output wire [15:0] PC_2_MW, ALURes_MW, rFm_MW;
	output wire [2:0] writeRegSel_MW;
	output wire isJAL_MW, isMemToReg_MW, isRegWrite_MW, isHalt_MW, err_MW,isMemRead_MW;
	
	//PC_2 Memory --> WriteBack
	register16b PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_MW));
	//rFm Memory --> WriteBack
	register16b rFm_reg(.en(data_en), .clk(clk), .rst(rst), .data_in(rFm), .state(rFm_MW));
	//ALURes Memory --> WriteBack
	register16b ALURes_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_MW));
	// writeRegSel Memory --> WriteBack
	register3b writeRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_MW));

	//signals 
	register1b isMemtoReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_MW));
	register1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_MW));
	register1b isNotHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isHalt), .state(isHalt_MW));
	register1b isJAL_reg(.en(en), .clk(clk), .rst(rst), .data_in(isJAL), .state(isJAL_MW));
	register1b err_reg(.en(en), .clk(clk), .rst(rst), .data_in(err), .state(err_MW));
	register1b memRead_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead_EM), .state(isMemRead_MW));

	

endmodule