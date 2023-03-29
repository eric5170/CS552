module instr_decode(isType, instr, read_reg1, read_reg2, writeReg, incr_PC);

input wire [1:0] isType;
input wire[15:0] instr;
input wire[15:0] incr_PC;
output wire [2:0] read_reg1, read_reg2, writeReg;

reg [2:0] readReg1Wire, readReg2Wire, writeRegWire;
wire [4:0] opcode;
wire JALROpcode, JALOpcode, SLBIOpcode, LBIOpcode, STOpcode, STUOpcode;

assign opcode = instr[15:11];
assign JALROpcode = |(opcode ^ 5'b00111);
assign JALOpcode = |(opcode ^ 5'b00110);
assign SLBIOpcode = |(opcode ^ 5'b10010);
assign LBIOpcode = |(opcode ^ 5'b11000);
assign STOpcode = |(opcode ^ 5'b10000);
assign STUOpcode = |(opcode ^ 5'b10011);
			
always @(*) begin
	case(isType)
		2'b00: begin //J format 5 bits [OpCode], 11 bits [Displacement]
			writeRegWire = (~JALOpcode) ? 7: 0;
			readReg1Wire = 0;
			readReg2Wire = 0;
			end
		2'b01: begin //I format 1 5 bits [OpCode], 3 bits [Rs], 3 bits [Rd], 5 bits [Immediate]
			// Reg1 = Rs, R2 = Rt,
			// If ST - not writing to register.
			writeRegWire = ( ~STUOpcode ) ? instr[10:8] : instr[7:5];
			
			// Rs is the same position for all instr
			readReg1Wire = instr[10:8];

			// If it's STU or ST, Rd is written to mem
			readReg2Wire = ( ~STUOpcode | ~STOpcode ) ?  instr[7:5] : 3'h0;

			end
		2'b10: begin //I format 2 5 bits [OpCode], 3 bits [Rs], 8 bits [Immediate]
			readReg1Wire = instr[10:8];
			//If JALR, writeReg = R7. If SLBI or LBI, writeReg = Rs. Else, we don't care what writeReg is.
			writeRegWire = (~JALROpcode) ? 7 : ((~SLBIOpcode | ~LBIOpcode) ? instr[10:8] : 0);
		   	end
		2'b11: begin //R format 5 bits [OpCode], 3 bits[Rs], 3 bits[Rt], 3 bits[Rd], 2 bits[Op Code Extension]
			readReg1Wire = instr[10:8];
			readReg2Wire = instr[7:5];
			writeRegWire = instr[4:2];
			end
		default: begin
			readReg1Wire = 2'bxx;
			readReg2Wire = 2'bxx;
		end
	endcase
end

assign writeReg = writeRegWire;
assign read_reg1 = readReg1Wire;
assign read_reg2 = readReg2Wire;

endmodule
			
			
