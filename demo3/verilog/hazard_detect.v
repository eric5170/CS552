/*
   CS/ECE 552 Spring '23
   Authors: Yeon Jae Cho and Seth Thao 
   Group: 18
   Filename        : hazard_detect.v
   
   Description     : This is the module for hazard_detection logic depending on the number of register being read.
*/
module hazard_detect(		instr,
                            writeRegSel_DX, 
                            writeRegSel_EM,
                            readRegSel1, 
                            readRegSel2, 
                            isRegWrite_DX,
                            isRegWrite_EM,
                            stall
                            );

    input wire [15:0] instr;
    input wire [2:0] writeRegSel_DX, writeRegSel_EM, readRegSel1, readRegSel2;
    input wire isRegWrite_DX, isRegWrite_EM;
    output wirestall;
	
	wire [1:0] num;
    reg reg1, reg2;
    
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
	
	// stall logic
    assign stall = (( reg1 & (readRegSel1 == writeRegSel_DX) & (isRegWrite_DX)) 
	| (reg1 & (readRegSel1 == writeRegSel_EM) & (isRegWrite_EM))
	| (reg2 & (readRegSel2 == writeRegSel_DX) & (isRegWrite_DX))
	| (reg2 & (readRegSel2 == writeRegSel_EM) & (isRegWrite_EM)));
	
endmodule