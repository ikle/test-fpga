/*
 * Alarm Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_ALARM_V
`define TIMER_ALARM_V  1

`include "timer/countdown.v"

module alarm #(
	parameter W = 8
)(
	input reset, input clock,
	input [W-1:0] value, input put, output reg bell
);
	wire [W-1:0] count;

	countdown #(W) c (reset, clock, value, put, count);

	always @(posedge clock)
		if (reset)
			bell <= 0;
		else
		if (put)
			bell <= 0;
		else
		if (count == 1)
			bell <= 1;
endmodule

`endif  /* TIMER_ALARM_V */
