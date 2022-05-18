/*
 * Word Bit Counter Modules Testbench
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "logic/popcount.v"
`include "logic/ctz.v"

module tb;
	localparam ORDER = 3;
	localparam W = 2 ** ORDER;

	reg reset = 0, clock = 0;

	initial begin
		#1.3	reset = 1;
		#2	reset = 0;
		#520	$finish;
	end

	always
		#1	clock <= ~clock;

	reg  [W-1:0] in;
	wire [ORDER:0] pout, cout;
	wire any;

	popcount #(ORDER) A (in, pout);
	ctz      #(ORDER) B (in, cout, any);

	always @(posedge reset or posedge clock)
		if (reset)
			in <= 0;
		else
			in <= in + 1;

	always @(negedge clock) begin
		$display ("popcount (%h) = %d",     in, pout);
		$display ("ctz      (%h) = %d, %d", in, cout, any);
	end

	initial begin
		$dumpfile ("cix.vcd");
		$dumpvars ();
	end
endmodule
