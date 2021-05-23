/*
 * Periodic Pulse Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_STROBE_V
`define TIMER_STROBE_V  1

`include "timer/countdown.v"

module strobe #(
	parameter W = 8
)(
	input reset, input clock,
	input [W-1:0] value, input put, output act
);
	reg  [W-1:0] period;
	wire [W-1:0] count;
	wire load;

	always @(posedge clock)
		if (reset)
			period <= 0;
		else
		if (put)
			period <= value;

	assign load = (put | count == 1);

	countdown #(W) c (reset, clock, put ? value : period, load, count);

	assign act = (count == 1);
endmodule

`endif  /* TIMER_STROBE_V */
