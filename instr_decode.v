/*
   CS/ECE 552 Spring '23
  
   Filename        : instr_decode.v
   Description     : This is the module for decoding instructions to specified ports.
*/
module instr_decode(instr, incr_PC, isType, read_reg1, read_reg2, writeReg, immed);

localparam 	JAL 		= 5'b00110;
localparam 	JALR 		= 5'b00111;
localparam 	SLBI 		= 5'b10010;
localparam 	LBI 		= 5'b11000;
localparam 	ST			= 5'b10000;
localparam 	STU			= 5'b10011;

localparam J = 2'b00;
localparam I1 = 2'b01;
localparam I2 = 2'b10;
localparam R = 2'b11;

input wire[15:0] instr, incr_PC;
input wire [1:0] isType;

output wire [2:0] read_reg1, read_reg2, writeReg;
output reg [15:0] immed;

reg [2:0] readReg1Wire, readReg2Wire, writeRegWire;
wire [4:0] opcode;
//flags for the operations
wire JALR_f, JAL_f, SLBI_f, LBI_f, ST_f, STU_f;

wire I1_Extend, I2_Extend;


mux2_1 I1_MUX[15:0](.out(I1_Extend), .inputA({ {11{instr[4]}}, instr[4:0] }),
	.inputB({ {11{1'b0}}, instr[4:0] }), .sel(instr[12]));
	
	
mux2_1 I2_MUX[15:0](.out(I2_Extend), .inputA({ {8{instr[7]}}, instr[7:0] }),
	.inputB({ {8{1'b0}}, instr[7:0] }), .sel(instr[12]));

assign opcode = instr[15:11];

// flag logic
assign JAL_f = |(opcode ^ JAL);
assign JALR_f = |(opcode ^ JALR);
assign SLBI_f = |(opcode ^ SLBI);
assign LBI_f = |(opcode ^ LBI);
assign ST_f = |(opcode ^ ST);
assign STU_f = |(opcode ^ STU);

			
always @(*) begin
	case(isType)
	 
		J: begin 
			writeRegWire = (~JAL_f) ? 7: 0;
			readReg1Wire = 0;
			readReg2Wire = 0;
			immed = { {5{instr[10]}}, instr[10:0] };
		end
		
	
		I1: begin 
			writeRegWire = ( ~STU_f ) ? instr[10:8] : instr[7:5];
			readReg1Wire = instr[10:8];
			readReg2Wire = ( ~STU_f | ~ST_f ) ?  instr[7:5] : 3'h0;
			immed = I1_Extend;

		end
		
		I2: begin 
			readReg1Wire = instr[10:8];
			writeRegWire = (~JALR_f) ? 7 : ((~SLBI_f | ~LBI_f) ? instr[10:8] : 0);
			immed = I2_Extend;
		end
		
		R: begin 
			readReg1Wire = instr[10:8];
			readReg2Wire = instr[7:5];
			writeRegWire = instr[4:2];
			assign immed = 1'b0;
			
		end
		
		 //if none matches --> XX
		default: begin
			readReg1Wire = 2'bxx;
			readReg2Wire = 2'bxx;
			assign immed = 1'b0;
		end
		
	endcase
end

assign writeReg = writeRegWire;
assign read_reg1 = readReg1Wire;
assign read_reg2 = readReg2Wire;

endmodule
			
			
