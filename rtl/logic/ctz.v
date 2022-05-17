/*
 * Count Trailing Zeros Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_CTZ_V
`define LOGIC_CTZ_V  1

module ctz #(
	parameter ORDER = 3
)(
	input [W-1:0] in, output [ORDER:0] out, output any
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == 0) begin
			assign out = ~in;
			assign any =  in;
		end
		else begin
			wire [ORDER-1:0] lo, ho;
			wire la, ha;

			ctz #(ORDER-1) l (in[W/2-1:0], lo, la);
			ctz #(ORDER-1) h (in[W-1:W/2], ho, ha);

			assign out = la ? lo : lo + ho;
			assign any = la | ha;
		end
	endgenerate
endmodule

`endif  /* LOGIC_CTZ_V */
