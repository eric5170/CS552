module E2M(
				clk,
				rst,
				en, 
				ALURes,
				PC_2,
				isNotHalt,
				isJAL,
				isMemToReg,
				isMemRead,
				isMemWrite,
				isRegWrite,
				rdData2,
				writeRegSel,
				ALURes_EM,
				isNotHalt_EM,
				PC_2_EM,
				isJAL_EM,
				isMemToReg_EM,
				isMemRead_EM,
				isMemWrite_EM,
				isRegWrite_EM,
				rdData2_EM,
				writeRegSel_EM);

	input wire[15:0] PC_2, rdData2, ALURes;
	input  wire isRegWrite, isNotHalt, isJAL, isMemToReg, isMemRead, isMemWrite, clk, rst, en;
	input wire[2:0] writeRegSel;

	output wire[15:0] PC_2_EM, rdData2_EM, ALURes_EM;
	output wire isNotHalt_EM, isJAL_EM, isMemToReg_EM, isMemRead_EM, isMemWrite_EM, isRegWrite_EM;
	output wire [2:0] writeRegSel_EM;

	register_p PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_EM));
	register_p Read_data_reg(.en(en), .clk(clk), .rst(rst), .data_in(rdData2), .state(rdData2_EM));
	register_p ALURes_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_EM));

	register_3b WriteRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_EM));

	register_1b isNotHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(isNotHalt_EM));
	register_1b isMemToReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_EM));
	register_1b isMemRead_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead), .state(isMemRead_EM));
	register_1b isMemWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemWrite), .state(isMemWrite_EM));
	register_1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_EM));
	register_1b isJAL_reg(.en(en), .clk(clk), .rst(rst),. data_in(isJAL), .state(isJAL_EM));
endmodule