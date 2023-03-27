/*
   CS/ECE 552, Spring '23
   Homework #3, Problem #1
  
   This module creates a 16-bit register file.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock. 
*/
`default_nettype none
module rf (
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
	
	// outputs for registers
	wire[15:0] data0, data1, data2, data3, data4, data5, data6, data7; 
	// write enables based on the writeRegSel value
	wire wr0, wr1, wr2, wr3, wr4, wr5, wr6, wr7;
	
	// err logic
  	// (input == X) --> err = 1
	assign err = (^clk === 1'bx) ? 1'b1 : 
	(^rst === 1'bx) ? 1'b1 : 
	(^read1RegSel === 1'bx) ? 1'b1 :
	(^read2RegSel === 1'bx) ? 1'b1 : 
	(^writeRegSel === 1'bx) ? 1'b1 :
	(^writeInData === 1'bx) ? 1'b1 :
	(^writeEn === 1'bx) ? 1'b1 : 1'b0;

	// 3 to 8 decoder logic
	assign wr7 = writeEn & (writeRegSel == 7); 
	assign wr6 = writeEn & (writeRegSel == 6);
	assign wr5 = writeEn & (writeRegSel == 5);
	assign wr4 = writeEn & (writeRegSel == 4);
	assign wr3 = writeEn & (writeRegSel == 3);
	assign wr2 = writeEn & (writeRegSel == 2);
	assign wr1 = writeEn & (writeRegSel == 1);
	assign wr0 = writeEn & (writeRegSel == 0);

	// instantiate registers
	register r0(.clk(clk), .rst(rst), .write(wr0), .write_data(writeInData), .read_data(data0));
	register r1(.clk(clk), .rst(rst), .write(wr1), .write_data(writeInData), .read_data(data1));
	register r2(.clk(clk), .rst(rst), .write(wr2), .write_data(writeInData), .read_data(data2));
	register r3(.clk(clk), .rst(rst), .write(wr3), .write_data(writeInData), .read_data(data3));
	register r4(.clk(clk), .rst(rst), .write(wr4), .write_data(writeInData), .read_data(data4));
	register r5(.clk(clk), .rst(rst), .write(wr5), .write_data(writeInData), .read_data(data5));
	register r6(.clk(clk), .rst(rst), .write(wr6), .write_data(writeInData), .read_data(data6));
	register r7(.clk(clk), .rst(rst), .write(wr7), .write_data(writeInData), .read_data(data7));
 	
	// 8 to 1 mux to select register
	assign read1OutData = read1RegSel[2] ? (read1RegSel[1] ? (read1RegSel[0] ? data7 : data6) 
	: (read1RegSel[0] ? data5 : data4)) : (read1RegSel[1] ? (read1RegSel[0] ? data3 : data2)
	: (read1RegSel[0] ? data1 : data0)); 

	assign read2OutData = read2RegSel[2] ? (read2RegSel[1] ? (read2RegSel[0] ? data7 : data6) 
	: (read2RegSel[0] ? data5 : data4)) : (read2RegSel[1] ? (read2RegSel[0] ? data3 : data2)
	: (read2RegSel[0] ? data1 : data0)); 

endmodule
`default_nettype wire