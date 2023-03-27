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

// register-written data
wire [15:0] output1, output2;
// bypass mux for read1, read2
wire bypass1, bypass2;

//rf DUT instantiation
rf registerFile (.read1OutData(output1), .read2OutData(output2), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeInData(writeInData), .writeEn(writeEn)); 

// bypass logic 
// write register == read register  --> output = write_data; otherwise --> ouptut = register output
assign bypass1 = writeEn & (writeRegSel == read1RegSel);
assign bypass2 = writeEn & (writeRegSel == read2RegSel);

assign read1OutData = bypass1 ? writeInData : output1;
assign read2OutData = bypass1 ? writeInData : output2;
   
endmodule
`default_nettype wire