/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : shftL.v
   Description     : This is the module for branch logic.
*/
module shftL(in, bit_cnt, Out);

input [15:0] in;
input [3:0] bit_cnt;

output reg [15:0] Out;

wire [15:0] out;

always@(*) begin
	case(bit_cnt)
		4'b0001 : assign Out = {in, 1'h0};
		4'b0010 : assign Out = {in, 2'h0};
		4'b0011 : assign Out = {in, 3'h0};
		4'b0100 : assign Out = {in, 4'h0};
		4'b0101 : assign Out = {in, 5'h0};
		4'b0110 : assign Out = {in, 6'h0};
		4'b0111 : assign Out = {in, 7'h0};
		4'b1000 : assign Out = {in, 8'h0};
		4'b1001 : assign Out = {in, 9'h0};
		4'b1010 : assign Out = {in, 10'h0};
		4'b1011 : assign Out = {in, 11'h0};
		4'b1100 : assign Out = {in, 12'h0};
		4'b1101 : assign Out = {in, 13'h0};
		4'b1110 : assign Out = {in, 14'h0};
		4'b1111 : assign Out = {in, 15'h0};
		// if 0 --> no shft
		default: assign Out = in;
	endcase
end



endmodule
