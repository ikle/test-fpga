/*
 * Bit Count Operation Module Testbench
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "alu/cix.v"

module tb;
	localparam ORDER = 3;
	localparam W = 2 ** ORDER;

	function [ORDER:0] pcnt (input [W-1:0] x);
		integer i;
	begin
		pcnt = x[0];

		for (i = 1; i < W; i = i + 1)
			pcnt = pcnt + x[i];
	end
	endfunction

	function [ORDER:0] clz (input [W-1:0] x);
		integer i;
	begin
		clz = 0;

		for (i = W-1; i >= 0 && x[i] == 0; i = i - 1)
			clz = clz + 1;
	end
	endfunction

	function [ORDER:0] ctz (input [W-1:0] x);
		integer i;
	begin
		ctz = 0;

		for (i = 0; i < W && x[i] == 0; i = i + 1)
			ctz = ctz + 1;
	end
	endfunction

	reg  [W-1:0] in = 0;
	wire [ORDER:0] pop_o, clz_o, ctz_o, pop_s, clz_s, ctz_s;
	wire pop_a, clz_z, ctz_z;

	cix #(ORDER) A (`CIX_PCNT, in, pop_o, pop_a);
	cix #(ORDER) B (`CIX_CLZ,  in, clz_o, clz_z);
	cix #(ORDER) C (`CIX_CTZ,  in, ctz_o, ctz_z);

	assign pop_s = pcnt (in);
	assign clz_s = clz  (in);
	assign ctz_s = ctz  (in);

	initial begin
		$dumpfile ("cix.vcd");
		$dumpvars ();
		#260 $finish;
	end

	always
		#1 in <= in + 1;

	always @(in) begin
		if (pop_o != pop_s)
			$error ("pcnt (%h) = %d, want %d", in, pop_o, pop_s);

		if (clz_o != clz_s)
			$error ("clz (%h) = %d, want %d", in, clz_o, clz_s);

		if (ctz_o != ctz_s)
			$error ("ctz (%h) = %d, want %d", in, ctz_o, ctz_s);
	end
endmodule
