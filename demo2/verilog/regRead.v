/*
   CS/ECE 552 Spring '23
  
   Filename        : regRead.v
   Description     : This is the module for counting numbers of register being read for hazard detection logic.
*/
module regRead(instr, num);
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

	// R-format 
	localparam 	BTR 		= 5'b11001; 
	//consists of ADD...
	localparam	ALU_1 		= 5'b11011; 
	localparam	ALU_2 		= 5'b11010; 
	localparam SEQ			= 5'b11100;
	localparam SLT			= 5'b11101;
	localparam SLE			= 5'b11110;
	localparam SCO			= 5'b11111;

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

	// Special instructions
	localparam 	SIIC  		= 5'b00010;
	localparam 	NOP 		= 5'b00001;
	localparam 	NOP_RTI 	= 5'b00011;
	localparam 	HALT 		= 5'b00000;

	input wire [15:0] instr;
	output wire [1:0] num;

	wire [4:0] opcode;
	assign opcode = instr[15:11];
	reg [1:0] num_temp;

	always@(*) begin
	    case(opcode)
			HALT: begin			
						num_temp = 2'h0;
			end
			
			NOP: begin			
						num_temp = 2'h0;
			end
			
			J: begin			
						num_temp = 2'h0;
			end
			
			JAL: begin		
						num_temp = 2'h0;
			end
			
			ADDI: begin			
						num_temp = 2'h1;
			end
			
			SUBI: begin		
						num_temp = 2'h1;
			end
			
			XORI: begin			
						num_temp = 2'h1;
			end
			
			ANDNI: begin			
						num_temp = 2'h1;
			end
			
			ROLI: begin			
						num_temp = 2'h1;
			end
			
			SLLI: begin			
						num_temp = 2'h1;
			end
			
			RORI: begin			
						num_temp = 2'h1;
			end
			
			SRLI: begin			
						num_temp = 2'h1;
			end
			
			ST: begin			
						num_temp = 2'h2;
			end
			
			LD: begin			
						num_temp = 2'h1;
			end
			
			STU: begin			
						num_temp = 2'h2;
			end
			
			LBI: begin			
						num_temp = 2'h0;
			end
			
			SLBI: begin			
						num_temp = 2'h1;
			end
			
			JR: begin			
						num_temp = 2'h1;
			end
			
			JALR: begin			
						num_temp = 2'h1;
			end
			
			BEQZ: begin			
						num_temp = 2'h1;
			end
			
			BNEZ: begin			
						num_temp = 2'h1;
			end
			
			BLTZ: begin			
						num_temp = 2'h1;
			end
			
			BGEZ: begin			
						num_temp = 2'h1;
			end
			
			BTR: begin			
						num_temp = 2'h1;
			end
			
			ALU_1: begin			
						num_temp = 2'h2;
			end
			
			ALU_2: begin			
						num_temp = 2'h2;
			end
			
			SEQ: begin			
						num_temp = 2'h2;
			end
			
			SLT: begin			
						num_temp = 2'h2;
			end
			
			SLE: begin			
						num_temp = 2'h2;
			end
			
			SCO: begin			
						num_temp = 2'h2;
			end
			
			default: begin
						num_temp = 2'h0;
			end
			
		endcase
	end
	
	assign num = num_temp;

endmodule