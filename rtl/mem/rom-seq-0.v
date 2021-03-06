/*
 * Sequental ROM Module
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef MEM_ROM_SEQ_0_V
`define MEM_ROM_SEQ_0_V  1

module rom_seq_0 #(
	parameter W = 8, FILE = "", SIZE = 256
)(
	input clock, input reset,
	output reg [W-1:0] out, input get, output empty
);
	localparam AW = $clog2 (SIZE + 1);

	reg [AW-1:0] index;
	reg [W-1:0] m[0:SIZE-1];

	initial if (FILE != "")
		$readmemh (FILE, m);

	assign empty = (index == SIZE);

	always @(posedge clock)
		if (reset)
			index <= 0;
		else
		if (get & !empty) begin
			out   <= m[index];
			index <= index + 1;
		end
endmodule

`endif  /* MEM_ROM_SEQ_0_V */
