/*
	generate prelude
*/

//‘ifndef __PRELUDE__
//‘define __PRELUDE__

module prelude (
    input wire clk,    	// clock
    input wire reset,    	// reset
    output wire pwm_neg,
    output wire pwm_pos,
);	

	parameter N = 8;	// bitwidth

	parameter A = 0;		// 220 Hz
	parameter Dhigh = 1;	// 293.66 Hz
	parameter C = 2;		// 261.62 Hz
	parameter B = 3;		// 246.94 Hz
	parameter G = 4;		// 195.99 Hz
	parameter Fis = 5;		// 184.99 Hz
	parameter E = 6;		// 164.81 Hz
	parameter D = 7;		// 146.83 Hz
	
	reg [3:0] pitch [20];		// melody to play
	reg [3:0] duration [20];	// duration of each tone
	
	reg [7:0] pos_sine;
	reg [7:0] neg_sine;
	reg [3:0] frequency;
	
	// sine generator
    sine sine (
		.clk(clk),
		.reset(reset),
		.frequency(frequency),
		.pos_out(pos_sine),
		.neg_out(neg_sine)
    );
	
	// DAC pos edge
    dac #(N) dac_pos (
		.clk(clk),
		.reset(reset),
		.t_on(pos_sine),
		.pwm_out(pwm_pos)
    );
    
    // DAC neg edge
    dac #(N) dac_neg (
		.clk(clk),
		.reset(reset),
		.t_on(neg_sine),
		.pwm_out(pwm_neg)
    );

    // here is the action
    always @(posedge clk) begin
        
        if (reset) begin
            pitch <= {D, G, G, A, B, G, Dhigh, B, B, C, Dhigh, C, B, C, Dhigh, A, G, A, B, A};
            duration <= {};	// TODO: wie viele sekunden ist 1/8, 1/4, 1/2, ...?
        end else begin
			// TODO: control flow
        end
    end

endmodule

//‘endif
