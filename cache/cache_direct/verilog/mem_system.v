/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );
   
    input wire [15:0] Addr;
    input wire [15:0] DataIn;
    input wire        Rd;
    input wire        Wr;
    input wire        createdump;
    input wire        clk;
    input wire        rst;
   
    output reg [15:0] DataOut;
    output reg        Done;
    output reg        Stall;
    output reg        CacheHit;
    output reg        err;
	
    // other custom signals needed
    wire [15:0] data_out, data_in, dFm, dTm, mem_addr;
    wire [4:0] tag, tag_in, tag_out;
    wire [7:0] index;
    wire [2:0] offset, offset_in;
    wire [3:0] busy;
    wire memStall, hit, en, mem_rd, mem_wr, valid, valid_in, dirty, memError, cacheError;
    wire cmp, write, ld;
	
    assign index = Addr[10:3];

	// register intermediate values
	wire [15:0] DataOut_i;
	wire Done_i, Stall_i, CacheHit_i, err_i;
	
    /* data_mem = 1, inst_mem = 0 *
     * needed for cache parameter */
    parameter memtype = 0;
    cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out),
                          .data_out             (data_out),
                          .hit                  (hit),
                          .dirty                (dirty),
                          .valid                (valid),
                          .err                  (cacheError),
                          // Inputs
                          .enable               (en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset_in),
                          .data_in              (data_in),
                          .comp                 (cmp),
                          .write                (write),
                          .valid_in             (valid_in));

    four_bank_mem mem(// Outputs
                     .data_out          (dFm),
                     .stall             (memStall),
                     .busy              (busy),
                     .err               (memError),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (dTm),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // your code here

    FSM iFSM(// Outputs
			.en				    (en),
			.cmp     			(cmp),
			.write				(write),
			.valid_in 			(valid_in),
			.done				(Done_i),
			.wr					(mem_wr),
			.rd					(mem_rd),
			.mem_addr			(mem_addr),
			.mem_data_out		(dTm),
			.cache_data_in		(data_in),
			.tag_in				(tag_in),
			.offset_in			(offset_in),
			.data_out_sys		(DataOut_i),
			.stall				(Stall_i),
			.cache_hit			(CacheHit_i),
			// Inputs
			.clk				(clk),
			.rst				(rst),
			.data_in			(data_out),
			.address			(Addr),
			.data_mem			(dFm),
			.data_sys			(DataIn),
			.tag_out 			(tag_out),
			.dirty				(dirty),
			.valid				(valid),
			.hit				(hit),
			.ld					(Rd),
			.st					(Wr),
			.memStall			(memStall));
				
	// error logic 
	assign err_i = cacheError | memError;
	
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
										
							
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9:
