/*
	generate sinewave from LUT
*/

//‘ifndef __SINE__
//‘define __SINE__

module sine (
	input wire clk,    	// clock, varying
	input wire sin_clk,
    input wire reset,
	output wire [7:0] pos_out,
	output wire [7:0] neg_out
);	
	
	// this is a 8-bit sinewave, which will be played with varying frequency
	reg [7:0] LUT [0:255];	// positive halfwave (0-127) and negative halfwave (128-255)
	reg [7:0] ctr_r;
	
	reg [7:0] test;
	
	assign pos_out = (ctr_r < 'd128) ? LUT[ctr_r] : 'd0;
	assign neg_out = (ctr_r >= 'd128) ? LUT[ctr_r] : 'd0;		// TODO: array does somehow not work!

    always @(posedge clk) begin
        if (reset) begin
            ctr_r <= 'd0;
            LUT = '{'d0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6, 'd0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6};
            
        end else if (sin_clk) begin
			ctr_r <= ctr_r + 'd1;	// auto overflow!
			test <= LUT[0];
        end
    end

endmodule

//‘endif
