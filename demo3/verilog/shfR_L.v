/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : shfR_L.v
   Description     : This is the module for shfR_L logic.
*/
module shfR_L(in, bit_cnt, Out);

input [15:0] in;
input [3:0] bit_cnt;

output reg [15:0] Out;


always@(*) begin
	case(bit_cnt)
		4'b0001 : assign Out = {1'h0, in[15:1]};
		4'b0010 : assign Out = {2'h0, in[15:2]};
		4'b0011 : assign Out = {3'h0, in[15:3]};
		4'b0100 : assign Out = {4'h0, in[15:4]};
		4'b0101 : assign Out = {5'h0, in[15:5]};
		4'b0110 : assign Out = {6'h0, in[15:6]};
		4'b0111 : assign Out = {7'h0, in[15:7]};
		4'b1000 : assign Out = {8'h0, in[15:8]};
		4'b1001 : assign Out = {9'h0, in[15:9]};
		4'b1010 : assign Out = {10'h0, in[15:10]};
		4'b1011 : assign Out = {11'h0, in[15:11]};
		4'b1100 : assign Out = {12'h0, in[15:12]};
		4'b1101 : assign Out = {13'h0, in[15:13]};
		4'b1110 : assign Out = {14'h0, in[15:14]};
		4'b1111 : assign Out = {15'h0, in[15]};
		// 0 -> no shft
		default:  assign Out = in;
	endcase
end



endmodule