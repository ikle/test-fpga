/*
 * Parallel M:2 Adder Reductor
 *
 * Copyright (c) 2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_REDUX_V
`define ALU_REDUX_V  1

`include "alu/redux-3.v"

/*
 * This module reduces the number of terms in a sum from M to two without
 * carry propagation.
 */
module redux #(
	parameter W = 8,
	parameter M = 8
)(
	input [W-1:0] x[M], output [W-1:0] q[2]
);
	localparam Q = M / 3;
	localparam R = M % 3;

	generate
		if (M == 3)
			redux_3 #(W) r3 (x[0], x[1], x[2], q[0], q[1]);
		else begin
			wire [W-1:0] y[Q*2+R];
			genvar i;

			for (i = 0; i < Q; i = i + 1)
				redux_3 #(W) r3 (x[i*3], x[i*3+1], x[i*3+2],
						 y[i*2], y[i*2+1]);

			for (i = 0; i < R; i = i + 1)
				assign y[Q*2+i] = x[Q*3+i];

			redux #(W, Q*2+R) rq (y, q);
		end
	endgenerate
endmodule

`endif  /* ALU_REDUX_V */
