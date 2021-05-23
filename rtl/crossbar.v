/*
 * Crossbar Switch Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef CROSSBAR_V
`define CROSSBAR_V  1

`include "logic/demux.v"

module crossbar #(
	parameter W = 8, IN = 8, OUT = 8
)(
	input reset,
	input [IN-1:0] in, output [OUT-1:0] out,
	input [W-1:0] from, input [W-1:0] to, (* noglobal *) input put
);
	reg signed [W-1:0] ai, ao;

	/* latch addresses to save power in demuxes and to reduce EMI */
	always @(posedge put) begin #1
		ai <= from;
		ao <= to;
	end

	wire [IN-1:0]  si;  /* select input  */
	wire [OUT-1:0] so;  /* select output */

	demux #(W, IN)  di (ai, 1'b1, si);
	demux #(W, OUT) do (ao, 1'b1, so);

	genvar i;

	for (i = 0; i < OUT; i = i + 1) begin : column
		reg  [IN-1:0] state;

		always @(posedge reset or negedge put) #1
			if (reset)
				state <= {IN {1'b0}};
			else
			if (so[i])
				state <= (ai < 0) ? {IN {1'b0}} : state | si;

		assign out[i] = | (state & in);
	end
endmodule

`endif  /* CROSSBAR_V */
