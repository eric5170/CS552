module M2W(
				clk,
				rst,
				en,
				isNotHalt,
				rFm,
				ALURes,
				PC_2,
				isJAL,
				isMemToReg,
				isRegWrite,
				writeRegSel,
				rFm_MW,
				ALURes_MW,
				PC_2_MW,
				isJAL_MW,
				isMemToReg_MW,
				isRegWrite_MW,
				writeRegSel_MW,
				isNotHalt_MW);

	input wire [15:0] PC_2, ALURes, rFm;
	input wire isJAL, isMemToReg, isRegWrite, clk, rst, en, isNotHalt;
	input wire [2:0] writeRegSel;

	output wire [15:0] PC_2_MW, ALURes_MW, rFm_MW;
	output wire isJAL_MW, isMemToReg_MW, isRegWrite_MW, isNotHalt_MW;
	output wire [2:0] writeRegSel_MW;

	register_p PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_MW));
	register_p rFm_reg(.en(en), .clk(clk), .rst(rst), .data_in(rFm), .state(rFm_MW));
	register_p ALURes_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALURes), .state(ALURes_MW));

	register_3b writeRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_MW));

	register_1b isMemtoReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_MW));
	register_1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_MW));
	register_1b isNotHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(isNotHalt_MW));
	register_1b isJAL_reg(.en(en), .clk(clk), .rst(rst), .data_in(isJAL), .state(isJAL_MW));


endmodule