/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : hazard_detect.v
   
   Description     : This is the module for hazard_detection logic depending on the number of register being read.
*/
module hazard_detect(		
					input wire [15:0] instr,

                    input wire [2:0] writeRegSel_DX, 
					input wire [2:0] writeRegSel_EM,
					input wire [2:0] readRegSel1, 
					input wire [2:0] readRegSel2, 
					
					input wire isRegWrite_DX,
					input wire isRegWrite_EM,
					input wire isRegWrite_MW,
					
					input wire isJAL_DX,
					input wire isJAL_EM,
					input wire memRead_DX,
					input wire memRead_EM,
					
					output wire stall,
					output wire r1_hazard,
					output wire r2_hazard
                            );
	
	localparam BEQZ 	=	5'b01100;
	localparam BNEZ 	=	5'b01101;
	localparam BLTZ 	=	5'b01110;
	localparam BGEZ 	=	5'b01111;
	localparam JR	 	=	5'b00101;
	localparam JALR 	=	5'b00111;
	
	wire [1:0] num;
    reg reg1, reg2, isJump;
    
	// instantiate module to get number of registers read
    regRead iregRead(.instr(instr),	.num(num));

    always@(*) begin
        case(num)
			2'b00: begin
					reg1 = 0;
					reg2 = 0;
			end
			
			2'b01: begin
					reg1 = 1;
					reg2 = 0;
			end
			
			2'b10: begin	
					reg1 = 1;
					reg2 = 1;			
			end
			
			default: begin
					reg1 = 0;
					reg2 = 0;
			end
			
        endcase
    end
	
	always@(*) begin
        case(instr[15:11])
            BEQZ: begin
				isJump = 1;
			end
            BNEZ: begin
				isJump = 1;  
			end
            BLTZ: begin
				isJump = 1;  
			end
            BGEZ: begin
				isJump = 1;  
			end
            JR: begin
				isJump = 1;  
			end
            JALR: begin
				isJump = 1; 
			end
            default: begin
				isJump = 0;
			end
			
        endcase
    end
	
	assign r1_hazard = reg1;
	assign r2_hazard = reg2;
	
	// stall logic
   // assign stall = (
//	(reg1 & (readRegSel1 == writeRegSel_DX) & isRegWrite_DX & memRead_DX)	| 
//	(reg1 & (readRegSel1 == writeRegSel_EM) & isRegWrite_EM & isJump)	|
//	(reg2 & (readRegSel2 == writeRegSel_DX) & isRegWrite_DX & memRead_DX)	| 
//	(reg2 & (readRegSel2 == writeRegSel_EM) & isRegWrite_EM & isJump)
//	);
	  assign stall = (
	  (reg1 & (readRegSel1 == writeRegSel_DX) & (isRegWrite_DX) & memRead_DX) |
	  (reg2 & (readRegSel2 == writeRegSel_DX) & (isRegWrite_DX) & memRead_DX) |
	  (reg1 & (readRegSel1 == 3'h7 & isJAL_DX) & (isRegWrite_DX) & ~memRead_DX) |
	  (reg2 & (readRegSel2 == 3'h7 & isJAL_DX) & (isRegWrite_DX) & ~memRead_DX) |
	  (reg1 & (readRegSel1 == writeRegSel_EM) & (isRegWrite_EM) & isJump) |
	  (reg2 & (readRegSel2 == writeRegSel_EM) & (isRegWrite_EM) & isJump)
      );
endmodule