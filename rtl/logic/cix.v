/*
 * Bit Count Operation Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_CIX_V
`define LOGIC_CIX_V  1

/*
 *  clz ctz inv-in  op
 *
 *   1   0    0     clz
 *   0   1    0     ctz
 *   1   1    0     zerocount
 *   1   0    1     clo
 *   0   1    1     cto
 *   1   1    1     popcount
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

`endif  /* LOGIC_CIX_V */
