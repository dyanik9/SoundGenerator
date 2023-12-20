// https://github.com/kvosic/kvosic_ws23_demo

`default_nettype none

//‘include " dac . v "

module tt_um_soundgen (	// DAC bitwidth
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
	parameter N = 8;

	//assign uio_out[0] = out;
	assign uio_out = {7'd0, out};

    wire reset = ! rst_n;
    parameter t_on = 127;
    
    wire out;
    
    // handle not needed wires
    /* verilator lint_off UNUSEDSIGNAL */
    wire [7:0] dummy1 = ui_in;
    wire [7:0] dummy2 = uio_in;
    wire foo = ena;
    /* verilator lint_on UNUSEDSIGNAL */
    assign uio_oe = 8'd0;
    assign uo_out = 8'd0;
    // ---------
    
    // DAC
    dac #(N) dac0 (
		.clk(clk),
		.reset(reset),
		.t_on(t_on),
		.pwm_out(out)
    );

    // here is the action
    always @(posedge clk) begin
    	// foo
    end

endmodule // tt_um_soundgen
