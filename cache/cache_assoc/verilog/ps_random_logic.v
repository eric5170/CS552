module ps_random_logic(
							input wire clk,
							input wire rst,
							input wire hit1,
							input wire hit2,
							input wire valid1,
							input wire valid2,
							input wire dirty1,
							input wire dirty2,
							input wire flip,
							input wire [4:0] tag1,
							input wire [4:0] tag2,
							input wire [15:0] data1,
							input wire [15:0] data2,
							output wire hit,
							output wire dirty,
							output wire repl_en1,
							output wire repl_en2,
							output wire [4:0] repl_tag,
							output wire [15:0] repl_data_out);
															

	wire victimway, target;
	wire [4:0] target_tag, hit_tag;
	wire [15:0] hit_data , target_data;
	
	dff_en iDFF(.en(flip), .q(victimway), .d(~victimway), .clk(clk), .rst(rst));

	// both cache blocks valid --> output of flip flop
	// otherwise --> way0 = valid --> way1
	// else --> way0
	assign target = (valid1 & valid2) ? ~victimway: valid1 ? 1 : 0;

	// Intermediate signals for replacement logic
	assign target_tag = target ? tag2 : tag1;                   
	assign target_data = target ? data2 : data1;           
	assign hit_tag = (hit1 & valid1) ? tag1: tag2;                         
	assign hit_data = (hit1 & valid1) ? data1 : data2;                

	assign repl_en1 = target ? 0 : 1;                      
	assign repl_en2 = target ? 1 : 0;                     
	assign hit = (hit1 & valid1) | (hit2 & valid2);                    
	assign dirty = target ? dirty2 : dirty1;                           
	assign repl_data_out = hit ? hit_data : target_data;    
	assign repl_tag = hit ? hit_tag : target_tag;  
	
endmodule