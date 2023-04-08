module regRead(instr, num);
	input wire [15:0] instr;
	output wire [1:0] num;

	wire [4:0] opcode;
	assign opcode = instr[15:11];
	reg [1:0] num_temp;

	always@(*) begin
	   case(opcode)
			5'b00000: begin			/************************************ HALT */
						num_temp = 2'h0;
					 end
			5'b00001: begin			/************************************ NOP */
						num_temp = 2'h0;
					 end
			5'b00100: begin			/************************************ J */
						num_temp = 2'h0;
					 end
			5'b00110: begin			/************************************ JAL */
						num_temp = 2'h0;
					 end
			5'b01000: begin			/************************************ ADDI */
						num_temp = 2'h1;
					 end
			5'b01001: begin			/************************************ SUBI */
						num_temp = 2'h1;
					 end
			5'b01010: begin			/************************************ XORI */
						num_temp = 2'h1;
					 end
			5'b01011: begin			/************************************ ANDNI */
						num_temp = 2'h1;
					 end
			5'b10100: begin			/************************************ ROLI */
						num_temp = 2'h1;
					 end
			5'b10101: begin			/************************************ SLLI */
						num_temp = 2'h1;
					 end
			5'b10110: begin			/************************************ RORI */
						num_temp = 2'h1;
					 end
			5'b10111: begin			/************************************ SRLI */
						num_temp = 2'h1;
					 end
			5'b10000: begin			/************************************ ST */
						num_temp = 2'h2;
					 end
			5'b10001: begin			/************************************ LD */
						num_temp = 2'h1;
					 end
			5'b10011: begin			/************************************ STU */
						num_temp = 2'h2;
					 end
			5'b11000: begin			/************************************ LBI */
						num_temp = 2'h0;
					 end
			5'b10010: begin			/************************************ SLBI */
						num_temp = 2'h1;
					 end
			5'b00101: begin			/************************************ JR */
						num_temp = 2'h1;
					 end
			5'b00111: begin			/************************************ JALR */
						num_temp = 2'h1;
					 end
			5'b01100: begin			/************************************ BEQZ */
						num_temp = 2'h1;
					 end
			5'b01101: begin			/************************************ BNEZ */
						num_temp = 2'h1;
					 end
			5'b01110: begin			/************************************ BLTZ */
						num_temp = 2'h1;
					 end
			5'b01111: begin			/************************************ BGEZ */
						num_temp = 2'h1;
					 end
			5'b11001: begin			/************************************ BTR */
						num_temp = 2'h1;
					 end
			5'b11011: begin			/************************************ ADD, SUB, XOR, ANDN */
						num_temp = 2'h2;
					 end
			5'b11010: begin			/************************************ ROL, SLL, ROR, SRL */
						num_temp = 2'h2;
					 end
			5'b11100: begin			/************************************ SEQ */
						num_temp = 2'h2;
					 end
			5'b11101: begin			/************************************ SLT */
						num_temp = 2'h2;
					 end
			5'b11110: begin			/************************************ SLE */
						num_temp = 2'h2;
					 end
			5'b11111: begin			/************************************ SCO */
						num_temp = 2'h2;
					 end
			default: begin
						num_temp = 2'h0;
					end
		endcase
	end
	
	assign num = num_temp;

endmodule
