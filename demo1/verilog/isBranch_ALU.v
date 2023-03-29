/*
   CS/ECE 552 Spring '23
  
   Filename        : isBranch_ALU.v
   Description     : This is the module for branch logic.
*/
module isBranch_ALU(opcode, RsVal, zero);

localparam BEQZ = 5'b01100;
localparam BNEZ = 5'b01101;
localparam BLTZ = 5'b01110;
localparam BGEZ = 5'b01111;


input [4:0] opcode;
input [15:0] RsVal;
output wire zero;

reg zero_i;

always @(*) begin
	case(opcode)
		BEQZ: zero_i = RsVal ? 0 : 1; 
		BNEZ: zero_i = RsVal ? 1 : 0; 
		BLTZ: zero_i = (RsVal[15]) ? 1 : 0; 
		BGEZ: zero_i = (RsVal[15]) ? 0 : 1; 
		default: zero_i = 0;
	endcase
end

assign zero = zero_i;
			
endmodule	
	
	
