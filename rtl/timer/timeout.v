/*
 * Timeout Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_TIMEOUT_V
`define TIMER_TIMEOUT_V  1

`include "timer/countdown.v"

module timeout #(
	parameter W = 8
)(
	input clock, input reset,
	input [W-1:0] value, input put, output full
);
	wire [W-1:0] count;

	countdown #(W) c (clock, reset, value, put, count);

	assign full = (count > 0);
endmodule

`endif  /* TIMER_TIMEOUT_V */
