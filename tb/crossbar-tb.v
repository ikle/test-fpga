/*
 * Crossbar Switch Testbench
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "crossbar.v"

module tb;
	reg clock = 1, reset = 0;

	always	# 2.5	clock = ~clock;

	initial begin
		# 40	reset <= 1;
		# 10	reset <= 0;
		# 750	$finish;
	end

	reg a, b, c, d;

	always	begin #2 a <= 1; #2 a <= 0; end
	always	begin #4 b <= 1; #4 b <= 0; end
	always	begin #9 c <= 1; #2 c <= 0; end
	always	begin #7 d <= 1; #7 d <= 0; end

	wire [3:0] in;

	assign in = {d, c, b, a};

	reg signed [2:0] from, to;
	reg put = 0;

	initial begin
		# 80	put <= 1; from <=  0; to <= 0;
		# 5	put <= 0;
		# 75	put <= 1; from <=  2; to <= 3;
		# 5	put <= 0;
		# 55	put <= 1; from <=  1; to <= 0;
		# 5	put <= 0;
		# 85	put <= 1; from <= -1; to <= 0;  /* unsubscribe */
		# 5	put <= 0;
		# 65	put <= 1; from <=  3; to <= 2;
		# 5	put <= 0;
		# 95	put <= 1; from <=  3; to <= 1;
		# 5	put <= 0;
		# 85	put <= 1; from <= -1; to <= 3;  /* unsubscribe */
		# 5	put <= 0;
		# 65	put <= 1; from <=  6; to <= 1;  /* unsubscribe */
		# 5	put <= 0;
		# 75	put <= 1; from <= -1; to <= 2;  /* unsubscribe */
		# 5	put <= 0;
	end

	wire [3:0] out;

	crossbar #(3, 4, 4) cb0 (clock, reset, in, out, from, to, put);

	wire e, f, g, h;

	assign e = out[0];
	assign f = out[1];
	assign g = out[2];
	assign h = out[3];

	initial begin
		$dumpfile ("crossbar.vcd");
		$dumpvars ();
	end
endmodule
