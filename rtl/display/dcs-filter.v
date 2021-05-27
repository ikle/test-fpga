/*
 * MIPI DCS Filter Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef DISPLAY_DCS_FILTER_V
`define DISPLAY_DCS_FILTER_V  1

`include "prefetch.v"
`include "timer/timeout.v"

module dcs_filter #(
	parameter W = 8, FREQ = 25_000_000, DELAY = 120
)(
	input clock, input reset,
	input  dc_i, input  [W-1:0] in,  output get_i, input  empty_i,
	output dc_o, output [W-1:0] out, input  get_o, output empty_o
);
	localparam SWRESET = 9'h001;
	localparam SLPIN   = 9'h010;
	localparam SLPOUT  = 9'h011;

	localparam TIMEOUT = DELAY * (FREQ / 1000);  /* DELAY ms */
	localparam TW      = $clog2 (TIMEOUT);

	wire [8:0] cmd;
	wire [TW-1:0] zero, delay;
	wire power_cmd, pf_empty, pause;

	assign cmd       = {dc_i, in[7:0]};
	assign power_cmd = (cmd == SWRESET | cmd == SLPIN | cmd == SLPOUT);
	assign zero      = {TW {1'h0}};
	assign delay     = power_cmd ? TIMEOUT : zero;

	prefetch #(W+1) pf (clock, reset,
			    {dc_i, in},  get_i, empty_i,
			    {dc_o, out}, get_o, pf_empty);

	timeout #(TW) t0 (clock, zero, reset, delay, get_o, pause);

	assign empty_o = pf_empty | pause;
endmodule

`endif  /* DISPLAY_DCS_FILTER_V */
