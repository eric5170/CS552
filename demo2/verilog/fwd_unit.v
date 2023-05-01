module fwd_unit(
			//	Input
            input wire r1_hdu_DX,
            input wire r2_hdu_DX,
            input wire memRead_XM,
            input wire memRead_MWB,
            input wire writeR7_XM,
            input wire writeR7_MWB,
            input wire regWrite_XM,
            input wire regWrite_MWB,
			
            input wire [2:0] readRegSel1_DX,
            input wire [2:0] readRegSel2_DX,
            input wire [2:0] writeRegSel_XM,
            input wire [2:0] writeRegSel_MWB,
			
            input wire [15:0] alu_result_XM,
            input wire [15:0] alu_result_MWB,
            input wire [15:0] read_data_MWB,
            input wire [15:0] pc_plus_2_XM,
            input wire [15:0] pc_plus_2_MWB,
			
			//	Output
            output wire ex_ex_fwd_r1,
            output wire ex_ex_fwd_r2,
            output wire mem_ex_fwd_r1,
            output wire mem_ex_fwd_r2,
			
            output wire [15:0] ex_ex_result_r1,
            output wire [15:0] ex_ex_result_r2,
            output wire [15:0] mem_ex_result_r1,
            output wire [15:0] mem_ex_result_r2
);
assign mem_ex_fwd_r1 =    ( r1_hdu_DX & (readRegSel1_DX == writeRegSel_MWB) & regWrite_MWB )
                        | ( r1_hdu_DX & readRegSel1_DX == 3'h7 & writeR7_MWB & regWrite_MWB & ~memRead_MWB );
assign mem_ex_fwd_r2 =    ( r2_hdu_DX & (readRegSel2_DX == writeRegSel_MWB) & regWrite_MWB )
                        | ( r2_hdu_DX & readRegSel2_DX == 3'h7 & writeR7_MWB & regWrite_MWB & ~memRead_MWB );
assign ex_ex_fwd_r1 =     ( r1_hdu_DX & (readRegSel1_DX == writeRegSel_XM) & regWrite_XM )
                        | ( r1_hdu_DX & readRegSel1_DX == 3'h7 & writeR7_XM & regWrite_XM & ~memRead_XM );
assign ex_ex_fwd_r2 =     ( r2_hdu_DX & (readRegSel2_DX == writeRegSel_XM) & regWrite_XM )
                        | ( r2_hdu_DX & readRegSel2_DX == 3'h7 & writeR7_XM & regWrite_XM & ~memRead_XM );

assign mem_ex_result_r1 = writeR7_MWB ? pc_plus_2_MWB : (memRead_MWB ? read_data_MWB : alu_result_MWB);
assign mem_ex_result_r2 = mem_ex_result_r1;
assign ex_ex_result_r1 = writeR7_XM ? pc_plus_2_XM : alu_result_XM;
assign ex_ex_result_r2 = ex_ex_result_r1;

endmodule
