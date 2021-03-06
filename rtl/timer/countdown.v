/*
 * Countdown Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_COUNTDOWN_V
`define TIMER_COUNTDOWN_V  1

module countdown #(
	parameter W = 8
)(
	input clock,
	input [W-1:0] start, input reset,
	input [W-1:0] value, input put, output reg [W-1:0] count
);
	always @(posedge clock)
		if (reset)
			count <= start;
		else
		if (put)
			count <= value;
		else
		if (count > 0)
			count <= count - 1;
endmodule

`endif  /* TIMER_COUNTDOWN_V */
