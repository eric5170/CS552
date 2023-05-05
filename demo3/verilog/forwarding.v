module forwarding(
            r1_hazard_DX,
            r2_hazard_DX,
            readRegSel1_DX,
            readRegSel2_DX,
            ALURes_EM,
            ALURes_MW,
            readData_MW,
            isMemRead_EM,
            isMemRead_MW,
            isJAL_EM,
            isJAL_MW,
            PC_2_EM,
            PC_2_MW,
            writeRegSel_EM,
            writeRegSel_MW,
            isRegWrite_EM,
            isRegWrite_MW,
            EE_r1,
            EE_r2,
            ME_r1,
            ME_r2,
            EE_res_r1,
            EE_res_r2,
            ME_res_r1,
            ME_res_r2
);

input isMemRead_EM, isMemRead_MW, isJAL_EM, isJAL_MW, r1_hazard_DX, r2_hazard_DX;
input [2:0] readRegSel1_DX, readRegSel2_DX, writeRegSel_EM, writeRegSel_MW;
input [15:0] ALURes_EM, ALURes_MW, PC_2_EM, PC_2_MW;
input isRegWrite_MW, isRegWrite_EM;
input [15:0] readData_MW;
output [15:0] EE_res_r1, EE_res_r2, ME_res_r1, ME_res_r2;
output EE_r1, EE_r2, ME_r1, ME_r2;

assign ME_r1 =    ( r1_hazard_DX & (readRegSel1_DX == writeRegSel_MW) & isRegWrite_MW )
                        | ( r1_hazard_DX & readRegSel1_DX == 3'h7 & isJAL_MW & isRegWrite_MW & ~isMemRead_MW );
assign ME_r2 =    ( r2_hazard_DX & (readRegSel2_DX == writeRegSel_MW) & isRegWrite_MW )
                        | ( r2_hazard_DX & readRegSel2_DX == 3'h7 & isJAL_MW & isRegWrite_MW & ~isMemRead_MW );
assign EE_r1 =     ( r1_hazard_DX & (readRegSel1_DX == writeRegSel_EM) & isRegWrite_EM )
                        | ( r1_hazard_DX & readRegSel1_DX == 3'h7 & isJAL_EM & isRegWrite_EM & ~isMemRead_EM );
assign EE_r2 =     ( r2_hazard_DX & (readRegSel2_DX == writeRegSel_EM) & isRegWrite_EM )
                        | ( r2_hazard_DX & readRegSel2_DX == 3'h7 & isJAL_EM & isRegWrite_EM & ~isMemRead_EM );

assign ME_res_r1 = isJAL_MW ? PC_2_MW : (isMemRead_MW ? readData_MW : ALURes_MW);
assign ME_res_r2 = isJAL_MW ? PC_2_MW : (isMemRead_MW ? readData_MW : ALURes_MW);
assign EE_res_r1 = isJAL_EM ? PC_2_EM : ALURes_EM;
assign EE_res_r2 = isJAL_EM ? PC_2_EM : ALURes_EM;

endmodule