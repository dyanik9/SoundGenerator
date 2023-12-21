/*
	generate sinewave from LUT
*/

//‘ifndef __SINE__
//‘define __SINE__

module sine (
	input wire clk,    	// clock
    input wire reset,
    input wire [3:0] frequency, // TODO: enum, where frequency (A,B,C,D,E,F,... can be selected) --> only once per time. if this is changed --> trigger reset to begin sinewave from beginning?
	output wire [7:0] pos_out,
	output wire [7:0] neg_out
);	
	parameter N = 16;	
	
	parameter Pause = 0;	// off
	parameter Dhigh = 1;	// 293.66 Hz
	parameter C = 2;		// 261.62 Hz
	parameter B = 3;		// 246.94 Hz
	parameter G = 4;		// 195.99 Hz
	parameter Fis = 5;		// 184.99 Hz
	parameter E = 6;		// 164.81 Hz
	parameter D = 7;		// 146.83 Hz
	
	// this is a 8-bit sinewave, which will be played with varying frequency
	reg [7:0] LUT [0:255];	// positive halfwave (0-127) and negative halfwave (128-255)
	
	wire clk_sine;
	reg [N-1:0] maxval;
	
	reg [7:0] ctr_r;
	
	assign pos_out = (ctr_r < 'd128) ? LUT[ctr_r] : 'd0;
	assign neg_out = (ctr_r >= 'd128) ? LUT[ctr_r] : 'd0;
	
	// clkgen 
	clkgen #(N) clkgen (
		.clk_i(clk),
		.reset(reset),
		.maxval(maxval),
		.clk_o(clk_sine)
    );
    
    // TODO: correct maxval for given frequency!
    always @(frequency) begin
    	// TODO: reset clkgen, if frequency changed! (--> directly in clkgen, if maxval changed). or unnecessary?
		case(frequency)
			A:		maxval = 'd1;
			Dhigh: 	maxval = 'd1;
			C: 		maxval = 'd1;
			B: 		maxval = 'd1;
			G: 		maxval = 'd1;
			Fis: 	maxval = 'd1;
			E: 		maxval = 'd1;
			D: 		maxval = 'd1;
			default: ; // TODO: play no tone
		endcase
	end

    always @(posedge clk_sine) begin
        if (reset) begin
            ctr_r <= 'd0;
            LUT <= {'d0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6, 'd0, 'd6, 'd12, 'd18, 'd24, 'd31, 'd37, 'd43, 'd49, 'd55, 'd61, 'd68, 'd74, 'd79, 'd85, 'd91, 'd97, 'd103, 'd109, 'd114, 'd120, 'd125, 'd131, 'd136, 'd141, 'd146, 'd151, 'd156, 'd161, 'd166, 'd171, 'd175, 'd180, 'd184, 'd188, 'd193, 'd197, 'd201, 'd204, 'd208, 'd212, 'd215, 'd218, 'd221, 'd224, 'd227, 'd230, 'd233, 'd235, 'd237, 'd240, 'd242, 'd244, 'd245, 'd247, 'd248, 'd250, 'd251, 'd252, 'd253, 'd253, 'd254, 'd254, 'd254, 'd255, 'd254, 'd254, 'd254, 'd253, 'd253, 'd252, 'd251, 'd250, 'd248, 'd247, 'd245, 'd244, 'd242, 'd240, 'd237, 'd235, 'd233, 'd230, 'd227, 'd224, 'd221, 'd218, 'd215, 'd212, 'd208, 'd204, 'd201, 'd197, 'd193, 'd188, 'd184, 'd180, 'd175, 'd171, 'd166, 'd161, 'd156, 'd151, 'd146, 'd141, 'd136, 'd131, 'd125, 'd120, 'd114, 'd109, 'd103, 'd97, 'd91, 'd85, 'd79, 'd74, 'd68, 'd61, 'd55, 'd49, 'd43, 'd37, 'd31, 'd24, 'd18, 'd12, 'd6};
            
        end else begin
			ctr_r <= ctr_r + 'd1;	// auto overflow!
        end
    end

endmodule

//‘endif
