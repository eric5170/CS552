/* imm extension :  
 *	5 byte extension (sign/zero) 
 *	8 byte extension (sign/zero)
 *	11 byte extension (sign)
 */			
module ext(instr, imm);

input [15:0] instr;
output reg [15:0] imm;

wire [4:0] opcode;
assign opcode = instr[15:11];


// I-format 1
localparam	ADDI 		= 5'b01000; 
localparam 	SUBI 		= 5'b01001; 
localparam	XORI 		= 5'b01010; 
localparam 	ANDNI 		= 5'b01011; 
localparam	ROLI  		= 5'b10100; 
localparam 	SLLI 		= 5'b10101; 
localparam	RORI 		= 5'b10110; 
localparam 	SRLI 		= 5'b10111; 
localparam	ST 			= 5'b10000; 
localparam 	LD 			= 5'b10001; 
localparam	STU 		= 5'b10011; 

// I-format 2
localparam 	BEQZ 		= 5'b01100;
localparam 	BNEZ 		= 5'b01101;
localparam 	BLTZ 		= 5'b01110;
localparam 	BGEZ 		= 5'b01111;
localparam 	LBI 		= 5'b11000;
localparam 	SLBI 		= 5'b10010;
localparam 	J 			= 5'b00100;
localparam 	JR 			= 5'b00101;

// J-format
localparam 	JAL 		= 5'b00110;
localparam 	JALR 		= 5'b00111;

/*
 * 5b sign: ADDI , SUBI
 * 5b zero: XORI, ANDNI
 * 8b sign: LBI, JR, JALR, all branch instr
 * 8b zero: SLBI
 * 11b sign: J, JAL
 * 
 */
always@(*) begin
   case(opcode)
		J: begin
			imm = {{5{instr[10]}}, instr[10:0]};
		end
				
		JAL: begin		
			imm = {{5{instr[10]}}, instr[10:0]};
		end
		
		ADDI: begin	
			imm = {{11{instr[4]}}, instr[4:0]};
		end
		
		SUBI: begin			
			imm = {{11{instr[4]}}, instr[4:0]};
		end
		
		XORI: begin		
			imm = {11'h0, instr[4:0]};
		end
		
		ANDNI: begin		
			imm = {11'h0, instr[4:0]};
		end
		
		LBI: begin	
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		SLBI: begin			
			imm = {8'h0, instr[7:0]};
		end
		
		JR: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		JALR: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		BEQZ: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		BNEZ: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		BLTZ: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		BGEZ: begin			
			imm = {{8{instr[7]}}, instr[7:0]};
		end
		
		// shft/rot functions
		default: begin
				imm = {{11{instr[4]}}, instr[4:0]}; 
		end
   endcase
end

endmodule
