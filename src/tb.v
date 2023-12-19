/*
2 Simple testbench for the counter .
3 */

‘timescale 1 ns / 1 ns

‘include " tt_um_soundgen . v "

module tb ;

	parameter BW = 3;

	 // inputs
	reg rst_i = 1 ’ b1 ;
	reg clk_i = 1 ’ b0 ;
	wire [ BW -1:0] cnt_val ;

	// DUT
	counter
		#( BW )
		counter_dut (
			. clk_i ( clk_i ) ,
			. rst_i ( rst_i ) ,
			. counter_val_o ( cnt_val )
	) ;
	// Generate clock
	/* verilator lint_off STMTDLY */
	always #5 clk_i = ~ clk_i ;
	/* verilator lint_on STMTDLY */

	initial begin
		$dumpfile ( " tt_um_soundgen . vcd " ) ;
		$dumpvars ;

		/* verilator lint_off STMTDLY */
		#50 rst_i = 1 ’ b0 ; // deassert reset
		#200 $finish ; // finish
		/* verilator lint_on STMTDLY */
	end
endmodule // tb
