/*
 * Periodic Ring Timer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef TIMER_RING_V
`define TIMER_RING_V  1

module ring #(
	parameter W = 8, START = 1
)(
	input clock,
	input [W-1:0] start, input reset, output out
);
	reg [W-1:0] state = START;

	always @(posedge clock)
		if (reset)
			state <= start;
		else
			state <= {state[W-2:0], state[W-1]};

	assign out = state[W-1];
endmodule

`endif  /* TIMER_RING_V */
