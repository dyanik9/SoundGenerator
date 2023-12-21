/*
	generate sinewave from LUT
*/

//‘ifndef __SINE__
//‘define __PRELUDE__

module sine (

);	

	wire LUT[N-1:0];
	
	// TODO: fill LUT (just copy paste from python)
	
	// TODO: die entsprechende Note bekommen ma, indem ma das array mit unterschiedlicher fs (entsprechend der Frequenz der Note) durchlaufen. in prelude.wav wird des ganze einfach 		getimet, dass de richtige Note zur richtigen Zeit da ist (TODO: check ob ma 2 Noten gleichzeitig a brauchn)
	// einfach in python array generieren lassen und fertig --> copy paste

	
	// function needed?
	/*function [N-1:0]sin;
		input [3:0]phi; // 0 ... 2pi (360°)
		input [2:0]f;	// 1 ... 400Hz(?)
	begin
		sin = LUT; // TODO: copy algorithm from python here
	end
	endfunction*/

    // here is the action
    always @(posedge clk) begin
        // TODO
    end

endmodule

//‘endif
