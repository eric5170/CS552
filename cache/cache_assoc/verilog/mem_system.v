module mem_system(
					//	Inputs
					input wire [15:0] Addr;
					input wire [15:0] DataIn;
					input wire        Rd;
					input wire        Wr;
					input wire        createdump;
					input wire        clk;
					input wire        rst;

					//	Outputs
					output reg [15:0] DataOut;
					output reg        Done;
					output reg        Stall;
					output reg        CacheHit;
					output reg        err;
   );
   
	wire [15:0] data, dFm, dTm, data1, data2, mem_addr;
	wire [7:0] index;
	wire [4:0] tag1, tag2, tag_in;
	wire [3:0] busy;
	wire [2:0] offset_in;
	wire hit, hit1, hit2, en1, en2, dirty1, dirty2, memStall, mem_rd, mem_wr, memErr, cacheErr1, 
	cacheErr2, valid1, valid2, valid_in, cmp; 

	assign index = Addr[10:3];

	wire [15:0] DataOut_i;
	wire Done_i, Stall_i, CacheHit_i, err_i;

   parameter memtype = 0;

   cache #(0 + memtype) c0(
					// 	Outputs
                     .tag_out              (tag1),
                     .data_out             (data1),
                     .hit                  (hit1),
                     .dirty                (dirty1),
                     .valid                (valid1),
                     .err                  (cacheErr1),
                    // 	Inputs
                     .enable               (en1),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index),
                     .offset               (offset_in),
                     .data_in              (data),
                     .comp                 (cmp),
                     .write                (write),
                     .valid_in             (valid_in));

   cache #(2 + memtype) c1(
					// 	Outputs
                     .tag_out              (tag2),
                     .data_out             (data2),
                     .hit                  (hit2),
                     .dirty                (dirty2),
                     .valid                (valid2),
                     .err                  (cacheErr2),
                    // 	Inputs
                     .enable               (en2),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index),
                     .offset               (offset_in),
                     .data_in              (data),
                     .comp                 (cmp),
                     .write                (write),
                     .valid_in             (valid_in));

   four_bank_mem mem(
					// 	Outputs
                     .data_out          (dFm),
                     .stall             (memStall),
                     .busy              (busy),
                     .err               (memErr),
                    //	Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (dTm),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
	//FSM 
	twoWay_FSM iFSM(     
			  //	Inputs 
			  .clk(clk),
              .rst(rst),
			  .data1(data1),
			  .data2(data2),
			  .address(Addr),
			  .data_mem(dFm),
			  .data_sys(DataIn),
			  .tag1(tag1),
			  .tag2(tag2),
			  .dirty1(dirty1),
			  .dirty2(dirty2),
              .valid1(valid1),
			  .valid2(valid2),
			  .hit1(hit1),
			  .hit2(hit2),
              .ld(Rd),
			  .st(Wr),
              .memStall(memStall),
			  
			  //	Outputs
              .en1(en1),
			  .en2(en2),
			  .cmp(cmp),
              .write(write),
              .valid_in(valid_in),
			  .done(Done_i),
			  .wr(mem_wr),
			  .rd(mem_rd),
			  .mem_addr(mem_addr),
			  .mem_data(dTm),
			  .cache_in(data),		 
              .tag_in(tag_in),
              .offset_in(offset_in),      
              .data_out(DataOut_i),
			  .stall(Stall_i),
              .cache_hit(CacheHit_i));
			  
   	// Assigning Outputs 
	always @(*) begin
		case (1'bx)
			Done_i: Done = Done_i;
			Stall_i: Stall = Stall_i;
			err_i: err = err_i;
			CacheHit_i: CacheHit = CacheHit_i;
			DataOut_i: DataOut = DataOut_i;
			default: begin
				Done = Done_i;
				 Stall = Stall_i;
				 err = err_i;
				CacheHit = CacheHit_i;
				 DataOut = DataOut_i;
			end
		endcase
	end
	
endmodule
// DUMMY LINE FOR REV CONTROL :9:
