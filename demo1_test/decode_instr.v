module decode_instr(instr, instrType, readReg_1, readReg_2, writeReg, PC);

input [15:0] instr, PC;
input [1:0] instrType;

output wire [2:0] readReg_1, readReg_2, writeReg;

wire [4:0] opcode;
assign opcode = instr[15:11];

reg [2:0] rd_rg1, rd_rg2, wr_rg;

wire JALR, JAL, SLBI, LBI, ST, STU;

//logic for determinig which opcode
assign JALR = |(opcode ^ 5'b00111);
assign JAL = |(opcode ^ 5'b00110);
assign SLBI = |(opcode ^ 5'b10010);
assign LBI = |(opcode ^ 5'b11000);
assign ST = |(opcode ^ 5'b10000);
assign STU = |(opcode ^ 5'b10011);
			
always @(*) begin
	case(instrType)
		2'b00: begin 
			wr_rg = (~JAL) ? 7: 0;
			rd_rg1 = 0;
			rd_rg2 = 0;
		end
		
		2'b01: begin 
			wr_rg = ( ~STU ) ? instr[10:8] : instr[7:5];
			rd_rg1 = instr[10:8];
			rd_rg2 = ( ~STU | ~ST ) ?  instr[7:5] : 3'h0;
		end
		
		2'b10: begin 
			rd_rg1 = instr[10:8];
			wr_rg = (~JALR) ? 7 : ((~SLBI | ~LBI) ? instr[10:8] : 0);
		end
		
		2'b11: begin 
			rd_rg1 = instr[10:8];
			rd_rg2 = instr[7:5];
			wr_rg = instr[4:2];
		end
		
	endcase
end

assign writeReg = wr_rg;
assign readReg_1 = rd_rg1;
assign readReg_2 = rd_rg2;

endmodule
			
			
