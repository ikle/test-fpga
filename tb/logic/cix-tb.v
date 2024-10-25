/*
 * Word Bit Counter Modules Testbench
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "alu/cix.v"

`include "logic/align.v"
`include "logic/align-s.v"
`include "logic/clz.v"

`include "logic/popcount.v"
`include "logic/ctz.v"
`include "logic/ctz-ng.v"

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
	wire [W-1:0] as_o, ap_o;
	wire [ORDER:0] pout, cout, cout_ng;
	wire [ORDER:0] clz_o, ctz_o, pop_o, as_c, ap_c, clz_c;
	wire any, zero, clz_z, ctz_z, pop_z;

	popcount #(ORDER) A (in, pout);
	ctz      #(ORDER) B (in, cout, any);
	ctz_ng   #(ORDER) C (in, cout_ng, zero);

	cix      #(ORDER) D (`CIX_CLZ,  in, clz_o, clz_z);
	cix      #(ORDER) E (`CIX_CTZ,  in, ctz_o, ctz_z);
	cix      #(ORDER) F (`CIX_PCNT, in, pop_o, pop_z);

	align_s  #(ORDER, W) G (in, as_o, as_c);
	align    #(ORDER, W) H (in, ap_o, ap_c);

	clz      #(ORDER) I (in, clz_c);

	always @(posedge reset or posedge clock)
		if (reset)
			in <= 0;
		else
			in <= in + 1;

	always @(negedge clock) begin
		$display ("popcount     (%h) = %d",     in, pout);
		$display ("popcount-cix (%h) = %d, %d", in, pop_o, pop_z);

		$display ("ctz          (%h) = %d, %d", in, cout, any);
		$display ("ctz-ng       (%h) = %d, %d", in, cout_ng, zero);
		$display ("ctz-cix      (%h) = %d, %d", in, ctz_o, ctz_z);

		$display ("clz-cix      (%h) = %d, %d", in, clz_o, clz_z);
		$display ("clz-align-s  (%h) = %d, %x", in, as_c, as_o);
		$display ("clz-align-p  (%h) = %d, %x", in, ap_c, ap_o);
		$display ("clz          (%h) = %d",     in, clz_c);
	end

	initial begin
		$dumpfile ("cix.vcd");
		$dumpvars ();
	end
endmodule
