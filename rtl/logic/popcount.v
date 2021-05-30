/*
 * Population Count Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_POPCOUNT_V
`define LOGIC_POPCOUNT_V  1

module popcount #(
	parameter ORDER = 3
)(
	input [W-1:0] in, output [ORDER:0] out
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == 0)
			assign out = in;
		else begin
			wire [ORDER-1:0] a, b;

			popcount #(ORDER-1) pca (in[W/2-1:0], a);
			popcount #(ORDER-1) pcb (in[W-1:W/2], b);

			assign out = a + b;
		end
	endgenerate
endmodule

`endif  /* LOGIC_POPCOUNT_V */
