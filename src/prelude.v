/*
	generate prelude
*/

//‘ifndef __PRELUDE__
//‘define __PRELUDE__

module prelude #(parameter N = 8) (
    input wire clk,    	// clock
    input wire reset    	// reset
);	

	// TODO: generate sine here and pass it to the DAC right the way!
	
	// alternative: throw PWM away and make a set of 50% duty cycle rect generators with varying frequencies -> multiplexed to output when needed

    // here is the action
    always @(posedge clk) begin
        // TODO
    end

endmodule

//‘endif
