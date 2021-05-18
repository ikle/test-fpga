/*
 * Crossbar Switch Testbench
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`include "crossbar.v"

module tb;
	reg reset = 0;

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
		# 10	put <= 0;
		# 70	put <= 1; from <=  2; to <= 3;
		# 10	put <= 0;
		# 50	put <= 1; from <=  1; to <= 0;
		# 10	put <= 0;
		# 80	put <= 1; from <= -1; to <= 0;  /* unsubscribe */
		# 10	put <= 0;
		# 60	put <= 1; from <=  3; to <= 2;
		# 10	put <= 0;
		# 90	put <= 1; from <=  3; to <= 1;
		# 10	put <= 0;
		# 80	put <= 1; from <= -1; to <= 3;  /* unsubscribe */
		# 10	put <= 0;
		# 60	put <= 1; from <=  6; to <= 1;  /* unsubscribe */
		# 10	put <= 0;
		# 70	put <= 1; from <= -1; to <= 2;  /* unsubscribe */
		# 10	put <= 0;
	end

	wire [3:0] out;

	crossbar #(3, 4, 4) cb0 (reset, in, out, from, to, put);

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
