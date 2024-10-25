/*
 * Bit Count Operation Module
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_CIX_V
`define ALU_CIX_V  1

/*
 *  clz ctz  op
 *
 *   1   0   clz	= clo (~in)
 *   0   1   ctz	= cto (~in)
 *   1   1   zerocount	= popcount (~in)
 */
module cix #(
	parameter ORDER = 3
)(
	input clz, ctz,
	input [W-1:0] in, output [ORDER:0] out, output zero
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == 0) begin
			assign out  = ~in;
			assign zero = ~in;
		end
		else begin
			wire [ORDER-1:0] lo, ho, a, b;
			wire lz, hz;

			cix #(ORDER-1) l (clz, ctz, in[W/2-1:0], lo, lz);
			cix #(ORDER-1) h (clz, ctz, in[W-1:W/2], ho, hz);

			assign a = (hz | ctz) ? lo : 0;
			assign b = (lz | clz) ? ho : 0;

			assign out  = a  + b;
			assign zero = lz & hz;
		end
	endgenerate
endmodule

`endif  /* ALU_CIX_V */
