/*
 * Timer Testbench
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "timer/alarm.v"
`include "timer/timeout.v"

module tb;
	reg reset, clock = 1;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 327	$finish;
	end

	always	# 2.5	clock = ~clock;

	reg [7:0] value;
	reg put = 0;
	wire bell, full;

	initial begin
		# 40	value <= 8'h19;
		# 5	put   <= 1;
		# 5	put   <= 0;
	end

	alarm   t0 (reset, clock, value, put, bell);
	timeout t1 (reset, clock, value, put, full);

	initial begin
		$dumpfile ("timer.vcd");
		$dumpvars ();
	end
endmodule