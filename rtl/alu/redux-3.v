/*
 * Core 3:2 Adder Reductor
 *
 * Copyright (c) 2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_REDUX_3_V
`define ALU_REDUX_3_V  1

/*
 * This module reduces the number of terms in a sum from three to two without
 * carry propagation.
 */
module redux_3 #(
	parameter W = 8
)(
	input [W-1:0] a, b, c, output [W-1:0] p, q
);
	assign p = a ^ b ^ c;
	assign q = (a & b | a & c | b & c) << 1;
endmodule

`endif  /* ALU_REDUX_3_V */
