/*
 * Clock Modules
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef CLOCK_V
`define CLOCK_V  1

module counter_max #(
	parameter W = 4, MAX = 15
)(
	input reset, input clock,
	output reg [W-1:0] value_o, output reg carry_o
);
	always @(posedge clock)
//	always @(posedge reset or posedge clock)
		if (reset) begin
			value_o <= W'b0;
			carry_o <= 1'b0;
		end
		else
		if (value_o == MAX) begin
			value_o <= W'b0;
			carry_o <= ~carry_o;
		end
		else
			value_o <= value_o + 1;
endmodule

module clock_div #(
	parameter DIV = 3
)(
	input  reset, input clock_i, output clock_o
);
	localparam MAX = DIV - 1;
	localparam W = $clog2(MAX);

	wire [W-1:0] counter;

	counter_max #(W, MAX) c0 (reset, clock_i, counter, clock_o);
endmodule

module clock_gen #(
	parameter CLOCK = 25_000_000, FREQ  = 115_200
)(
	input  reset, input clock_i, output clock_o
);
	clock_div #(CLOCK / FREQ / 2) c0 (reset, clock_i, clock_o);
endmodule

`endif  /* CLOCK_V */
