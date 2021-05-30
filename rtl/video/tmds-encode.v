/*
 * TMDS Encoder Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef VIDEO_TMDS_ENCODE_V
`define VIDEO_TMDS_ENCODE_V  1

`include "logic/popcount.v"

/*
 * DVI r1.0, 3.1.4 Encode Algorithm, first stage
 */
module tmds_balance_word (
	input clock,
	input [7:0] d, output [8:0] m
);
	wire [3:0] ones;

	popcount #(3) pc (d, ones);

	wire XNOR = (ones > 4'd4) | (ones == 4'd4 && d[0] == 1'b0);
	genvar i;

	for (i = 0; i < 8; i = i + 1)
		assign m[i] = (i[0] & XNOR) ^ ^d[i:0];

	assign m[8] = ~XNOR;
endmodule

/*
 * DVI r1.0, 3.1.4 Encode Algorithm, second stage
 *
 * NOTE: The zero check has been removed because it is redundant
 */
module tmds_balance_link (
	input clock,
	input [8:0] m, input [1:0] c, input de,
	output reg [9:0] q = 0
);
	wire [3:0] ones;

	popcount #(3) pc (m, ones);

	reg  [4:0] balance = 4'd0;
	wire [4:0] delta   = {ones, 1'b0} - 5'd8;

	wire sign_ne = (delta[3] ^ balance[3]);
	wire invert  = ~sign_ne;

	wire [4:0] inc  = delta - {m[8] ^ sign_ne, 1'b0};  /* m[8] == invert */
	wire [4:0] next = invert ? balance - inc : balance + inc;

	wire [9:0] tmds_data = {invert, m[8], m[7:0] ^ {8 {invert}}};
	wire [9:0] tmds_code = c[1] ? (c[0] ? 10'b1010101011 : 10'b0101010100):
				      (c[0] ? 10'b0010101011 : 10'b1101010100);

	always @(posedge clock) begin
		q       <= de ? tmds_data : tmds_code;
		balance <= de ? next : 5'd0;
	end
endmodule

/*
 * DVI r1.0, 3.2.2 Encode Algorithm
 */
module tmds_encode (
	input clock,
	input [7:0] d, input [1:0] c, input de,
	output [9:0] out
);
	wire [8:0] m;

	tmds_balance_word bw (clock, d, m);
	tmds_balance_link bl (clock, m, c, de, out);
endmodule

`endif  /* VIDEO_TMDS_ENCODE_V */
