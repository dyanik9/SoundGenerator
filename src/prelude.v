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

	parameter N = 8;	// bitwidth for DAC

	// loop through sine with f*len(LUT) --> brings one period = 
	
	parameter A = 'd18;		// 220 Hz		--> f = 56320 Hz		--> maxval = 17.75
	parameter Dhigh = 'd13;	// 293.66 Hz	--> f = 75176.96 Hz		--> maxval = 13.30
	parameter C = 'd15;		// 261.62 Hz	--> f = 66974.72 Hz		--> maxval = 14.93
	parameter B = 'd16;		// 246.94 Hz	--> f = 63216.64 Hz		--> maxval = 15.82
	parameter G = 'd20;		// 195.99 Hz	--> f = 50173.44 Hz		--> maxval = 19.93
	parameter Fis = 'd21;		// 184.99 Hz	--> f = 47357.44 Hz		--> maxval = 21.12
	parameter E = 'd24;		// 164.81 Hz	--> f = 42191.36 Hz		--> maxval = 23.7
	parameter D = 'd27;		// 146.83 Hz	--> f = 37588.48 Hz		--> maxval = 26.6
	
	reg [4:0] pitch [20];		// melody to play
	reg [12:0] duration [20];	// duration of each tone
	
	reg [7:0] pos_sine;
	reg [7:0] neg_sine;
	reg clk_sine;
	
	reg fs_clk;
	parameter fs_maxval = 125;
	
	reg [4:0] ctr_pitch_i;
	reg [12:0] ctr_duration;
	
	reg [12:0] test;
	
	// sine generator
    sine sine (
		.clk(clk),
		.sin_clk(clk_sine),
		.reset(reset),
		.pos_out(pos_sine),
		.neg_out(neg_sine)
    );
	
	// DAC pos edge
    dac #(N) dac_pos (
		.clk(clk),
		.fs_clk(fs_clk),
		.reset(reset),
		.t_on(pos_sine),
		.pwm_out(pwm_pos)
    );
    
    // DAC neg edge
    dac #(N) dac_neg (
		.clk(clk),
		.fs_clk(fs_clk),
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
	clkgen #(5) clkgen_sin (
		.clk_i(clk),
		.reset(reset),
		.maxval(pitch[ctr_pitch_i]),
		.clk_o(clk_sine)
    );
	
	// TODO: correct maxval for given frequency? (we have 1MHz clk)
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
            pitch <= {D, G, G, A, B, G, Dhigh, B, B, C, Dhigh, C, B, C, Dhigh, A, G, A, B, A};	// 20 tones
            //duration <= {'d4000, 'd4000, 'd2000, 'd2000, 'd4000, 'd4000, 'd8000, 'd6000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000, 'd2000, 'd2000, 'd2000, 'd2000, 'd4000};	// das sind number of samples
            duration <= {'d4, 'd4, 'd2, 'd2, 'd4, 'd4, 'd8, 'd6, 'd2, 'd4, 'd2, 'd2, 'd2, 'd2, 'd4, 'd2, 'd2, 'd2, 'd2, 'd4};	// das sind number of samples
            test <= 'd255;
        end else if (fs_clk) begin
	    	// program flow to play prelude
	    	if(ctr_duration >= duration[ctr_pitch_i]-'d1) begin	// tone finished --> select next pitch
	    		if(ctr_pitch_i >= 19) begin // len of all pitches
					ctr_pitch_i <= 'd0;
				end else begin
					ctr_pitch_i <= ctr_pitch_i + 'd1;
				end
				ctr_duration <= 'd0;
	    	end else begin
				ctr_duration <= ctr_duration + 'd1;		// increase duration
			end
			test <= duration[ctr_pitch_i];
        end
    end

endmodule

//‘endif
