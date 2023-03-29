/*
   CS/ECE 552 Spring '23
  
   Filename        : rotateR.v
   Description     : This is the module for right rotation logic
*/
module rotateR(in, bit_cnt, Out);

input [15:0] in;
input [3:0] bit_cnt;

output reg [15:0] Out;

always@(*) begin
	case(bit_cnt)
		4'b0001 : assign Out = {in[0], in[15:1]};
		4'b0010 : assign Out = {in[1:0], in[15:2]};
		4'b0011 : assign Out = {in[2:0], in[15:3]};
		4'b0100 : assign Out = {in[3:0], in[15:4]};
		4'b0101 : assign Out = {in[4:0], in[15:5]};
		4'b0110 : assign Out = {in[5:0], in[15:6]};
		4'b0111 : assign Out = {in[6:0], in[15:7]};
		4'b1000 : assign Out = {in[7:0], in[15:8]};
		4'b1001 : assign Out = {in[8:0], in[15:9]};
		4'b1010 : assign Out = {in[9:0], in[15:10]};
		4'b1011 : assign Out = {in[10:0], in[15:11]};
		4'b1100 : assign Out = {in[11:0], in[15:12]};
		4'b1101 : assign Out = {in[12:0], in[15:13]};
		4'b1110 : assign Out = {in[13:0], in[15:14]};
		4'b1111 : assign Out = {in[14:0], in[15]};
		// 0 --> no rotation
		default: assign Out = in;
	endcase
end

endmodule
