/*
	generate sinewave from LUT
*/

//‘ifndef __SINE__
//‘define __SINE__

module sine #(parameter N = 9) (
	input wire clk,    	// clock, varying
	input wire sin_clk,
    input wire reset,
	output wire [N-1:0] pos_out,
	output wire [N-1:0] neg_out
);	
	
	// this is a 9-bit sinewave with 255 values, which will be played with varying frequency
	reg [N-1:0] LUT [0:255];	// positive halfwave (0-127) and negative halfwave (128-255) (index)
	reg [7:0] ctr_r;
	
	assign pos_out = (ctr_r < 'd128) ? LUT[ctr_r] : 'd0;
	assign neg_out = (ctr_r >= 'd128) ? LUT[ctr_r] : 'd0;

    always @(posedge clk) begin
        if (reset) begin
            ctr_r <= 'd0;
            LUT = '{'d0, 'd12, 'd25, 'd37, 'd50, 'd62, 'd74, 'd87, 'd99, 'd111, 'd124, 'd136, 'd148, 'd160, 'd172, 'd183, 'd195, 'd207, 'd218, 'd229, 'd240, 'd251, 'd262, 'd273, 'd283, 'd294, 'd304, 'd314, 'd324, 'd333, 'd343, 'd352, 'd361, 'd370, 'd378, 'd386, 'd395, 'd402, 'd410, 'd417, 'd424, 'd431, 'd438, 'd444, 'd450, 'd456, 'd461, 'd467, 'd472, 'd476, 'd481, 'd485, 'd488, 'd492, 'd495, 'd498, 'd501, 'd503, 'd505, 'd507, 'd508, 'd509, 'd510, 'd510, 'd511, 'd510, 'd510, 'd509, 'd508, 'd507, 'd505, 'd503, 'd501, 'd498, 'd495, 'd492, 'd488, 'd485, 'd481, 'd476, 'd472, 'd467, 'd461, 'd456, 'd450, 'd444, 'd438, 'd431, 'd424, 'd417, 'd410, 'd402, 'd395, 'd386, 'd378, 'd370, 'd361, 'd352, 'd343, 'd333, 'd324, 'd314, 'd304, 'd294, 'd283, 'd273, 'd262, 'd251, 'd240, 'd229, 'd218, 'd207, 'd195, 'd183, 'd172, 'd160, 'd148, 'd136, 'd124, 'd111, 'd99, 'd87, 'd74, 'd62, 'd50, 'd37, 'd25, 'd12, 'd0, 'd12, 'd25, 'd37, 'd50, 'd62, 'd74, 'd87, 'd99, 'd111, 'd124, 'd136, 'd148, 'd160, 'd172, 'd183, 'd195, 'd207, 'd218, 'd229, 'd240, 'd251, 'd262, 'd273, 'd283, 'd294, 'd304, 'd314, 'd324, 'd333, 'd343, 'd352, 'd361, 'd370, 'd378, 'd386, 'd395, 'd402, 'd410, 'd417, 'd424, 'd431, 'd438, 'd444, 'd450, 'd456, 'd461, 'd467, 'd472, 'd476, 'd481, 'd485, 'd488, 'd492, 'd495, 'd498, 'd501, 'd503, 'd505, 'd507, 'd508, 'd509, 'd510, 'd510, 'd511, 'd510, 'd510, 'd509, 'd508, 'd507, 'd505, 'd503, 'd501, 'd498, 'd495, 'd492, 'd488, 'd485, 'd481, 'd476, 'd472, 'd467, 'd461, 'd456, 'd450, 'd444, 'd438, 'd431, 'd424, 'd417, 'd410, 'd402, 'd395, 'd386, 'd378, 'd370, 'd361, 'd352, 'd343, 'd333, 'd324, 'd314, 'd304, 'd294, 'd283, 'd273, 'd262, 'd251, 'd240, 'd229, 'd218, 'd207, 'd195, 'd183, 'd172, 'd160, 'd148, 'd136, 'd124, 'd111, 'd99, 'd87, 'd74, 'd62, 'd50, 'd37, 'd25, 'd12};
            
        end else if (sin_clk) begin
			ctr_r <= ctr_r + 'd1;	// auto overflow!
        end
    end

endmodule

//‘endif
