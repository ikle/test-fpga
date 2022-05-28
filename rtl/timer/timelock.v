/*
 * Timeout Lock Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_TIMELOCK_V
`define TIMER_TIMELOCK_V  1

module timelock #(
	parameter W = 4
)(
	input clock, reset, input set, input [W-1:0] delay, output lock
);
	reg [W-1:0] count = 0;
	reg r_lock = 0;

	wire gt = (delay > count);

	always @(posedge clock)
		if (reset)
			r_lock <= 0;
		else
		if (set && gt)
			r_lock <= delay > 1;
		else
			r_lock <= count > 1;

	assign lock = r_lock;

	always @(posedge clock)
		if (reset)
			count <= 0;
		else
		if (set && gt)
			count <= delay - 1;
		else
		if (count != 0)
			count <= count - 1;
		else
			count <= 0;  /* remove extra wires */
endmodule

`endif  /* TIMER_TIMELOCK_V */
