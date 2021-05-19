/*
 * Counter Helper Modules
 *
 * Copyright (c) 2017-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef COUNTER_V
`define COUNTER_V  1

/*
 * gray code inverse function
 */
module gray_inv #(
	parameter W = 4
)(
	input [W-1:0] in, output [W-1:0] q
);
	genvar i;

	assign q[W-1] = in[W-1];

	for (i = W-2; i >= 0; i = i - 1)
		assign q[i] = q[i+1] ^ in[i];
endmodule

module gray_counter #(
	parameter W = 4
)(
	input reset, input clock, output reg [W-1:0] q
);
	wire [W-1:0] value, next;

	gray_inv #(W) gi0 (q, value);

	assign next = value + 1;

	always @(posedge reset or posedge clock) #1
		if (reset)
			q <= 0;
		else
			q <= next ^ (next >> 1);
endmodule

`endif  /* COUNTER_V */
