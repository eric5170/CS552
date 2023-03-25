/*
    CS/ECE 552 Spring '23
    Homework #2, Problem 2

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
`default_nettype none
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
    input wire  [OPERAND_WIDTH -1:0] InA ; // Input wire operand A
    input wire  [OPERAND_WIDTH -1:0] InB ; // Input wire operand B
    input wire                       Cin ; // Carry in
    input wire  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input wire                       invA; // Signal to invert A
    input wire                       invB; // Signal to invert B
    input wire                       sign; // Signal for signed operation
    output wire [OPERAND_WIDTH -1:0] Out ; // Result of comput wireation
    output wire                      Ofl ; // Signal if overflow occured
    output wire                      Zero; // Signal if Out is 0

    /* YOUR CODE HERE */
     /* YOUR CODE HERE */
    wire [15:0] InA_out, InB_out, InA_ADD, InB_ADD;
    wire [15:0] ADD, AND, OR, XOR, SHFT;
    wire [15:0] Out1, Out2, Out3, Out4, Out5;
    wire C_ofl, Ofl1, Ofl2, Ofl3;
     
    
    //inverting step
    assign InA_out = (invA)? ~InA : InA;
    assign InB_out = (invB)? ~InB : InB;

   
    //SHFT  
    
    //instantiate shfter module 
    shifter iShft(.InBS(InA_out), .ShAmt(InB_out[3:0]), .ShiftOper(Oper[1:0]), .OutBS(SHFT));

    //CLA
    //100 = ADD
    //instantiate CLA
    cla16b iCLA(.sum(ADD), .cOut(C_ofl), .inA(InA_out), .inB(InB_out), .cIn(Cin));
    //overflow logic   
    
    //unsigned case
    assign Ofl1 = (~sign & (C_ofl));

    //signed case
    //InA = - , InB = -
    assign Ofl2 = (sign & (InA_out[15] & InB_out[15])& (C_ofl & ~ADD[15]));
    //InA = + , InB = +
    assign Ofl3 = (sign & (~InA_out[15] & ~InB_out[15]) & (ADD[15] | C_ofl));
    
    assign Ofl = Ofl1 | Ofl2 | Ofl3;

    //101 = AND
    assign AND = InA_out & InB_out;
    //110 = OR
    assign OR = InA_out | InB_out;
    //111 = XOR
    assign XOR = InA_out ^ InB_out;

     
 //if Oper[2] is 1 --> use shifter module; otherwise, use cla module
    assign Out1 = (~Oper[2]) ? SHFT : 1'b0;
    assign Out2 = (Oper[2] & ~Oper[1] & ~Oper[0]) ? ADD : 1'b0;
    assign Out3 = (Oper[2] & ~Oper[1] & Oper[0]) ? AND : 1'b0;
    assign Out4 = (Oper[2] & Oper[1] & ~Oper[0]) ? OR : 1'b0;
    assign Out5 = (Oper[2] & Oper[1] & Oper[0]) ? XOR : 1'b0;
    assign Out = (Out1 | Out2 | Out3 | Out4 | Out5); 
    assign Zero = (Out == 0) ? 1'b1: 1'b0;
endmodule
`default_nettype wire
