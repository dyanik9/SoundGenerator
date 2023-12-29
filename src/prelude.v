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
	
	reg [PITCH_BITWIDTH-1:0] pitch;	// tone to play
	reg [12:0] duration;			// duration of tone
	
	reg [PITCH_BITWIDTH-1:0] pos_sine;
	reg [PITCH_BITWIDTH-1:0] neg_sine;
	reg clk_sine;
	
	reg fs_clk;
	parameter fs_maxval = 'd1250;
	
	reg [4:0] ctr_pitch_i;
	reg [12:0] ctr_duration;
	
	// sine generator
    sine sine (
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
		//.maxval(pitch[ctr_pitch_i]),
		.maxval(pitch),
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
        	pitch <= 'd0;
        	duration <= 'd0;
        end else if (fs_clk) begin	 // count at every fs
	    	// program flow to play prelude
	    	case(ctr_pitch_i)
		    	'd0: begin pitch <= D; duration <= 'd4000; end
				'd1: begin pitch <= G; duration <= 'd4000; end
				'd2: begin pitch <= G; duration <= 'd2000; end
				'd3: begin pitch <= A; duration <= 'd2000; end
				'd4: begin pitch <= B; duration <= 'd4000; end
				'd5: begin pitch <= G; duration <= 'd4000; end
				'd6: begin pitch <= Dhigh; duration <= 'd8000; end
				'd7: begin pitch <= B; duration <= 'd6000; end
				'd8: begin pitch <= B; duration <= 'd2000; end
				'd9: begin pitch <= C; duration <= 'd4000; end
				'd10: begin pitch <= Dhigh; duration <= 'd2000; end
				'd11: begin pitch <= C; duration <= 'd2000; end
				'd12: begin pitch <= B; duration <= 'd2000; end
				'd13: begin pitch <= C; duration <= 'd2000; end
				'd14: begin pitch <= Dhigh; duration <= 'd4000; end
				'd15: begin pitch <= A; duration <= 'd2000; end
				'd16: begin pitch <= G; duration <= 'd2000; end
				'd17: begin pitch <= A; duration <= 'd2000; end
				'd18: begin pitch <= B; duration <= 'd2000; end
				'd19: begin pitch <= A; duration <= 'd4000; end
		    	default: begin pitch <= 'd0; duration <= 'd0; end
		    endcase
		    
	    	//if(ctr_duration >= duration[ctr_pitch_i]-'d1) begin	// tone finished --> select next pitch
	    	if(ctr_duration >= duration-'d1) begin
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
