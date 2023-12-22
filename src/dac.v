/*
	N bit DAC
*/

//‘ifndef __DAC__
//‘define __DAC__

module dac #(parameter N = 8) (
    input wire clk,    	// clock
    input wire reset,    	// reset
    input wire [N-1:0] t_on,	// on-time
    input wire [N-1:0] period,
    output wire pwm_out
);	
	// assign output
	assign pwm_out = pwm;
	
	
	// declare local registers
    reg [N-1:0] ctr_r;
    wire pwm = ctr_r < t_on;	// 1 while count value < t_on else 0
    

    // here is the action
    always @(posedge clk) begin
        if (reset) begin
            ctr_r <= 'd0;
        end else begin
			if(ctr_r >= period) begin // len of all pitches
				ctr_r <= 'd0;
			end else begin
				ctr_r <= ctr_r + 'd1;
			end
        end
    end

endmodule

//‘endif
