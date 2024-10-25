/*
 * Comparator Module
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_CMP_V
`define ALU_CMP_V  1

module cmp #(
	parameter ORDER = 3,
	parameter LIMIT = 0
)(
	input [W-1:0] a, input [W-1:0] b, output lt, eq, gt
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == LIMIT) begin
			assign lt = a <  b;
			assign eq = a == b;
			assign gt = a >  b;
		end
		else begin
			wire llt, leq, lgt, hlt, heq, hgt;

			cmp #(ORDER-1) l (a[W/2-1:0], b[W/2-1:0], llt, leq, lgt);
			cmp #(ORDER-1) h (a[W-1:W/2], b[W-1:W/2], hlt, heq, hgt);

			assign lt = heq ? llt : hlt;
			assign eq = leq & heq;
			assign gt = heq ? lgt : hgt;
		end
	endgenerate
endmodule

`endif  /* ALU_CMP_V */
