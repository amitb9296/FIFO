// Please Read README.md 

module FIFO #( parameter B = 8,	//	Number of bits in a word
						 W = 4	//	Number of address bits
			 )
			(
				input 			clk,    // Clock
				input 			rst_n,  // Asynchronous reset active low
				input 			rd,wr,
				input  [B-1:0]	w_data,	// Write Data
				output 			empty,full,
				output [B-1:0]	r_data	// Read Data 
			);


// Signal Declaration
	reg [B-1:0] array_reg[2**W-1:0];				// Register Array
	reg [W-1:0] w_ptr_reg, w_ptr_next, w_ptr_succ;	// Write Pointers
	reg [W-1:0] r_ptr_reg, r_ptr_next, r_ptr_succ;	// Read Pointers
	reg 		full_reg,full_next;
	reg 		empty_reg,empty_next;


// Write enabled only when FIFO is not Full
	assign wr_en 	=	wr & ~full_reg;

// Register file Read Operation 
	assign r_data	=	array_reg[r_ptr_reg];


// Register file write operation
	always@(posedge clk)
		if(wr_en)
			array_reg[w_ptr_reg] 	<=	w_data;

// FIFO Control Logic
// Sequential Always block
// Register for Read and Write pointers

	always @(posedge clk or negedge rst_n)
		begin	
			if(~rst_n) begin
				w_ptr_reg	<= 	0;
				r_ptr_reg	<=	0;
				full_reg	<=	1'b0;
				empty_reg 	<= 	1'b1;
			end else begin
				w_ptr_reg	<= 	w_ptr_next;
				r_ptr_reg	<=	r_ptr_next;
				full_reg 	<= 	full_next;
				empty_reg 	<=	empty_next;
			end
	end


// Next State logic for read and write pointers

	always@(*)
		begin 
			// Successive pointers values
			w_ptr_succ	=	w_ptr_reg + 1;
			r_ptr_succ	=	r_ptr_reg + 1;

			// default: keep old values
			w_ptr_next	=	w_ptr_reg;
			r_ptr_next	=	r_ptr_reg;
			full_next	=	full_reg;
			empty_next	=	empty_reg;


			case ({wr,rd})
				//2'b00	:	No Operation

				2'b01	:	// Read from FIFO
							if(~empty_reg) begin	// Not empty
								r_ptr_next	=	r_ptr_succ;
								full_next	=	1'b0;

								if(r_ptr_succ = w_ptr_reg)
									empty_next	=	1'b1;

							end
				
				2'b10 	:	// Write in FIFO
							if(~full_reg)begin	// Not Full 	
								w_ptr_next	=	w_ptr_succ;
								empty_next	=	1'b0;

								if(w_ptr_succ = r_ptr_reg)
									full_next 	=	1'b1;
							end
				
				2'b11	:	// Write and Read
							begin
								w_ptr_next	=	w_ptr_succ;
								r_ptr_next	=	r_ptr_succ;
							end
			endcase
		end

// Output
	assign full 	=	full_reg;
	assign empty 	=	empty_reg;

endmodule