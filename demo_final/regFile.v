
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                );

   input clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */
   wire [15:0] state0, state1, state2, state3, state4, state5, state6, state7;
   wire [15:0] in0, in1, in2, in3, in4, in5, in6, in7;
   reg [15:0] read1, read2;
   reg err_i;

   register reg0(.clk(clk), .rst(rst), .data_in(in0), .state(state0));
   register reg1(.clk(clk), .rst(rst), .data_in(in1), .state(state1));
   register reg2(.clk(clk), .rst(rst), .data_in(in2), .state(state2));
   register reg3(.clk(clk), .rst(rst), .data_in(in3), .state(state3));
   register reg4(.clk(clk), .rst(rst), .data_in(in4), .state(state4));
   register reg5(.clk(clk), .rst(rst), .data_in(in5), .state(state5));
   register reg6(.clk(clk), .rst(rst), .data_in(in6), .state(state6));
   register reg7(.clk(clk), .rst(rst), .data_in(in7), .state(state7));
 
	always@(*) begin
		case(read1RegSel) 
		3'b000: begin 
			err_i = 0;
			read1 = state0;
			end
		3'b001: begin 
			err_i = 0;
			read1 = state1;
			end
		3'b010: begin 
			err_i = 0;
			read1 = state2;
			end
		3'b011: begin 
			err_i = 0;
			read1 = state3;
			end
		3'b100: begin 
			err_i = 0;
			read1 = state4;
			end
		3'b101: begin 
			err_i = 0;
			read1 = state5;
			end
		3'b110: begin 
			err_i = 0;
			read1 = state6;
			end
		3'b111: begin 
			err_i = 0;
			read1 = state7;
			end
		default: err_i = 1;
		endcase
	end

	always@(*) begin 
		case(read2RegSel) 
		3'b000: begin 
			err_i = 0;
			read2 = state0;
			end
		3'b001: begin 
			err_i = 0;
			read2 = state1;
			end
		3'b010: begin 
			err_i = 0;
			read2 = state2;
			end
		3'b011: begin 
			err_i = 0;
			read2 = state3;
			end
		3'b100: begin 
			err_i = 0;
			read2 = state4;
			end
		3'b101: begin 
			err_i = 0;
			read2 = state5;
			end
		3'b110: begin 
			err_i = 0;
			read2 = state6;
			end
		3'b111: begin 
			err_i = 0;
			read2 = state7;
			end
		default: err_i = 1;
		endcase 
	end


	assign in0 = writeEn ? ( (writeRegSel == 3'h0) ? writeData : state0 ) : state0;
	assign in1 = writeEn ? ( (writeRegSel == 3'h1) ? writeData : state1 ) : state1;
	assign in2 = writeEn ? ( (writeRegSel == 3'h2) ? writeData : state2 ) : state2;
	assign in3 = writeEn ? ( (writeRegSel == 3'h3) ? writeData : state3 ) : state3;
	assign in4 = writeEn ? ( (writeRegSel == 3'h4) ? writeData : state4 ) : state4;
	assign in5 = writeEn ? ( (writeRegSel == 3'h5) ? writeData : state5 ) : state5;
	assign in6 = writeEn ? ( (writeRegSel == 3'h6) ? writeData : state6 ) : state6;
	assign in7 = writeEn ? ( (writeRegSel == 3'h7) ? writeData : state7 ) : state7;


	assign read1Data = read1;
	assign read2Data = read2;
	assign err = err_i;


endmodule

