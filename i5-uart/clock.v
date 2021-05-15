/*
 * Clock Helper Modules
 *
 * Copyright (c) 2017-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef CLOCK_V
`define CLOCK_V  1

module sync (
	input clock, input d, output reg q
);
	reg buffer;

	always @(posedge clock) #1
		buffer <= d;

	always @(negedge clock) #1
		q <= buffer;
endmodule

module filter #(
	parameter MAX = 8
)(
	input reset, input clock, input d, output reg q, output reg lock
);
	localparam MIN = 0;
	localparam W   = $clog2 (MAX + 1);

	wire d_sync;
	reg [W-1:0] count;

	sync s0 (~clock, d, d_sync);

	always @(posedge reset, negedge clock) #1
		if (reset)
			count <= MIN;
		else
		if (d_sync)
			count <= (count == MAX) ? count : count + 1;
		else
			count <= (count == MIN) ? count : count - 1;

	always @(negedge clock) #1
		case (count)
		MIN:	q <= 0;
		MAX:	q <= 1;
		endcase

	always @(negedge clock) #1
		case (count)
		MIN:		lock <=  q;
		MAX:		lock <= ~q;
		default:	lock <=  0;
		endcase
endmodule

module alarm #(
	parameter PERIOD = 16,
	parameter PHASE  = 8
)(
	input reset, input clock, output q
);
	localparam W = $clog2 (PERIOD);

	reg [W-1:0] count;

	always @(posedge reset, negedge clock) #1
		if (reset)
			count <= 0;
		else
			count <= (count == PERIOD - 1) ? 0 : count + 1;

	assign q = (count == PHASE);
endmodule

`endif  /* CLOCK_V */
