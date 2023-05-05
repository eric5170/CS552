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

// Assign explained:
// Are both cache blocks valid - we choose the (already flipped) output of ff
// Otherwise, if way0 (valid1) is valid - target way1
// Otherwise, target way0
assign target = (valid1 & valid2) ? ~victimway: valid1 ? 1'h1 : 1'h0;

// Intermediate signals for replacement logic
assign target_tag = target ? tag2 : tag1;                   // If replacing - which tag is replaced
assign target_data = target ? data2 : data1;            // if replacing - what data is in replaced block
assign hit_tag = (hit1 & valid1) ? tag1: tag2;                         // if HIT - hit tag
assign hit_data = (hit1 & valid1) ? data1 : data2;                 // if HIT - which data is read

assign repl_en1 = target ? 1'h0 : 1'h1;                      // if the target is way1, way0_en is low
assign repl_en2 = target ? 1'h1 : 1'h0;                      // if the target is way1, way1_en is high
assign hit = (hit1 & valid1) | (hit2 & valid2);                     // Is there a HIT
assign dirty = target ? dirty2 : dirty1;                            // Set dirty bit based on the target block
assign repl_data_out = hit ? hit_data : target_data;     // data_out corresponds to the hit block OR the target block
assign repl_tag = hit ? hit_tag : target_tag;                    // tag corresponds to the hit block OR the target block

	
endmodule