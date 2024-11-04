/*
 * Parallel M:2 Adder Reductor Testbench
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "alu/redux.v"

module tb;
	localparam W = 17;
	localparam M = 13;

	reg  [W-1:0] x[M], sum;
	wire [W-1:0] q[2], s;

	redux #(W, M) R (x, q);

	assign s = q[0] + q[1];

	reg clock = 0;
	integer i;

	always
		#1 clock <= ~clock;

	always @(posedge clock) begin
		sum = 0;

		for (i = 0; i < M; i = i + 1) begin
			x[i] = $random;
			sum = sum + x[i];
		end
	end

	initial begin
		$dumpfile ("redux.vcd");
		$dumpvars ();
		#260 $finish;
	end

	always @(negedge clock) begin
		if (s != sum)
			$error ("sum = %d, want %d", s, sum);
	end
endmodule
