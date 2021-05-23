/*
 * Timer Testbench
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "timer/alarm.v"
`include "timer/pulse.v"
`include "timer/strobe.v"
`include "timer/timeout.v"

module tb;
	reg clock = 1, reset;

	always	# 2.5	clock = ~clock;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 327	$finish;
	end

	reg [7:0] value;
	reg put = 0;
	wire bell, full, act, beep, sync, busy;

	initial begin
		# 40	value <= 8'h11;
		# 5	put   <= 1;
		# 5	put   <= 0;
		# 10	put   <= 1;
		# 5	put   <= 0;
		# 70	value <= 8'h07;
	end

	alarm   t0 (clock, 8'b0, reset, value, put, bell);
	timeout t1 (clock, 8'b0, reset, value, put, full);
	pulse   t2 (clock, 8'b0, reset, value, put, act);
	strobe  t3 (clock, 8'b0, reset, value, put, beep);
	strobe  t4 (clock, 8'h05, reset, 8'b0, 1'b0, sync);
	timeout t5 (clock, 8'h19, reset, 8'b0, 1'b0, busy);

	initial begin
		$dumpfile ("timer.vcd");
		$dumpvars ();
	end
endmodule
