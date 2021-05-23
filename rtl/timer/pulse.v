/*
 * One-shot Pulse Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_PULSE_V
`define TIMER_PULSE_V  1

`include "timer/countdown.v"

module pulse #(
	parameter W = 8
)(
	input clock,
	input [W-1:0] start, input reset,
	input [W-1:0] value, input put, output reg act
);
	wire [W-1:0] count;

	countdown #(W) c (clock, start, reset, value, put, count);

	always @(posedge clock)
		act <= (count == 1);
endmodule

`endif  /* TIMER_PULSE_V */
