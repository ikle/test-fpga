/*
 * Unzip (Deinterleave) Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_UNZIP_V
`define LOGIC_UNZIP_V  1

module unzip #(
	parameter W = 8
)(
	input [2*W-1:0] s, output [W-1:0] a, output [W-1:0] b
);
	genvar i;

	for (i = 0; i < W; i = i + 1) begin : unzip
		assign a[i] = s[i*2 + 0];
		assign b[i] = s[i*2 + 1];
	end
endmodule

`endif  /* LOGIC_UNZIP_V */
