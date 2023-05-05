/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err, 
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
	input [15:0] Addr;
	input [15:0] DataIn;
	input        Rd;
	input        Wr;
	input        createdump;
	input        clk;
	input        rst;

	output reg [15:0] DataOut;
	output reg        Done;
	output reg        Stall;
	output reg        CacheHit;
	output reg        err;

	// extra signals required for the connection between modules
	wire [15:0] data, dFm, dTm, data1, data2, mem_addr;
	wire [7:0] index;
	wire [4:0] tag1, tag2, tag_in;
	wire [3:0] busy;
	
	wire hit, hit1, hit2, en1, en2, dirty1, dirty2, memStall, mem_rd, mem_wr, memErr, cacheErr1, 
	cacheErr2, valid1, valid2, valid_in, cmp; 

	assign index = Addr[10:3];

	// ouptut register intermediate values
	wire [15:0] DataOut_i;
	wire Done_i, Stall_i, CacheHit_i, err_i;

	wire ld, ld_or_st;
    wire [4:0] tag;
    wire [7:0] index_in;
    wire [2:0] offset, offset_in;
    wire mem_stall;

	assign tag = Addr[15:11];
	assign offset = Addr[2:0];
	assign err_i = memErr | cacheErr1 | cacheErr2;


	/* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
	parameter memtype = 0;

	cache #(0 + memtype) c0(// Outputs
                     .tag_out              (tag1),
                     .data_out             (data1),
                     .hit                  (hit1),
                     .dirty                (dirty1),
                     .valid                (valid1),
                     .err                  (cacheErr1),
                     // Inputs
                     .enable               (en1),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index_in),
                     .offset               (offset_in),
                     .data_in              (data),
                     .comp                 (cmp),
                     .write                (write),
                     .valid_in             (valid_in));

	cache #(2 + memtype) c1(// Outputs
                     .tag_out              (tag2),
                     .data_out             (data2),
                     .hit                  (hit2),
                     .dirty                (dirty2),
                     .valid                (valid2),
                     .err                  (cacheErr2),
                     // Inputs
                     .enable               (en2),
                     .clk                  (clk),
                     .rst                  (rst),
                     .createdump           (createdump),
                     .tag_in               (tag_in),
                     .index                (index_in),
                     .offset               (offset_in),
                     .data_in              (data),
                     .comp                 (cmp),
                     .write                (write),
                     .valid_in             (valid_in));

	four_bank_mem mem(// Outputs
                     .data_out          (dFm),
                     .stall             (memStall),
                     .busy              (busy),
                     .err               (memErr),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (dTm),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
	//FSM 
	twoWay_FSM iFSM(     
			  //inputs 
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
			  //outputs
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
			  .index_in(index_in),
			  .stall(Stall_i),
              .cache_hit(CacheHit_i)
					);
		// assigning the outputs 
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
