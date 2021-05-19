/*
 * Power-on-Reset Generator Module
 *
 * Copyright (c) 2017-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef RESET_V
`define RESET_V  1

module reset_gen #(
	parameter W = 3
)(
	input reset_i, input clock, output reset_o
);
	reg [W-1:0] counter;

	assign reset_o = ~counter[W-1];

	always @(posedge clock) #1
		if (reset_i)
			counter <= 0;
		else
			counter <= reset_o ? counter + 1 : counter;
endmodule

`endif  /* RESET_V */
