/*
 * Timeout Module Testbench
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`include "timeout.v"

module tb;
	reg reset = 0, clock = 0;

	initial begin
		# 40	reset <= 1;
		# 10	reset <= 0;
		# 750	$finish;
	end

	always	# 2.6	clock <= ~clock;

	reg [7:0] count;
	reg put = 0;
	wire full;

	initial begin
		# 80	count <= 10;
		# 3	put <= 1;
		# 1	put <= 0;
		# 100	count <= 30;
		# 4	put <= 1;
		# 3	put <= 0;
		# 200	count <= 20;
		# 5	put <= 1;
		# 17	put <= 0;
		# 150	count <= 10;
		# 2	put <= 1;
		# 5	put <= 0;
		# 41	count <= 11;
		# 2	put <= 1;
		# 1	put <= 0;
	end

	timeout #(8) t0 (reset, clock, count, put, full);

	initial begin
		$dumpfile ("timeout.vcd");
		$dumpvars ();
	end
endmodule
