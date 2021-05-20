/*
 * Timeout Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMEOUT_V
`define TIMEOUT_V  1

module timeout #(
	parameter W = 8
)(
	input reset, input clock,
	input [W-1:0] count, (* noglobal *) input put, output full
);
	reg [W-1:0] cursor, stop;
	wire init;

	always @(posedge reset or posedge put) #1
		if (reset)
			stop <= 0;
		else
			stop <= count;

	assign init = reset | put;

	always @(posedge init or posedge clock) #1
		if (init)
			cursor <= 0;
		else
		if (full)
			cursor <= cursor + 1;

	assign full = (cursor != stop);
endmodule

`endif  /* TIMEOUT_V */
