
module D2X(
            clk,
            rst,
            en,
            PC_2,
            isNotHalt,
            isJAL,
            isMemToReg,
            isMemRead,
            isMemWrite,
            ALU_src,
            isRegWrite,
            ALUop,
            imm,
            readData1,
            readData2,
            writeRegSel,
            PC_2_DX,
            isNotHalt_DX,
            isJAL_DX,
            isMemToReg_DX,
            isMemRead_DX,
            isMemWrite_DX,
            ALU_src_DX,
            isRegWrite_DX,
            ALUop_DX,
            imm_DX,
            readData1_DX,
            readData2_DX,
            writeRegSel_DX
            );

    input [15:0] PC_2;
    input en, clk, rst, isNotHalt, isJAL, isMemToReg, isMemRead, isMemWrite, ALU_src, isRegWrite;
    input [3:0] ALUop;
    input [15:0] imm;
    input [15:0] readData1, readData2;
    input [2:0] writeRegSel;

    output [15:0] PC_2_DX;
    output isNotHalt_DX, isJAL_DX, isMemToReg_DX, isMemRead_DX, isMemWrite_DX, ALU_src_DX, isRegWrite_DX;
    output [3:0] ALUop_DX;
    output [15:0] imm_DX;
    output [15:0] readData1_DX, readData2_DX;
    output [2:0] writeRegSel_DX;

    register_p PC_2_reg(.en(en), .clk(clk), .rst(rst), .data_in(PC_2), .state(PC_2_DX));
    
    register_p imm_reg(.en(en), .clk(clk), .rst(rst), .data_in(imm), .state(imm_DX));
    register_p readData2_reg(.en(en), .clk(clk), .rst(rst), .data_in(readData2), .state(readData2_DX));
    register_p readData1_reg(.en(en), .clk(clk), .rst(rst), .data_in(readData1), .state(readData1_DX));

	// control signals
    register_1b isNotHalt_reg(.en(en), .clk(clk), .rst(rst), .data_in(isNotHalt), .state(isNotHalt_DX));
    register_1b isJAL_reg(.en(en), .clk(clk), .rst(rst), .data_in(isJAL), .state(isJAL_DX));
    register_1b isMemToReg_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemToReg), .state(isMemToReg_DX));
    register_1b isMemToRead_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemRead), .state(isMemRead_DX));
    register_1b isMemWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isMemWrite), .state(isMemWrite_DX));
    register_1b ALU_src_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALU_src), .state(ALU_src_DX));
    register_1b isRegWrite_reg(.en(en), .clk(clk), .rst(rst), .data_in(isRegWrite), .state(isRegWrite_DX));
    
    register_4b ALUop_reg(.en(en), .clk(clk), .rst(rst), .data_in(ALUop), .state(ALUop_DX));

    register_3b writeRegSel_reg(.en(en), .clk(clk), .rst(rst), .data_in(writeRegSel), .state(writeRegSel_DX));

endmodule