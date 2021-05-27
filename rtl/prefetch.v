/*
 * Prefetch Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef PREFETCH_V
`define PREFETCH_V  1

module prefetch #(
	parameter W = 8
)(
	input clock, input reset,
	input      [W-1:0] in,  output reg get_i, input      empty_i,
	output reg [W-1:0] out, input      get_o, output reg empty_o
);
	always @(posedge clock)
		if (reset | get_i)
			get_i <= 0;
		else
		if (empty_o | get_o)
			get_i <= !empty_i;

	always @(posedge clock)
		if (get_o)
			out <= in;

	always @(posedge clock)
		if (reset)
			empty_o <= 1;
		else
		if (get_i)
			empty_o <= 0;
		else
		if (get_o)
			empty_o <= empty_i;
endmodule

`endif  /* PREFETCH_V */
