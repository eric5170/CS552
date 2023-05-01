/*
   CS/ECE 552 Spring '23
    
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : dff_en.v
   
   Description     : This is the module for the dff with enable signal by instantiating the original dff module
*/
module dff_en (en, q, d, clk, rst);
	input en, d, clk, rst;
	output q;
	wire data;

	assign data = en ? d : q;

	dff DFF(.d(data), .q(q), .clk(clk), .rst(rst));

endmodule