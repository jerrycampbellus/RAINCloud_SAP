// RAINCloud Digital | RAINCloud_SAP
// Original SAP design and codebase: J. Campbell.
//
module Data_Bus

	(
		input		wire			CLK,					// Clock to Synchronize Data Bus
		input		wire			DB_Enable,			//	Enable Data Bus
		input		wire	[7:0]	DB,					// Data Bus - IN / Out 
		output	reg	[7:0]	DB_Display			//	Display port for Data Bus
	);
	
	
	always @(posedge CLK)
		begin
			if (DB_Enable == 1'b1)
				DB_Display <= DB;
			else
				DB_Display <= 8'b0; // defined idle diagnostic value in FPGA fabric
		end
endmodule
