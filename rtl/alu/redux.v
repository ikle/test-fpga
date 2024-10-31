/*
 * Parallel Adder Reductor
 *
 * Copyright (c) 2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_REDUX_V
`define ALU_REDUX_V  1

module redux #(
	parameter W = 8,
	parameter M = 8
)(
	input [W-1:0] x[M], output [W-1:0] q[2]
);
	localparam Q = M / 3;
	localparam R = M % 3;

	generate
		if (M == 3) begin
			wire [W-1:0] a = x[0];
			wire [W-1:0] b = x[1];
			wire [W-1:0] c = x[2];

			assign q[0] = a ^ b ^ c;
			assign q[1] = (a & b | a & c | b & c) << 1;
		end
		else begin
			wire [W-1:0] y[Q*2+R];
			genvar i;

			for (i = 0; i < Q; i = i + 1)
				redux #(W, 3) r3 (x[i*3:i*3+2], y[i*2:i*2+1]);

			for (i = 0; i < R; i = i + 1)
				assign y[Q*2+i] = x[Q*3+i];

			redux #(W, Q*2+R) rq (y, q);
		end
	endgenerate
endmodule

`endif  /* ALU_REDUX_V */
