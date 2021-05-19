/*
 * FIFO Helper Modules
 *
 * Copyright (c) 2017-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef FIFO_V
`define FIFO_V  1

`include "counter.v"

module fifo_state #(
	parameter W = 8		/* must be >= 2 */
)(
	input reset,
	input [W-1:0] w, r,	/* gray coded write and read pointers */
	output empty, full
);
	wire x, y, gs, gr;
	reg up;

	/* revert Gray Code and return two most significant bits */
	function [1:0] dgt (input [W-1:0] x);
		dgt = (x >> (W-2)) ^ (x >> (W-1));
	endfunction

	assign gs = (dgt (r) - dgt (w)) == 2'b1;
	assign gr = (dgt (w) - dgt (r)) == 2'b1 | reset;

	always @(posedge gr or posedge gs) #1
		if (gr)
			up <= 0;
		else
			up <= 1;

	assign empty = ~up & (w == r);
	assign full  =  up & (w == r);
endmodule

module fifo #(
	parameter W = 8, ORDER = 4
)(
	input reset,
	input [W-1:0] in, (* noglobal *) input put, output full,
	output reg [W-1:0] out, (* noglobal *) input get, output empty
);
	reg [W-1:0] ram [2**ORDER-1:0];
	wire [ORDER-1:0] w, r;

	gray_counter #(ORDER) cw (reset, ~put, w);
	gray_counter #(ORDER) cr (reset, ~get, r);

	fifo_state #(ORDER) state (reset, w, r, empty, full);

	always @(posedge put) #1
		if (!full)
			ram[w] <= in;

	always @(posedge get) #1
		if (!empty)
			out <= ram[r];
endmodule

`endif  /* FIFO_V */
