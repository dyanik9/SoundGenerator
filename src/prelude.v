/*
	generate prelude
*/

//‘ifndef __PRELUDE__
//‘define __PRELUDE__

module prelude (
    input wire clk,    	// clock
    input wire reset,    	// reset
    output wire pwm_neg,
    output wire pwm_pos
);	

	parameter PITCH_BITWIDTH = 9;

	// loop through sine with f*len(LUT) --> brings one period --> we need 9 Bit counter
	// we have 10MHz clk
	
	/* verilator lint_off UNUSEDPARAM */
	parameter A = 'd177;		// 220 Hz		--> f = 56320 Hz		--> maxval = 177.5
	parameter Dhigh = 'd133;	// 293.66 Hz	--> f = 75176.96 Hz		--> maxval = 133
	parameter C = 'd149;		// 261.62 Hz	--> f = 66974.72 Hz		--> maxval = 149.3
	parameter B = 'd158;		// 246.94 Hz	--> f = 63216.64 Hz		--> maxval = 158.2
	parameter G = 'd199;		// 195.99 Hz	--> f = 50173.44 Hz		--> maxval = 199.3
	parameter Fis = 'd211;		// 184.99 Hz	--> f = 47357.44 Hz		--> maxval = 211.2
	parameter E = 'd237;		// 164.81 Hz	--> f = 42191.36 Hz		--> maxval = 237
	parameter D = 'd266;		// 146.83 Hz	--> f = 37588.48 Hz		--> maxval = 266
	/* verilator lint_on UNUSEDPARAM */
	
	//reg [PITCH_BITWIDTH-1:0] pitch [20];		// melody to play
	//reg [12:0] duration [20];	// duration of each tone
	
	parameter [PITCH_BITWIDTH-1:0] pitch [20] = '{D, G, G, A, B, G, Dhigh, B, B, C, Dhigh, C, B, C, Dhigh, A, G, A, B, A};	// 20 tones
	parameter [12:0] duration [20] = '{'d4000, 'd4000, 'd2000, 'd2000, 'd4000, 'd4000, 'd8000, 'd6000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000};	// das sind number of samples
	
	reg [PITCH_BITWIDTH-1:0] pos_sine;
	reg [PITCH_BITWIDTH-1:0] neg_sine;
	reg clk_sine;
	
	reg fs_clk;
	parameter fs_maxval = 'd125;
	
	reg [4:0] ctr_pitch_i;
	reg [12:0] ctr_duration;
	
	// sine generator
    sine #(PITCH_BITWIDTH) sine (
		.clk(clk),
		.sin_clk(clk_sine),
		.reset(reset),
		.pos_out(pos_sine),
		.neg_out(neg_sine)
    );
    
    parameter DAC_PERIOD = 'd511;	// a full 9Bit PWM (19kHz --> TODO: passt?) (ma kann sicher auf fs runtergehen, wär gscheiter oder?)
	
	// DAC pos edge
    dac #(PITCH_BITWIDTH) dac_pos (
		.clk(clk),
		.period(DAC_PERIOD),
		.reset(reset),
		.t_on(pos_sine),
		.pwm_out(pwm_pos)
    );
    
    // DAC neg edge
    dac #(PITCH_BITWIDTH) dac_neg (
		.clk(clk),
		.period(DAC_PERIOD),
		.reset(reset),
		.t_on(neg_sine),
		.pwm_out(pwm_neg)
    );
    
    // clkgen for fs
	clkgen #(7) clkgen_fs (
		.clk_i(clk),
		.reset(reset),
		.maxval(fs_maxval),
		.clk_o(fs_clk)
    );
    
    // clkgen for sinewave
	clkgen #(PITCH_BITWIDTH) clkgen_sin (
		.clk_i(clk),
		.reset(reset),
		.maxval(pitch[ctr_pitch_i]),
		.clk_o(clk_sine)
    );
	
	// TODO: correct maxval for given frequency? (we have 10MHz clk) --> YES!
	// TODO: reset clkgen, if frequency changed! (--> directly in clkgen, if maxval changed)
		
    
    // fs = 8kHz (for PWM) --> clkgen --> maxval = 125 --> 7 Bit
    
    // 1/4 = fs/2 --> duration = 4000 Samples
    // 1/8 = fs/4 --> duration = 2000 Samples
    // 1/2 = fs   --> duration = 8000 Samples
    // 3/8 = fs*3/4 --> duration = 6000 Samples

    // here is the action
    always @(posedge clk) begin
        if (reset) begin
        	ctr_pitch_i <= 'd0;
        	ctr_duration <= 'd0;
            //pitch = '{D, G, G, A, B, G, Dhigh, B, B, C, Dhigh, C, B, C, Dhigh, A, G, A, B, A};	// 20 tones
            //duration = '{'d4000, 'd4000, 'd2000, 'd2000, 'd4000, 'd4000, 'd8000, 'd6000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000};	// das sind number of samples
        end else if (fs_clk) begin	 // count at every fs
	    	// program flow to play prelude
	    	if(ctr_duration >= duration[ctr_pitch_i]-'d1) begin	// tone finished --> select next pitch
	    		if(ctr_pitch_i >= 'd19) begin // len of all pitches
					ctr_pitch_i <= 'd0;
				end else begin
					ctr_pitch_i <= ctr_pitch_i + 'd1;
				end
				ctr_duration <= 'd0;
	    	end else begin
				ctr_duration <= ctr_duration + 'd1;		// increase duration
			end
        end
    end

endmodule

//‘endif
