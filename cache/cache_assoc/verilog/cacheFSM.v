module cacheFSM(
				//	Inputs
				input wire clk, 
				input wire rst,
				input wire ld, 
				input wire st, 
				input wire hit1, 
				input wire hit2, 
				input wire dirty1, 
				input wire dirty2, 
				input wire valid1, 
				input wire valid2, 
				input wire mem_stall,
				input wire [15:0] address, 
				input wire [15:0] data_in1, 
				input wire [15:0] data_in2, 
				input wire [15:0] data_in_mem, 
				input wire [15:0] data_in_sys,
				input wire [4:0] tag_out1, 
				input wire [4:0] tag_out2,
				
				//	Outputs
				output reg enable1, 
				output reg enable2, 
				output reg comp, 
				output reg write, 
				output reg done, 
				output reg wr, 
				output reg rd, 
				output reg valid_in,
				output reg sys_stall, 
				output reg cache_hit,
				output reg [15:0] mem_addr, 
				output reg [15:0] mem_data, 
				output reg [15:0] cache_data_in, 
				output reg [15:0] data_out_sys,
				output reg [4:0] tag_in,
				output reg [2:0] offset_in
);

	//	Local parameters for the state names
	localparam IDLE				=	4'b0000; // 0
	localparam COMPARE_READ 	=	4'b0001; // 1
	localparam COMPARE_WRITE	=	4'b0010; // 2
	localparam EVICT_0			=	4'b0011; // 3
	localparam EVICT_1			=	4'b0100; // 4
	localparam EVICT_2			=	4'b0101; // 5
	localparam EVICT_3			=	4'b0110; // 6
	localparam ALLOC_0			=	4'b0111; // 7
	localparam ALLOC_1			=	4'b1000; // 8
	localparam ALLOC_2			=	4'b1001; // 9
	localparam ALLOC_3			=	4'b1010; // 10
	localparam AW_0				=	4'b1011; // 11
	localparam AW_1				=	4'b1100; // 12
	localparam AW_2				=	4'b1101; // 13
	localparam AW_3				=	4'b1110; // 14

    wire [15:0] state, replace_data_out;
	wire [7:0] index;
	wire [4:0] replace_tag_in;
    wire [2:0] offset;
	wire replace_hit, replace_dirty, replace_enable_1, replace_enable_2, ld_or_st;
	
    reg [15:0] next_state, address_reg, data_in_sys_reg, replace_data_out_reg;
    reg [4:0] replace_tag_in_reg, tag;
    reg ld_reg, st_reg, replace_enable_1_reg, replace_enable_2_reg, replace_hit_reg, replace_dirty_reg, flip_victimway;

    assign tag = address_reg[15:11];
    assign index = address_reg[10:3];
    assign offset = address_reg[2:0];
    assign ld_or_st = ld | st;

    // CACHE FSM
    always @(*) begin
        flip_victimway = 0;
        case(state)
            IDLE: begin
						next_state = ld_or_st ? (ld ? COMPARE_READ : COMPARE_WRITE) : IDLE;
                        done = 1'h0;
                        sys_stall = 1'h0;
                        enable1 = 0;
                        enable2 = 0;
                        write = 0;
                        comp = 0;
                        cache_hit = 0;
                        ld_reg = ld;
                        st_reg = st;
                        replace_enable_1_reg = 0;
                        replace_enable_2_reg = 0;
                        replace_hit_reg = 0;
                        flip_victimway = 0;
                    end
					
            COMPARE_READ: begin
						next_state = replace_hit ? IDLE : (replace_dirty ? EVICT_0 : ALLOC_0);
						
                        //	Cache Inputs
                        comp = 1;
                        write = 0;
                        enable1 = 1;
                        enable2 = 1;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_in_sys;
						
                        //	Assign registers
                        st_reg = st;
                        ld_reg = ld;
                        data_in_sys_reg = data_in_sys;
                        address_reg = address;
                        replace_enable_1_reg = replace_enable_1;
                        replace_enable_2_reg = replace_enable_2;
                        replace_hit_reg = replace_hit;
                        replace_dirty_reg = replace_dirty;
                        replace_data_out_reg = replace_data_out;
                        replace_tag_in_reg = replace_tag_in;
                        flip_victimway = ld_or_st;
						
                        //	Mem sys outputs
                        sys_stall = 1;
                        done = replace_hit;
                        data_out_sys = replace_hit ? replace_data_out : data_out_sys;
                        cache_hit = replace_hit;
                    end
					
            COMPARE_WRITE: begin
                        next_state = replace_hit ? IDLE : (replace_dirty ? EVICT_0 : ALLOC_0);
						
                        // Cache Inputs
                        comp = 1;
                        write = 1;
                        enable1 = 1;
                        enable2 = 1;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_data_in = data_in_sys;
						
                        // Assign registers
                        st_reg = st;
                        ld_reg = ld;
                        data_in_sys_reg = data_in_sys;
                        address_reg = address;
                        replace_enable_1_reg = replace_enable_1;
                        replace_enable_2_reg = replace_enable_2;
                        replace_hit_reg = replace_hit;
                        replace_dirty_reg = replace_dirty;
                        replace_data_out_reg = replace_data_out;
                        replace_tag_in_reg = replace_tag_in;
                        flip_victimway = ld_or_st;
						
                        // Mem sys outputs
                        sys_stall = 1;
                        done = replace_hit;
                        data_out_sys = replace_hit ? replace_data_out : data_out_sys;
                        cache_hit = replace_hit;
                    end
					
            EVICT_0: begin
                        next_state = EVICT_1;
						
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {replace_tag_in_reg, index, 3'h0};
                        mem_data = replace_enable_1_reg ? data_in1 : data_in2;
                        sys_stall = 1;
						
                        // Caches
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        write = 0;
                        comp = 1;
                        tag_in = replace_tag_in_reg;
                        offset_in = 3'h0;
                        valid_in = 1;
                    end
					
            EVICT_1: begin
                        next_state = EVICT_2;
						
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {replace_tag_in_reg, index, 3'h2};
                        mem_data = replace_enable_1_reg ? data_in1 : data_in2;
                        sys_stall = 1;
						
                        // Caches
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        write = 0;
                        comp = 1;
                        tag_in = replace_tag_in_reg;
                        offset_in = 3'h2;
                        valid_in = 1;
                    end
					
            EVICT_2: begin
                        next_state = EVICT_3;
						
                        // Memory access settings
                        wr = 1;
                        rd = 0;
                        mem_addr = {replace_tag_in_reg, index, 3'h4};
                        mem_data = replace_enable_1_reg ? data_in1 : data_in2;
                        sys_stall = 1;
						
                        // Caches
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        write = 0;
                        comp = 1;
                        tag_in = replace_tag_in_reg;
                        offset_in = 3'h4;
                        valid_in = 1;
                    end     
					
            EVICT_3: begin
                        next_state = ALLOC_0;
                        // Memory access settings
						
                        wr = 1;
                        rd = 0;
                        mem_addr = {replace_tag_in_reg, index, 3'h6};
                        mem_data = replace_enable_1_reg ? data_in1 : data_in2;
                        sys_stall = 1;
						
                        // Caches
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        write = 0;
                        comp = 1;
                        tag_in = replace_tag_in_reg;
                        offset_in = 3'h6;
                        valid_in = 1;
                    end
					
            ALLOC_0: begin
                        next_state = ALLOC_1;
						
                        // Memory access settings
                        wr = st_reg & (offset == 3'h0);
                        rd = ld_reg | (st_reg & (offset != 3'h0));
                        mem_addr = {address_reg[15:3], 3'h0}; 
                        mem_data = data_in_sys_reg;
                        sys_stall = 1;
						
                        // Disable caches
                        enable1 = 0;
                        enable2 = 0;
                        write = 0;
                        comp = 0;
                    end
					
            ALLOC_1: begin
                        next_state = ALLOC_2;
						
                        // Memory access settings
                        wr = st_reg & (offset == 3'h2);
                        rd = ld_reg | (st_reg & (offset != 3'h2));
                        mem_addr = {address_reg[15:3], 3'h2};
                        mem_data = data_in_sys_reg;
                        sys_stall = 1;
						
                        // Disable caches
                        enable1 = 0;
                        enable2 = 0;
                        write = 0;
                        comp = 0;
                    end
					
            ALLOC_2: begin
                        next_state = ALLOC_3;
						
                        // Memory access settings
                        wr = st_reg & (offset == 3'h4);
                        rd = ld_reg | (st_reg & (offset != 3'h4));
                        mem_addr = {address_reg[15:3], 3'h4};
                        mem_data = data_in_sys_reg;
						
                        // Cache inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = (ld_reg | (st_reg & (offset != 3'h0))) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        offset_in = 3'h0;
						
                        // mem_system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h0) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h0);
                    end
					
            ALLOC_3: begin
                        next_state = AW_2;
						
                        // Memory access settings
                        wr = st_reg & (offset == 3'h6);
                        rd = ld_reg | (st_reg & (offset != 3'h6));
                        mem_addr = {address_reg[15:3], 3'h6};
                        mem_data = data_in_sys_reg;
						
                        // Cache Inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = (ld_reg | (st_reg & (offset != 3'h2))) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        offset_in = 3'h2;
						
                        // mem_system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h2) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h2);
                    end
					
            AW_2: begin
                        next_state = AW_3;
                        wr = 0;
                        rd = 0;
						
                        // Cache Inputs
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = (ld_reg | (st_reg & (offset != 3'h4))) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable1 = replace_enable_1_reg;
                        enable2 = replace_enable_2_reg;
                        offset_in = 3'h4;
						
                        // Mem system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h4) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h4);
                    end
            default: begin
                        next_state = IDLE;
                        wr = 0;
                        rd = 0;
                        comp = 0;
                        write = 1;
                        tag_in = tag;
                        cache_data_in = (ld_reg | (st_reg & (offset != 3'h6))) ? data_in_mem : data_in_sys_reg;
                        valid_in = 1;
                        enable1 = st_reg ? replace_enable_1_reg : replace_enable_1_reg;
                        enable2 = st_reg ? replace_enable_2_reg : replace_enable_2_reg;
                        offset_in = 3'h6;
						
                        // Mem system outputs
                        sys_stall = 1;
                        data_out_sys = (offset == 3'h6) ? data_in_mem : data_out_sys;
                        done = (offset == 3'h6);
                    end
        endcase
    end

// Next state flip-flop
register STATE(.data_in(next_state), .state(state), .clk(clk), .rst(rst));

/** REPLACEMENT LOGIC UNIT **/

   replacement_logic REPLACE_UNIT(
                     // Inputs
                     .clk(clk),
                     .rst(rst),
                     .flip(flip_victimway),
                     .ld_or_st(ld_or_st),
                     .hit1(hit1),
                     .hit2(hit2),
                     .valid1(valid1),
                     .valid2(valid2),
                     .dirty1(dirty1),
                     .dirty2(dirty2),
                     .tag_out1(tag_out1),
                     .tag_out2(tag_out2),
                     .data_out1(data_in1),
                     .data_out2(data_in2),
                     // Outputs
                     .replace_tag(replace_tag_in),
                     .hit(replace_hit),
                     .dirty(replace_dirty),
                     .replace_enable1(replace_enable_1),
                     .replace_enable2(replace_enable_2),
                     .replace_data_out(replace_data_out)
                    );

endmodule
