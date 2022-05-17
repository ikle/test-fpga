/*
 * Reverse Word Bits Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_REVERSE_V
`define LOGIC_REVERSE_V  1

module reverse #(
	parameter W = 8
)(
	input [W-1:0] in, output [W-1:0] out
);
	genvar i;

	generate
		for (i = 0; i < W; i = i + 1) begin : loop
			assign out[i] = in[W-1 - i];
		end
	endgenerate
endmodule

`endif  /* LOGIC_REVERSE_V */
