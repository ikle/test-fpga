/*
 * Zip (Interleave) Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_ZIP_V
`define LOGIC_ZIP_V  1

module zip #(
	parameter W = 8
)(
	input [W-1:0] a, input [W-1:0] b, output [2*W-1:0] s
);
	genvar i;

	for (i = 0; i < W; i = i + 1)
		assign s[i*2+1:i*2] = {a[i], b[i]};
endmodule

`endif  /* LOGIC_ZIP_V */
