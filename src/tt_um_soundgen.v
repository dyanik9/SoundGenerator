`default_nettype none

module tt_um_soundgen (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire reset = ! rst_n;
    assign uo_out[7:4] = 4'd0;
    assign uo_out[3:0] = ctr_r;

    /* verilator lint_off UNUSEDSIGNAL */
    wire [7:0] dummy1 = ui_in;
    wire [7:0] dummy2 = uio_in;
    wire dummy3 = ena;
    /* verilator lint_on UNUSEDSIGNAL */

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    assign uio_out = 8'd0;

    // declare local registers
    reg [3:0] ctr_r;

    // here is the action
    always @(posedge clk) begin
        if (reset) begin
            ctr_r <= 4'd0;
        end else begin
		ctr_r <= ctr_r + 1'b1;
        end
    end

endmodule // tt_um_soundgen
