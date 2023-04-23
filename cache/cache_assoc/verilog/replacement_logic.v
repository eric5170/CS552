module replacement_logic(
						//	Inputs
						input wire clk, 
						input wire rst, 
						input wire hit1, 
						input wire hit2, 
						input wire valid1, 
						input wire valid2, 
						input wire dirty1, 
						input wire dirty2, 
						input wire ld_or_st, 
						input wire flip,
						input wire [4:0] tag_out1, 
						input wire [4:0] tag_out2,
						input wire [15:0] data_out1, 
						input wire [15:0] data_out2,
						
						//	Outputs
						output reg hit, 
						output reg dirty, 
						output reg replace_enable1, 
						output reg replace_enable2,
						output reg [4:0] replace_tag,
						output reg [15:0] replace_data_out);
						
wire victimway, victim;
wire [4:0] victim_tag, hit_tag;
wire [15:0] hit_data_out, victim_data_out;

dffe VICTIMWAY(.en(flip), .q(victimway), .d(~victimway), .clk(clk), .rst(rst));

assign victim = (valid1 & valid2) ? ~victimway : valid1;

assign victim_tag = victim ? tag_out2 : tag_out1;   
assign victim_data_out = victim ? data_out2 : data_out1; 
assign hit_tag = (hit1 & valid1) ? tag_out1: tag_out2;
assign hit_data_out = (hit1 & valid1) ? data_out1 : data_out2;

assign replace_enable1 = ~victim; 
assign replace_enable2 = victim; 
assign hit = (hit1 & valid1) | (hit2 & valid2);                     
assign dirty = victim ? dirty2 : dirty1;                          
assign replace_data_out = hit ? hit_data_out : victim_data_out;    
assign replace_tag = hit ? hit_tag : victim_tag;                    


endmodule
