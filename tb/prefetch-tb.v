/*
 * Prefetch Testbench
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "mem/rom-seq.v"
`include "prefetch.v"
`include "timer/timeout.v"

module delay #(
	parameter W = 8
)(
	input clock, input reset,
	input  [W-1:0] in,  output get_i, input  empty_i,
	output [W-1:0] out, input  get_o, output empty_o
);
	wire [2:0] delay;
	wire pf_empty, pause;

	assign delay = (in == 8'h48 ? 3'h5 : 3'h0);

	prefetch #(W) pf (clock, reset,
			  in, get_i, empty_i, out, get_o, pf_empty);

	timeout #(3) t0 (clock, 3'h0, reset, delay, get_o, pause);

	assign empty_o = pf_empty | pause;
endmodule

module tb;
	reg clock = 0, reset;

	always	# 2.5	clock = ~clock;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 275	$finish;
	end

	wire [7:0] in, out;
	wire get_i, empty_i, empty_o;
	reg get_o;

	rom_seq #(8, "hello.hex", 7) rom (clock, reset, in, get_i, empty_i);
	delay #(8) d0 (clock, reset, in, get_i, empty_i, out, get_o, empty_o);

	always @(posedge clock)
		if (reset | get_o)
			get_o <= 0;
		else
			get_o <= !empty_o;

	initial begin
		$dumpfile ("prefetch.vcd");
		$dumpvars ();
	end
endmodule
