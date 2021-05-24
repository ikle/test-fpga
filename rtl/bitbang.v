/*
 * Bit-Bang Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef BITBANG_V
`define BITBANG_V  1

module bitbang #(
	parameter W = 16
)(
	input clock, input reset, input enable,
	input  [W-1:0] in,  output reg get, input empty,
	output [W-1:0] out, output reg put,
	input rx, output tx
);
	localparam CW = $clog2 (W + 1);

	reg [CW-1:0] count;
	reg [W:0] state;
	reg got;
	wire consume, shift, emit;

	assign consume = enable & (got & count < 2);
	assign shift   = enable & (count > 0);
	assign emit    = enable & (count == 1);

	always @(posedge clock)
		if (reset) begin
			count <= 0;
			state <= {W+1 {rx}};
		end
		else if (consume) begin
			count <= W;  /* add & use size argument, pad with rx? */
			state <= {in, rx};
		end
		else if (shift) begin
			count <= count - 1;
			state <= {state[W-1:0], rx};
		end

	always @(posedge clock)
		if (reset | get)
			get <= 0;
		else
		if (!got | consume)
			get <= !empty;

	always @(posedge clock)
		if (reset | consume)
			got <= 0;
		else
		if (get)
			got <= 1;

	always @(posedge clock)
		if (reset | put)
			put <= 0;
		else
			put <= emit;

	assign out = state[W-1:0];
	assign tx  = state[W];
endmodule

`endif  /* BITBANG_V */
