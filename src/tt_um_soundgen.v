`default_nettype none

//‘include " dac . v "

module tt_um_soundgen (
    input wire       ena,      // will go high when the design is enabled
    input wire       clk,      // clock
    input wire       rst_n,     // reset_n - low to reset
    
    // not needed
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
);	

	assign uio_out = {6'b0, pwm_pos, pwm_neg};	// TODO: which pins are these?

    wire reset = ! rst_n;
    
    wire pwm_neg;
    wire pwm_pos;
    
    // handle not needed wires
    /* verilator lint_off UNUSEDSIGNAL */
    wire [7:0] dummy1 = ui_in;
    wire [7:0] dummy2 = uio_in;
    wire foo = ena;
    /* verilator lint_on UNUSEDSIGNAL */
    assign uio_oe = 8'b1;
    assign uo_out = 8'b0;
    // ---------
    
    // Prelude
    prelude prelude (
		.clk(clk),
		.reset(reset),
		.pwm_neg(pwm_neg),
		.pwm_pos(pwm_pos)
    );
    
    
    // test sine
    /*reg [7:0] pos_sine;
	reg [7:0] neg_sine;
    sine sine (
		.clk(clk),
		.sin_clk(clk),
		.reset(reset),
		.pos_out(pos_sine),
		.neg_out(neg_sine)
    );*/

    // here is the action
    /*always @(posedge clk) begin
    	// not needed
    end*/

endmodule // tt_um_soundgen
