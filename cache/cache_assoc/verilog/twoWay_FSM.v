module twoWay_FSM(     
			  //	Inputs 
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
			  //	Outputs
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
			
			  output reg stall,
             		  output reg cache_hit);
	
	//	Local parameters for the state names
	localparam IDLE		=	4'b0000;	// 0
	localparam CMP_RD	=	4'b0001;	// 1
	localparam CMP_WR 	=	4'b0010;	// 2
	localparam ALLOC0 	=	4'b0011;	// 3
	localparam ALLOC1 	=	4'b0100;	// 4
	localparam ALLOC2 	=	4'b0101;	// 5
	localparam ALLOC3 	=	4'b0110;	// 6
	localparam EVICT0 	=	4'b0111;	// 7
	localparam EVICT1 	=	4'b1000;	// 8
	localparam EVICT2 	=	4'b1001;	// 9
	localparam EVICT3 	=	4'b1010;	// 10
	localparam AW0 		=	4'b1011;	// 11
	localparam AW1 		=	4'b1100;	// 12
	
	//	State for FSM
	wire [15:0] state;
	
	//	Signals to be changed in different states
      	reg [15:0] nxt_state, address_reg, data_sys_reg, repl_data_out_reg;
    	reg [4:0] repl_tag_in_reg;
	reg ld_reg, st_reg, repl_en1_reg, repl_en2_reg, repl_hit_reg, repl_dirty_reg, victimway;

	wire [15:0] repl_data_out;
	wire [4:0] repl_tag_in;
	wire repl_hit, repl_dirty, repl_en1, repl_en2;

    	wire [4:0] tag;
    	wire [7:0] index;
    	wire [2:0] offset;
	
	
	// Address to the matching parts
	assign tag =  address_reg[15:11];
	assign index = address_reg[10:3];
	assign offset = address_reg[2:0];
	
    	assign ld_or_st = ld | st;
	
		
	/** CACHE FSM **/
    always @(*) begin
        victimway = 0;
        case(state)
            IDLE: begin 
						nxt_state = ld_or_st ? (ld ? CMP_RD : CMP_WR) : IDLE;
						
						cmp = 0;
						write = 0;
						en1 = 0;
						en2 = 0;
						done = 1'h0;
						cache_hit = 0;
						ld_reg = ld;
						st_reg = st;
						repl_en1_reg = 0;
						repl_en2_reg = 0;
						repl_hit_reg = 0;
						victimway = 0;
						stall = 1'h0;
                    end
					
            CMP_RD: begin
                        nxt_state = repl_hit ? IDLE : (repl_dirty ? EVICT0 : ALLOC0);
						
                        cmp = 1;
                        write = 0;
                        en1 = 1;
                        en2 = 1;
			repl_hit_reg = repl_hit;
			done = repl_hit_reg;
			cache_hit = repl_hit_reg;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_in = data_sys;
			data_sys_reg = data_sys;
                        address_reg = address;
                        st_reg = st;
                        ld_reg = ld;
                        repl_dirty_reg = repl_dirty;
                        repl_data_out_reg = repl_data_out;
                        repl_tag_in_reg = repl_tag_in;
                        repl_en1_reg = repl_en1;
                        repl_en2_reg = repl_en2;
			data_out = repl_hit ? repl_data_out : data_out;
                        victimway = ld_or_st;
                        stall = 1;
		end
					
            CMP_WR: begin
                        nxt_state = repl_hit ? IDLE : (repl_dirty ? EVICT0 : ALLOC0);
						
                        cmp = 1;
                        write = 1;
                        en1 = 1;
                        en2 = 1;
			repl_hit_reg = repl_hit;
			done = repl_hit_reg;
			cache_hit = repl_hit_reg;
                        tag_in = tag;
                        offset_in = offset;
                        valid_in = 1;
                        cache_in = data_sys;
			data_sys_reg = data_sys;
                        address_reg = address;
                        st_reg = st;
                        ld_reg = ld;
			repl_dirty_reg = repl_dirty;
                        repl_data_out_reg = repl_data_out;
                        repl_tag_in_reg = repl_tag_in;
                        repl_en1_reg = repl_en1;
                        repl_en2_reg = repl_en2;
			data_out = repl_hit ? repl_data_out : data_out;
                        victimway = ld_or_st;
                        stall = 1;                    
                    end
					
            EVICT0: begin
                        nxt_state = EVICT1;
                        cmp = 1;
			write = 0;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			tag_in = repl_tag_in_reg;
			offset_in = 3'h0;
			valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, offset_in};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
		end
					
            EVICT1: begin
                        nxt_state = EVICT2;
                        cmp = 1;
			write = 0;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			tag_in = repl_tag_in_reg;
			offset_in = 3'h2;
			valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, offset_in};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                    end
					
            EVICT2: begin
                        nxt_state = EVICT3;
			cmp = 1;
			write = 0;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			tag_in = repl_tag_in_reg;
                        offset_in = 3'h4;
			valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, offset_in};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1;
                    end  
					
            EVICT3: begin
                        nxt_state = ALLOC0;
                        cmp = 1;
			write = 0;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			tag_in = repl_tag_in_reg;
                        offset_in = 3'h6;
                        valid_in = 1;
                        wr = 1;
                        rd = 0;
                        mem_addr = {repl_tag_in_reg, index, offset_in};
                        mem_data = repl_en1_reg ? data1 : data2;
                        stall = 1; 
                    end
					
            ALLOC0: begin
                        nxt_state = ALLOC1;
			cmp = 0;
                        write = 0;
			en1 = 0;
                        en2 = 0;
                        wr = st_reg & (offset == 3'h0);
                        rd = ld_reg | (st_reg & (offset != 3'h0));
                        mem_addr = {address_reg[15:3], 3'h0}; 
                        mem_data = data_sys_reg;
                        stall = 1;
                    end
					
            ALLOC1: begin
                        nxt_state = ALLOC2;
			cmp = 0;
			write = 0;
			en1 = 0;
                        en2 = 0;
                        wr = st_reg & (offset == 3'h2);
                        rd = ld_reg | (st_reg & (offset != 3'h2));
                        mem_addr = {address_reg[15:3], 3'h2};
                        mem_data = data_sys_reg;
                        stall = 1;
                    end
					
            ALLOC2: begin
                        nxt_state = ALLOC3;
                        cmp = 0;
                        write = 1;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			offset_in = 3'h0;
			valid_in = 1;
			done = (offset == 3'h0);
			tag_in = tag;
			cache_in = (ld_reg | (st_reg & (offset != offset_in))) ? data_mem : data_sys_reg;
                        wr = st_reg & (offset == 3'h4);
                        rd = ld_reg | (st_reg & (offset != 3'h4));
                        mem_addr = {address_reg[15:3], 3'h4};
                        mem_data = data_sys_reg;
                        data_out = (offset == offset_in) ? data_mem : data_out;
                        stall = 1;
                    end
					
            ALLOC3: begin
                        nxt_state = AW0;
                        cmp = 0;
                        write = 1;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
			offset_in = 3'h2;
			valid_in = 1;
			done = (offset == 3'h2);
			tag_in = tag;
			cache_in = (ld_reg | (st_reg & (offset != offset_in))) ? data_mem : data_sys_reg;
                        wr = st_reg & (offset == 3'h6);
                        rd = ld_reg | (st_reg & (offset != 3'h6));
                        mem_addr = {address_reg[15:3], 3'h6};
                        mem_data = data_sys_reg;
                        data_out = (offset == offset_in) ? data_mem : data_out;
                        stall = 1;  
                    end
					
            AW0: begin
                        nxt_state = AW1;
			cmp = 0;
                        write = 1;
			en1 = repl_en1_reg;
                        en2 = repl_en2_reg;
                        offset_in = 3'h4;
			valid_in = 1;
			done = (offset == 3'h4);
			tag_in = tag;
			cache_in = (ld_reg | (st_reg & (offset != offset_in))) ? data_mem : data_sys_reg;
			wr = 0;
                        rd = 0;
			data_out = (offset == offset_in) ? data_mem : data_out;
			stall = 1;
                    end
					
            default: begin //AW_3
                        nxt_state = IDLE;
			cmp = 0;
                        write = 1;
			en1 = st_reg ? repl_en1_reg : repl_en1_reg;
                        en2 = st_reg ? repl_en2_reg : repl_en2_reg;
			offset_in = 3'h6;
			valid_in = 1;
			done = (offset == offset_in);
			tag_in = tag;
                        cache_in = (ld_reg | (st_reg & (offset != offset_in))) ? data_mem : data_sys_reg;
                        wr = 0;
                        rd = 0;
                        data_out = (offset == offset_in) ? data_mem : data_out;
                        stall = 1;                 
                    end
        endcase
    end
	
	register iState(.data_in(nxt_state), .state(state), .clk(clk), .rst(rst));

	ps_random_logic iUnit(
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
							 .repl_data_out(repl_data_out));


endmodule
