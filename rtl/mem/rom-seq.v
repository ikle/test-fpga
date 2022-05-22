/*
 * Sequental ROM Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef MEM_ROM_SEQ_V
`define MEM_ROM_SEQ_V  1

module rom_seq #(
	parameter W = 8, FILE = "", SIZE = 256
)(
	input clock, input reset,
	input req, output valid, output [W-1:0] out
);
	localparam AW = $clog2 (SIZE + 1);

	reg [AW-1:0] index = 0;
	reg [W-1:0] m[0:SIZE-1];

	initial if (FILE != "")
		$readmemh (FILE, m);

	assign out   = m[index];
	assign valid = (index < SIZE);

	always @(posedge clock)
		if (reset)
			index <= 0;
		else
		if (req & valid)
			index <= index + 1;
endmodule

`endif  /* MEM_ROM_SEQ_V */
