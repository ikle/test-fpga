/*
 * Demultiplexer Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_DEMUX_V
`define LOGIC_DEMUX_V  1

module demux #(
	parameter W = 4, N = 13
)(
	input d, input [W-1:0] s, output [N-1:0] q
);
	assign q = {{N-1 {1'b0}}, d} << s;
endmodule

`endif  /* LOGIC_DEMUX_V */
