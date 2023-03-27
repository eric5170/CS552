module rotR(instr, cnt, out);

input [15:0] instr;
input [3:0] cnt;

output reg [15:0] out;

always@(*) begin
	case(cnt)
		4'b0000 : assign out = instr;
		4'b0001 : assign out = {instr[0], instr[15:1]};
		4'b0010 : assign out = {instr[1:0], instr[15:2]};
		4'b0011 : assign out = {instr[2:0], instr[15:3]};
		4'b0100 : assign out = {instr[3:0], instr[15:4]};
		4'b0101 : assign out = {instr[4:0], instr[15:5]};
		4'b0110 : assign out = {instr[5:0], instr[15:6]};
		4'b0111 : assign out = {instr[6:0], instr[15:7]};
		4'b1000 : assign out = {instr[7:0], instr[15:8]};
		4'b1001 : assign out = {instr[8:0], instr[15:9]};
		4'b1010 : assign out = {instr[9:0], instr[15:10]};
		4'b1011 : assign out = {instr[10:0], instr[15:11]};
		4'b1100 : assign out = {instr[11:0], instr[15:12]};
		4'b1101 : assign out = {instr[12:0], instr[15:13]};
		4'b1110 : assign out = {instr[13:0], instr[15:14]};
		4'b1111 : assign out = {instr[14:0], instr[15]};
	endcase
end

endmodule
