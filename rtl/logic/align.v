/*
 * Align Module: count and remove leading zeros
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_ALIGN_V
`define LOGIC_ALIGN_V  1

/*
 * count = clz (top n bits of in)
 * out   = in << count
 *
 * Complexity: O(log n) where n = 2^order = HW
 */
module align #(
	parameter ORDER = 3,
	parameter W = HW
)(
	input [W-1:0] in, output [W-1:0] out, output [ORDER:0] count
);
	localparam HW = 2 ** ORDER;
	localparam LW = W - HW;
	localparam DW = HW / 2;

	generate
		if (ORDER == 0) begin
			wire zero = ~in[W-1];

			assign out   = zero ? (in << 1) : in;
			assign count = zero;
		end
		else begin
			wire [W-1:0] lo, ho;
			wire [ORDER-1:0] lc, hc, a, b;

			align #(ORDER-1, W) l (in << DW, lo, lc);
			align #(ORDER-1, W) h (in,       ho, hc);

			wire hz = hc[ORDER-1];

			assign a = hz ? lc               : 0;
			assign b = hz ? (1 << (ORDER-1)) : hc;

			assign count = a + b;
			assign out   = hz ? lo : ho;
		end
	endgenerate
endmodule

`endif  /* LOGIC_ALIGN_V */
