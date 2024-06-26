/*
   CS/ECE 552 Spring '23
  
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
    output stall;
	
	wire [1:0] num;
    reg r1, r2;
    
    regRead iregRead(.instr(instr),
			.num(num));

    always@(*) begin
        case(num)
                2'b00: begin
                        r1 = 0;
                        r2 = 0;
                    end
                2'b01: begin
                        r1 = 1;
                        r2 = 0;
                    end
                2'b10: begin	
                        r1 = 1;
                        r2 = 1;			
                    end
                default: begin
                        r1 = 0;
                        r2 = 0;
                    end
        endcase
    end

    assign stall = (( r1 & (readRegSel1 == writeRegSel_DX) & (isRegWrite_DX)) 
	| (r1 & (readRegSel1 == writeRegSel_EM) & (isRegWrite_EM))
	| (r2 & (readRegSel2 == writeRegSel_DX) & (isRegWrite_DX))
	| (r2 & (readRegSel2 == writeRegSel_EM) & (isRegWrite_EM)));
	
endmodule
