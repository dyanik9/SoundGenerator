/*
	Counter with upper limit, for clkgen
*/

//‘ifndef __CLKGEN__
//‘define __CLKGEN__

module clkgen #(parameter N = 8) (
    input wire clk_i,    	// clock
    input wire reset,    	// reset
    input wire [N-1:0] maxval,	// maxval
    output wire clk_o // 1 if overflow, else 0
);	
	// assign output
	assign clk_o = clk;
	
	
	// declare local registers
    reg [N-1:0] ctr_r;
    wire clk;

    // here is the action
    always @(posedge clk_i) begin
        if (reset) begin
            ctr_r <= 'd0;
            clk <= 'd0;
        end else if (ctr_r >= maxval) begin
			clk <= ! clk;
			ctr_r <= 'd0;
        end else begin
			ctr_r <= ctr_r + 'd1;
        end
    end

endmodule

//‘endif
