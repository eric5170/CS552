module instr_type(instr, isType);

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
	output wire [1:0] isType;
	
	wire [4:0] opcode;
	assign opcode = instr[15:11];
	
	reg [1:0] isType_temp;
	assign isType = isType_temp;

	always@(*) begin
	   case(opcode)
			HALT: begin			
						isType_temp = 0;
					 end
			NOP: begin			
						isType_temp = 0;
					 end
			J: begin			
						isType_temp = 0;
					 end
			JAL: begin			
						isType_temp = 0;
					 end
			ADDI: begin			
						isType_temp = 1;
					 end
			SUBI: begin			
						isType_temp = 1;
					 end
			 XORI: begin			
						isType_temp = 1;
					 end
			ANDNI: begin		
						isType_temp = 1;
					 end
			ROLI: begin			
						isType_temp = 1;
					 end
			SLLI: begin			
						isType_temp = 1;
					 end
			RORI: begin			
						isType_temp = 1;
					 end
			SRLI: begin			
						isType_temp = 1;
					 end
			ST: begin			
						isType_temp = 1;
					 end
			LD: begin			
						isType_temp = 1;
					 end
			STU: begin			
						isType_temp = 1;
					 end
			LBI: begin			
						isType_temp = 2;
					 end
			SLBI: begin			
						isType_temp = 2;
					 end
			JR: begin			
						isType_temp = 2;
					 end
			JALR: begin			
						isType_temp = 2;
					 end
			BEQZ: begin			
						isType_temp = 2;
					 end
			BNEZ: begin		
						isType_temp = 2;
					 end
			BLTZ: begin		
						isType_temp = 2;
					 end
			BGEZ: begin			
						isType_temp = 2;
					 end
			BTR: begin			
						isType_temp = 3;
					 end
			ALU_1: begin			
						isType_temp = 3;
					 end
			ALU_2: begin			
						isType_temp = 3;
					 end
			SEQ: begin			
						isType_temp = 3;
					 end
			SLT: begin			
						isType_temp = 3;
					 end
			SLE: begin			
						isType_temp = 3;
					 end
			SCO: begin			
						isType_temp = 3;
					 end
			default: begin
						isType_temp = 2'bxx;
					end
		endcase
	end

endmodule