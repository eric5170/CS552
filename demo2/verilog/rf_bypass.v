/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #2
  
   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
`default_nettype none
module rf_bypass (
                  // Outputs
                  read1OutData, read2OutData, err,
                  // Inputs
                  clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                  );

	input wire       clk, rst;
	input wire [2:0] read1RegSel;
	input wire [2:0] read2RegSel;
	input wire [2:0] writeRegSel;
	input wire [15:0] writeData;
	input wire        writeEn;

	output wire [15:0] read1OutData;
	output wire [15:0] read2OutData;
	output wire        err;

	wire [15:0] output1, output2;
	reg [15:0] bypass1, bypass2;
	wire wire1, wire2;

	//rf DUT instantiation
	rf iReg (.read1Data(output1), .read2Data(output2), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel),
	.read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn)); 

	assign wire1 = |(writeRegSel ^ read1RegSel);
	assign wire2 = |(writeRegSel ^ read2RegSel);

	always @(*) begin
		case(wire1)
			1'b0: bypass1 = writeEn ? writeData : output1;
			1'b1: bypass1 = output1;
			default: bypass1 = 16'h0;
		endcase
	end

	always @(*) begin
		case(wire2)
			1'b0: bypass2 =  writeEn ? writeData : output2;
			1'b1: bypass2 = output2;
			default: bypass1 = 16'h0;
		endcase
	end

	assign read1OutData = bypass1; 
	assign read2OutData = bypass2;

endmodule
`default_nettype wire
