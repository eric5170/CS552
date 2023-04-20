module FSM (
              input wire clk,
              input wire rst,
			  input wire [15:0] data_in,
			  input wire [15:0] address,
			  input wire [15:0] data_mem,
			  input wire [15:0] data_sys,
			  input wire [4:0] tag_out,
			  input wire dirty,
              input wire valid,
			  input wire hit,
              input wire ld,
			  input wire st,
              input wire memStall,
              output reg en,
			  output reg cmp,
              output reg write,
              output reg valid_in,
			  output reg done,
			  output reg wr,
			  output reg rd,
			  output reg [15:0] mem_addr,
			  output reg [15:0] mem_data_out,
			  output reg [15:0] cache_data_in,		 
              output reg [4:0] tag_in,
              output reg [2:0] offset_in,      
              output reg [15:0] data_out_sys,
			  output reg stall,
              output reg cache_hit
              );

	localparam IDLE = 0;
	localparam CMP_RD = 1;
	localparam CMP_WR = 2;
	localparam ALLOC0 = 3;
	localparam ALLOC1 = 4;
	localparam ALLOC2 = 5;
	localparam ALLOC3 = 6;
	localparam EVICT0 = 7;
	localparam EVICT1 = 8;
	localparam EVICT2 = 9;
	localparam EVICT3 = 10;
	localparam AW0 = 11;
	localparam AW1 = 12;

	// state for FSM
	wire [15:0] state;
	
	//signals to be changed in different states
    reg [15:0] nxt_state, address_reg, data_sys_reg, data_out_reg;
    reg [4:0] tag_in_reg;
	reg ld_reg, st_reg, hit_reg, dirty_reg;

	// wires to assign
    wire [4:0] tag;
    wire [7:0] index;
    wire [2:0] offset;
	
	// seperate address to the matching parts
	assign tag =  address_reg[15:11];
	assign index = address_reg[10:3];
	assign offset = address_reg[2:0];
		
	// main case statement for cacheFSM
	always @(*) begin
		case(state)
			IDLE :  begin
						nxt_state = ld ? CMP_RD : (st ? CMP_WR : IDLE);
						cmp = 0;
						write = 0;
						en = 0;
                        done = 1'h0;         
                        cache_hit = 0;
                        ld_reg = ld;
                        st_reg = st;
                        hit_reg = 0;
						stall = 1'h0;
					end
			
			CMP_RD : begin	
						 nxt_state = (hit & valid) ? IDLE : ((~hit & dirty) ? EVICT0 : 
                                            (((hit & ~valid) | (~dirty)) ? ALLOC0 : CMP_RD));
                        // Cache Inputs
                        cmp = 1;
                        write = 0;
                        en = 1;
						hit_reg = hit & valid;
						done = hit_reg ? 1 : 0;
						cache_hit = hit_reg;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_sys;
                        // Assign registers for the current operation
                        data_sys_reg = data_sys;
                        address_reg = address;
                        dirty_reg = dirty;
                        data_out_reg = data_in;
                        tag_in_reg = tag_out;
                        data_out_sys = hit_reg ? data_out_reg : data_out_sys;
                        stall = 1;
					end
					
			CMP_WR: begin	
						nxt_state = (hit & valid) ? IDLE : ((~hit & dirty) ? EVICT0 : 
                                            (((hit & ~valid) | (~dirty)) ? ALLOC0 : CMP_WR));
                        cmp = 1;
                        write = 1;
                        en = 1;
						hit_reg = (hit & valid);
						done = hit_reg ? 1 : 0;
						cache_hit = hit_reg;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_sys;
                        data_sys_reg = data_sys;
                        address_reg = address;
                        dirty_reg = dirty;
                        data_out_reg = data_in;
                        tag_in_reg = tag_out;
						data_out_sys = hit_reg ? data_in : data_out_sys;
                        stall = 1;                      
			end
			
			EVICT0: begin
						nxt_state = EVICT1;
                        cmp = 1;
						write = 0;
						en = 1;
						tag_in = tag_in_reg;
						offset_in = 3'h0;
						valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in, index, offset_in};
                        mem_data_out = data_in;
                        stall = 1;                        
			end
			
			EVICT1: begin	
						nxt_state = EVICT2;
                        cmp = 1;
						write = 0;
						en = 1;
						tag_in = tag_in_reg;
						offset_in = 3'h2;
						valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in, index, offset_in};
                        mem_data_out = data_in;
                        stall = 1;
			end
			
			EVICT2: begin	
						nxt_state = EVICT3;
                        cmp = 1;
						write = 0;
						en = 1;
						tag_in = tag_in_reg;
						offset_in = 3'h4;
						valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in, index, offset_in};
                        mem_data_out = data_in;
                        stall = 1;
			end
			
			EVICT3: begin	
						nxt_state = ALLOC0;
                        cmp = 1;
						write = 0;
						en = 1;
						tag_in = tag_in_reg;
						offset_in = 3'h6;
						valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {tag_in, index, offset_in};
                        mem_data_out = data_in;
                        stall = 1;
			end
			
			ALLOC0: begin		
						nxt_state = ALLOC1;
                        cmp = 0;
						write = 0;
						en = 0;
                        wr = st_reg & (offset == 3'h0);
                        rd = ld_reg | (st_reg & (offset != 3'h0));
                        mem_addr = {address_reg[15:3], 3'h0}; 
                        mem_data_out = data_sys_reg;
                        stall = 1;            
			end
			
			ALLOC1: begin	
						nxt_state = ALLOC2;
                        cmp = 0;
						write = 0;
						en = 0;
                        wr = st_reg & (offset == 3'h2);
                        rd = ld_reg | (st_reg & (offset != 3'h2));
                        mem_addr = {address_reg[15:3], 3'h2};
                        mem_data_out = data_sys_reg;
                        stall = 1;  
			end
			
			ALLOC2: begin
						nxt_state = ALLOC3;
						cmp = 0;
						write = 1;
						en = 1;
						offset_in = 3'h0;
						valid_in = 1;
						done = (offset == offset_in) ? 1: 0;
						tag_in = tag;	
						cache_data_in = ld_reg | (st_reg & (offset != offset_in)) ? data_mem : data_sys_reg;						
                        wr = st_reg & (offset == 3'h4);
                        rd = ld_reg | (st_reg & (offset != 3'h4));
                        mem_addr = {address_reg[15:3], 3'h4};
                        mem_data_out = data_sys_reg;
                        data_out_sys = (offset == offset_in) ? data_mem : data_out_sys;
                        stall = 1;
			end
				
			ALLOC3: begin
						nxt_state = AW0;
                        cmp = 0;
						write = 1;
						en = 1;
						offset_in = 3'h2;
						valid_in = 1;
						done = (offset == offset_in) ? 1: 0;
						tag_in = tag;
						cache_data_in = ld_reg | (st_reg & (offset != offset_in)) ? data_mem : data_sys_reg;
                        wr = st_reg & (offset == 3'h6);
                        rd = ld_reg | (st_reg & (offset != 3'h6));
                        mem_addr = {address_reg[15:3], 3'h6};
                        mem_data_out = data_sys_reg;
						data_out_sys = (offset == offset_in) ? data_mem : data_out_sys;
						stall = 1;
			end
			
			AW0: begin
						nxt_state = AW1;
						cmp = 0;
                        write = 1;
						en = 1;
						offset_in = 3'h4;
						valid_in = 1;
						done = (offset == offset_in) ? 1 : 0;
						tag_in = tag;
						cache_data_in = ld_reg | (st_reg & (offset != offset_in)) ? data_mem : data_sys_reg;
                        wr = 0;
                        rd = 0;
						data_out_sys = (offset == offset_in) ? data_mem : data_out_sys;
                        stall = 1;                        
			end
			
			default: begin
                        nxt_state = IDLE;
						cmp = 0;
						write = 1;
						en = 1;
						offset_in = 3'h6;
						valid_in = 1;
						done = (offset == offset_in) ? 1'h1 : 1'h0;
						tag_in = tag;
						cache_data_in = ld_reg | (st_reg & (offset != offset_in)) ? data_mem : data_sys_reg;        
                        wr = 0;
                        rd = 0;
                        data_out_sys = (offset == offset_in) ? data_mem : data_out_sys;
                        stall = 1;
			end
			
		endcase
		
	end
	
	register iState(.data_in(nxt_state), .state(state), .clk(clk), .rst(rst));
	
	endmodule
