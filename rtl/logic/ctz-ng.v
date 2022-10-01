/*
 * Count Trailing Zeros Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_CTZ_NG_V
`define LOGIC_CTZ_NG_V  1

module ctz_ng #(
	parameter ORDER = 3
)(
	input [W-1:0] in, output [ORDER:0] out, output zero
);
	localparam W = 2 ** ORDER;

	generate
		if (ORDER == 0) begin
			assign out  = ~in;
			assign zero = ~in;
		end
		else begin
			wire [ORDER-1:0] lo, ho;
			wire lz, hz;

			ctz_ng #(ORDER-1) l (in[W/2-1:0], lo, lz);
			ctz_ng #(ORDER-1) h (in[W-1:W/2], ho, hz);

			assign out  = lo + ({ORDER {lz}} & ho);
			assign zero = lz & hz;
		end
	endgenerate
endmodule

`endif  /* LOGIC_CTZ_NG_V */
