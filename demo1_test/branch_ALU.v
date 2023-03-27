module branch_ALU(opcode, RsVal, zero);

input [4:0] opcode;
input [15:0] RsVal;

output wire zero;

reg temp;

always @(*) begin
	case(opcode)
		5'b01100: temp = RsVal ? 0 : 1; 
		5'b01101: temp = RsVal ? 1 : 0; 
		5'b01110: temp = (RsVal[15]) ? 1 : 0; 
		5'b01111: temp = (RsVal[15]) ? 0 : 1; 
		default: temp = 0;
	endcase
end

assign zero = temp;
			
endmodule	
	
	
