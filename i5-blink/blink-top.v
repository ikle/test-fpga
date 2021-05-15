/*
 * Blink Test Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`include "reset.v"
`include "clock.v"

module top #(
	parameter FREQ  = 2,
	parameter CLOCK = 25_000_000
)(
	input pad_osc, output pad_led
);
	wire reset_s;

	reset_gen r0 (1'b0, pad_osc, reset_s);

	clock_gen #(CLOCK, FREQ) c0 (reset_s, pad_osc, pad_led);
endmodule
