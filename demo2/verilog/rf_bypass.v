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
wire comp1, comp2;

rf registerFile (.read1OutData(output1), .read2OutData(output2), .err(err), .clk(clk), .rst(rst), 
	.read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), 
	.writeInData(writeInData), .writeEn(writeEn)); 

assign comp1 = |(writeRegSel ^ read1RegSel);
assign comp2 = |(writeRegSel ^ read2RegSel);

assign read1OutData = compl ? output1 : (writeEn ? writeInData : output1);
assign read2OutData = compl ? output2 : (writeEn ? writeInData : output2);

endmodule
`default_nettype wire
