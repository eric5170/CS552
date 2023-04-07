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
                  clk, rst, read1RegSel, read2RegSel, writeRegSel, writeInData, writeEn
                  );

   input wire       clk, rst;
   input wire [2:0] read1RegSel;
   input wire [2:0] read2RegSel;
   input wire [2:0] writeRegSel;
   input wire [15:0] writeInData;
   input wire        writeEn;

   output wire [15:0] read1OutData;
   output wire [15:0] read2OutData;
   output wire        err;

wire [15:0] output1, output2;
reg [15:0] bypass1, bypass2;
wire comp1, comp2;

//rf DUT instantiation
rf registerFile (.read1Data(output1), .read2Data(output2), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeInData), .writeEn(writeEn)); 

assign comp1 = |(writeRegSel ^ read1RegSel);
assign comp2 = |(writeRegSel ^ read2RegSel);

always @(*) begin
	case(comp1)
		1'b0: bypass1 = writeEn ? writeInData : output1;
		1'b1: bypass1 = output1;
	endcase
	end

	always @(*) begin
	case(comp2)
		1'b0: bypass2 =  writeEn ? writeInData : output2;
		1'b1: bypass2 = output2;
	endcase
	end

assign read1OutData = bypass1; 
assign read2OutData = bypass2;
endmodule
`default_nettype wire
