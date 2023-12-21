/*
	generate sinewave from LUT
*/

//‘ifndef __SINE__
//‘define __SINE__

module sine (
	input wire clk,    	// clock
    input wire reset,
    input wire [x:0] frequency, // TODO: enum, where frequency (A,B,C,D,E,F,... can be selected) --> only once per time. if this is changed --> trigger reset to begin sinewave from beginning?
	output wire [7:0] pwm_out
);	
	// this is a 8-bit sinewave, which will be played with varying frequency
	// positive halfwave (128 long -> 7 Bit)
	wire LUT_pos[6:0] = {'d0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6}
	
	// negative halfwave (128 long -> 7 Bit)
	wire LUT_neg[6:0] = {'d0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6}
	
	// TODO: play LUT_pos and LUT_neg just nacheinander in 2 for loops (with correct frequency!)
	
	// TODO: die entsprechende Note bekommen ma, indem ma das array mit unterschiedlicher fs (entsprechend der Frequenz der Note) durchlaufen. in prelude.wav wird des ganze einfach 		getimet, dass de richtige Note zur richtigen Zeit da ist (TODO: check ob ma 2 Noten gleichzeitig a brauchn)

    always @(posedge clk) begin
        // TODO
    end

endmodule

//‘endif
