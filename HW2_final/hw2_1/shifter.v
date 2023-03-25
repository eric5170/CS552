/*
    CS/ECE 552 Spring '23
    Homework #2, Problem 1
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
`default_nettype none
module shifter (InBS, ShAmt, ShiftOper, OutBS);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input wire [OPERAND_WIDTH -1:0] InBS;  // Input operand
    input wire [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input wire [NUM_OPERATIONS-1:0] ShiftOper;  // Operation type
    output wire [OPERAND_WIDTH -1:0] OutBS;  // Result of shift/rotate

	reg [15:0] shftmed1;
	reg [15:0] shftmed2;
	reg [15:0] shftmed3;
	reg [15:0] shftmed4;
   /* YOUR CODE HERE */
   
   assign OutBS = shftmed4;
   always @(*)	begin
		case (ShiftOper)
			// shift left
			2'b00: begin
				shftmed1 = ShAmt[0] == 1 ? InBS << 1 : InBS;
				shftmed2 = ShAmt[1] == 1 ? shftmed1 << 2 : shftmed1;
				shftmed3 = ShAmt[2] == 1 ? shftmed2 << 4 : shftmed2;
				shftmed4 = ShAmt[3] == 1 ? shftmed3 << 8 : shftmed3;
			end
			
			// shift right logical
			2'b01: begin
				shftmed1 = ShAmt[0] == 1 ? InBS >> 1 : InBS;
				shftmed2 = ShAmt[1] == 1 ? shftmed1 >> 2 : shftmed1;
				shftmed3 = ShAmt[2] == 1 ? shftmed2 >> 4 : shftmed2;
				shftmed4 = ShAmt[3] == 1 ? shftmed3 >> 8 : shftmed3;
			end
			
			// rotate left
			2'b10: begin
				shftmed1 = ShAmt[0] == 1 ? {InBS[14:0], InBS[15]} : InBS;
				shftmed2 = ShAmt[1] == 1 ? {shftmed1[13:0], shftmed1[15:14]} : shftmed1;
				shftmed3 = ShAmt[2] == 1 ? {shftmed2[11:0], shftmed2[15:12]} : shftmed2;
				shftmed4 = ShAmt[3] == 1 ? {shftmed3[7:0], shftmed3[15:8]} : shftmed3;
			end
			
			// shift right arithmetic
			2'b11: begin
				shftmed1 = ShAmt[0] == 1 ? {InBS[15], InBS[15:1]} : InBS;
				shftmed2 = ShAmt[1] == 1 ? {{2{shftmed1[15]}}, shftmed1[15:2]} : shftmed1;
				shftmed3 = ShAmt[2] == 1 ? {{4{shftmed2[15]}}, shftmed2[15:4]} : shftmed2;
				shftmed4 = ShAmt[3] == 1 ? {{8{shftmed3[15]}}, shftmed3[15:8]} : shftmed3;
			end
			default: 
				shftmed4 = InBS;

		endcase
	end
  
endmodule

