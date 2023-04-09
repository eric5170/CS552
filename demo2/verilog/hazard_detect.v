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
    input wire [2:0] writeRegSel_ID_EX, writeRegSel_EX_MEM, readRegSel1, readRegSel2;
    input wire isRegWrite_ID_EX, isRegWrite_EX_MEM;
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

    assign stall = (( r1 & (readRegSel1 == writeRegSel_ID_EX) & (isRegWrite_ID_EX)) 
	| (r1 & (readRegSel1 == writeRegSel_EX_MEM) & (isRegWrite_EX_MEM))
	| (r2 & (readRegSel2 == writeRegSel_ID_EX) & (isRegWrite_ID_EX))
	| (r2 & (readRegSel2 == writeRegSel_EX_MEM) & (isRegWrite_EX_MEM))) ? 1 : 0;
	
endmodule
