/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (/* TODO: Add appropriate inputs/outputs for your WB stage here*/
				//	INPUT:
				//	Control Unit
				MemToReg,
				
				//	ALU
				read_data,
				ALUResult,
				
				//	OUTPUT:
				writeback_data);

	mux2_1 WRITE_MUX(.out(writeback_data), .inputA(ALUResult),
		.inputB(read_data), .sel(MemToReg));
   // TODO: Your code here
   
endmodule
`default_nettype wire
