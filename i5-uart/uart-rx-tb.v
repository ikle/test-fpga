/*
 * UART RX Testbench Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "uart-rx.v"

module tb;
	reg reset, uart_clock = 0, rx;
	wire [7:0] out;
	wire rts, put;

	initial begin
		# 2.5	reset <= 1;
		# 100	reset <= 0;
		# 11000	$finish;
	end

	always
		# 4.4375	uart_clock = ~uart_clock;

	initial begin
		# 27		rx <= 1;
		# 189		rx <= 0;
		# 568		rx <= 1;
		# 141		rx <= 0;
		# 284		rx <= 1;
		# 142		rx <= 0;
		# 141		rx <= 1;
		# 142		rx <= 0;
		# 141		rx <= 1;
		# 142		rx <= 0;
		# 143		rx <= 1;
		# 142		rx <= 0;
		# 284		rx <= 1;
		# 285		rx <= 0;
		# 142		rx <= 1;
		# 143		rx <= 0;
		# 426		rx <= 1;
		# 284		rx <= 0;
		# 141		rx <= 1;
		# 284		rx <= 0;
		# 143		rx <= 1;
		# 141		rx <= 0;
		# 426		rx <= 1;
		# 284		rx <= 0;
		# 141		rx <= 1;
		# 284		rx <= 0;
		# 141		rx <= 1;
		# 141		rx <= 0;
		# 143		rx <= 1;
		# 568		rx <= 0;
		# 142		rx <= 1;
		# 284		rx <= 0;
		# 144		rx <= 1;
		# 142		rx <= 0;
		# 141		rx <= 1;
		# 143		rx <= 0;
		# 142		rx <= 1;
		# 284		rx <= 0;
		# 568		rx <= 1;
		# 142		rx <= 0;
		# 284		rx <= 1;
		# 142		rx <= 0;
		# 142		rx <= 1;
		# 142		rx <= 0;
		# 568		rx <= 1;
	end

	uart_rx u0 (reset, uart_clock, rts, rx, out, put);

	initial begin
		$dumpfile ("uart-rx.vcd");
		$dumpvars (0, tb);
	end
endmodule
