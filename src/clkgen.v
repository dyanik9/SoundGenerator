/*
	Counter with upper limit, for clkgen (creates just one strobe if maxval reached!)
*/

//‘ifndef __CLKGEN__
//‘define __CLKGEN__

module clkgen #(parameter N = 16) (
    input wire clk_i,    	// clock
    input wire reset,    	// reset
    input wire [N-1:0] maxval,	// maxval
    output wire clk_o // 1 if overflow, else 0
);	
	// assign output
	assign clk_o = clk_strobe;
	
	
	// declare local registers
    reg [N-1:0] ctr_r;
    reg clk_strobe;

    // here is the action
    always @(posedge clk_i) begin 
        if (reset) begin
            ctr_r <= 'd0;
            clk_strobe <= 'b0;
        end else if (ctr_r >= maxval - 'd1) begin // TODO:  - 'd1 needed? i think so (er zählt ja von 0 bis maxval - 1) == maxval counts
			ctr_r <= 'd0;
			clk_strobe <= 'b1;
        end else begin
			ctr_r <= ctr_r + 'd1;
			clk_strobe <= 'b0;
        end
    end

endmodule

//‘endif
