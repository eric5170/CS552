
module twoWay_FSM(
         //inputs 
			  input wire clk,
              input wire rst,
			  input wire [15:0] data1,
			  input wire [15:0] data2,
			  input wire [15:0] address,
			  input wire [15:0] data_mem,
			  input wire [15:0] data_sys,
			  input wire [4:0] tag1,
			  input wire [4:0] tag2,
			  input wire dirty1,
			  input wire dirty2,
              input wire valid1,
			  input wire valid2,
			  input wire hit1,
			  input wire hit2,
              input wire ld,
			  input wire st,
              input wire memStall,
			  //outputs
              output reg en1,
			  output reg en2,
			  output reg cmp,
              output reg write,
              output reg valid_in,
			  output reg done,
			  output reg wr,
			  output reg rd,
			  output reg [15:0] mem_addr,
			  output reg [15:0] mem_data,
			  output reg [15:0] cache_in,		 
              output reg [4:0] tag_in,
              output reg [2:0] offset_in,      
              output reg [15:0] data_out,
			  output reg [7:0] index_in,

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

    wire [15:0] state;
    reg [15:0] nxt_state;
    reg ld_reg, st_reg;
    reg [15:0] address_reg, data_sys_reg;
    reg repl_en1_reg, repl_en2_reg, repl_hit_reg, repl_dirty_reg;
    reg [15:0] repl_data_out_reg;
    reg [4:0] repl_tag_in_reg;


    wire [4:0] tag;
    wire [7:0] index;
    wire [2:0] offset;

    wire [15:0] repl_data_out;
    wire [4:0] repl_tag_in;
    wire repl_hit, repl_dirty, repl_en1, repl_en2, ld_or_st;
    reg victimway;

    assign tag = address_reg[15:11];
    assign index = address_reg[10:3];
    assign offset = address_reg[2:0];
    assign ld_or_st = ld | st;

    // Check if we have a ld or store, if neither, stay in IDLE (FIXED)
    // Output stall signal from FSM - every state but IDLE (FIXED)
    // distinguish between memStall (in) and cacheFSM_stall (out) (FIXED)
    // Done sig = data out ready
    // We want to wait 2 CYCLES after mem reads - have to add 2 more states (prob)
    //         Alloc0 -> Alloc1 -> Alloc2(Alloc0 available).. (one cycle per alloc)
    // Make state a flip flop instead of always (no posedge or negedge) (FIXED)

    /** CACHE FSM **/
    always @(*) begin
        victimway = 0;
        case(state)
            IDLE: begin // Check if it's neither ld or st - stay in IDLE
                        nxt_state = ld ? CMP_RD : (st ? CMP_WR : IDLE);
                        done = 1'h0;
                        stall = 1'h0;
                        en1 = 0;
                        en2 = 0;
                        write = 0;
                        cmp = 0;
                        cache_hit = 0;
                        ld_reg = ld;
                        st_reg = st;
                        repl_en1_reg = 0;
                        repl_en2_reg = 0;
                        repl_hit_reg = 0;
                        victimway = 0;
                        data_sys_reg = data_sys;
                        address_reg = address;
                    end
            CMP_RD: begin
                        nxt_state = repl_hit ? IDLE : ((~repl_hit & repl_dirty) ? EVICT0 : 
                                            ((~repl_hit | ~repl_dirty) ? ALLOC0 : CMP_RD));
                        // Cache Inputs
                        cmp = 1;
                        write = 0;
                        en1 = 1;
                        en2 = 1;
                        tag_in = tag;
                        offset_in = offset;
                        index_in = index;
                        valid_in = 1;
                        cache_in = data_sys_reg;
                        // Assign registers for the current operation
                        repl_en1_reg = repl_en1;
                        repl_en2_reg = repl_en2;
                        repl_hit_reg = repl_hit;
                        repl_dirty_reg = repl_dirty;
                        repl_data_out_reg = repl_data_out;
                        repl_tag_in_reg = repl_tag_in;
                        victimway = ld_or_st;
                        // Mem sys outputs
                        stall = 1;
                        done = repl_hit ? 1'h1 : 1'h0;
                        data_out = repl_hit ? repl_data_out : data_out;
                        cache_hit = repl_hit;
                    end
            CMP_WR: begin
                        nxt_state = (repl_hit ? IDLE : ((~repl_hit & repl_dirty) ? EVICT0 : 
                                            ((~repl_hit | ~repl_dirty)) ? ALLOC0 : CMP_WR));
                        // Cache Inputs
                        cmp = 1;
                        write = 1;
                        en1 = 1;
                        en2 = 1;
                        tag_in = tag;
                        offset_in = offset;
                        index_in = index;
                        valid_in = 1;
                        cache_in = data_sys_reg;
                        // Assign registers for the current operation
                        repl_en1_reg = repl_en1;
                        repl_en2_reg = repl_en2;
                        repl_hit_reg = repl_hit;
                        repl_dirty_reg = repl_dirty;
                        repl_data_out_reg = repl_data_out;
                        repl_tag_in_reg = repl_tag_in;
                        victimway = ld_or_st;
                        // Mem sys outputs
                        stall = 1;
                        done = repl_hit ? 1'h1 : 1'h0;
                        data_out = repl_hit ? repl_data_out : data_out;
                        cache_hit = repl_hit;
                    end
            EVICT0: begin
                        nxt_state = EVICT1;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, 3'h0};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                        // Caches
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        write = 0;
                        cmp = 1;
                        tag_in = repl_tag_in_reg;
                        index_in = index;
                        offset_in = 3'h0;
                        valid_in = 1;
                    end
            EVICT1: begin
                        nxt_state = EVICT2;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, 3'h2};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                        // Caches
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        write = 0;
                        cmp = 1;
                        tag_in = repl_tag_in_reg;
                        offset_in = 3'h2;
                        index_in = index;
                        valid_in = 1;
                    end
            EVICT2: begin
                        nxt_state = EVICT3;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, 3'h4};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                        // Caches
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        write = 0;
                        cmp = 1;
                        tag_in = repl_tag_in_reg;
                        index_in = index;
                        offset_in = 3'h4;
                        valid_in = 1;
                    end        
            EVICT3: begin
                        nxt_state = ALLOC0;
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, 3'h6};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                        // Caches
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        write = 0;
                        cmp = 1;
                        tag_in = repl_tag_in_reg;
                        index_in = index;
                        offset_in = 3'h6;
                        valid_in = 1;
                    end
            ALLOC0: begin
                        nxt_state = ALLOC1;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h0);
                        rd = ld_reg | (st_reg & (offset != 3'h0));
                        mem_addr = {address_reg[15:3], 3'h0}; 
                        mem_data = data_sys_reg;
                        stall = 1;
                        // Disable caches
                        en1 = 0;
                        en2 = 0;
                        write = 0;
                        cmp = 0;
                    end
            ALLOC1: begin
                        nxt_state = ALLOC2;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h2);
                        rd = ld_reg | (st_reg & (offset != 3'h2));
                        mem_addr = {address_reg[15:3], 3'h2};
                        mem_data = data_sys_reg;
                        stall = 1;
                        // Disable caches
                        en1 = 0;
                        en2 = 0;
                        write = 0;
                        cmp = 0;
                    end
            ALLOC2: begin
                        nxt_state = ALLOC3;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h4);
                        rd = ld_reg | (st_reg & (offset != 3'h4));
                        mem_addr = {address_reg[15:3], 3'h4};
                        mem_data = data_sys_reg;
                        // Cache inputs
                        cmp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_in = ld_reg | (st_reg & (offset != 3'h0)) ? data_mem : data_sys_reg;
                        valid_in = 1;
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        offset_in = 3'h0;
                        index_in = index;
                        // mem_system outputs
                        stall = 1;
                        data_out = (offset == 3'h0) ? data_mem : data_out;
                        done = (offset == 3'h0) ? 1'h1 : 1'h0;
                    end
            ALLOC3: begin
                        nxt_state = AW0;
                        // Memory access settings
                        wr = st_reg & (offset == 3'h6);
                        rd = ld_reg | (st_reg & (offset != 3'h6));
                        mem_addr = {address_reg[15:3], 3'h6};
                        mem_data = data_sys_reg;
                        // Cache Inputs
                        cmp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_in = ld_reg | (st_reg & (offset != 3'h2)) ? data_mem : data_sys_reg;
                        valid_in = 1;
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        offset_in = 3'h2;
                        index_in = index;
                        // mem_system outputs
                        stall = 1;
                        data_out = (offset == 3'h2) ? data_mem : data_out;
                        done = (offset == 3'h2) ? 1'h1 : 1'h0;
                    end
            AW0: begin // Done with memory accesses - waiting for outputs
                        nxt_state = AW1;
                        wr = 0;
                        rd = 0;
                        // Cache Inputs
                        cmp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_in = ld_reg | (st_reg & (offset != 3'h4)) ? data_mem : data_sys_reg;
                        valid_in = 1;
                        en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        offset_in = 3'h4;
                        index_in = index;
                        // Mem system outputs
                        stall = 1;
                        data_out = (offset == 3'h4) ? data_mem : data_out;
                        done = (offset == 3'h4) ? 1'h1 : 1'h0;
                    end
            default: begin //AW_3
                        nxt_state = IDLE;
                        wr = 0;
                        rd = 0;
                        cmp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_in = ld_reg | (st_reg & (offset != 3'h6)) ? data_mem : data_sys_reg;
                        valid_in = 1;
                        en1 = st_reg ? repl_en1_reg : repl_en1_reg;
                        en2 = st_reg ? repl_en2_reg : repl_en2_reg;
                        offset_in = 3'h6;
                        index_in = index;
                        // Mem system outputs
                        stall = 1;
                        data_out = (offset == 3'h6) ? data_mem : data_out;
                        done = (offset == 3'h6) ? 1'h1 : 1'h0;
                    end
        endcase
    end

// Next state flip-flop
register STATE(.data_in(nxt_state), .state(state), .clk(clk), .rst(rst));

/** REPLACEMENT LOGIC UNIT **/

   ps_random_logic REPLACE_UNIT(
                     // Inputs
                     .clk(clk),
                     .rst(rst),
                     .flip(victimway),
                     .hit1(hit1),
                     .hit2(hit2),
                     .valid1(valid1),
                     .valid2(valid2),
                     .dirty1(dirty1),
                     .dirty2(dirty2),
                     .tag1(tag1),
                     .tag2(tag2),
                     .data1(data1),
                     .data2(data2),
                     // Outputs
                     .repl_tag(repl_tag_in),
                     .hit(repl_hit),
                     .dirty(repl_dirty),
                     .repl_en1(repl_en1),
                     .repl_en2(repl_en2),
                     .repl_data_out(repl_data_out)
                    );

endmodule