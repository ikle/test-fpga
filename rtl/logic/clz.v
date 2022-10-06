/*
 * Count Leading Zeros Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_CLZ_V
`define LOGIC_CLZ_V  1

/*
 * Complexity: O(log n) where n = 2^order
 */
module clz #(
	parameter ORDER = 3
)(
	input [W-1:0] in, output [ORDER:0] out
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == 0) begin
			assign out = ~in;
		end
		else begin
			wire [ORDER-1:0] lo, ho, a, b;

			clz #(ORDER-1) l (in[W/2-1:0], lo);
			clz #(ORDER-1) h (in[W-1:W/2], ho);

			wire hz = ho[ORDER-1];

			assign a = hz ? lo               : 0;
			assign b = hz ? (1 << (ORDER-1)) : ho;

			assign out = a + b;
		end
	endgenerate
endmodule

`endif  /* LOGIC_CLZ_V */
