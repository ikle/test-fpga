/*
 * Serial Align Module: count and remove leading zeros
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef LOGIC_ALIGN_S_V
`define LOGIC_ALIGN_S_V  1

module align_si #(
	parameter ORDER = 3,
	parameter W = HW
)(
	input [W-1:0] in, output [W-1:0] out, output [ORDER:0] count
);
	localparam HW = 2 ** ORDER;
	localparam LW = W - HW;

	generate
		if (ORDER == 0) begin
			wire zero = ~in[W-1];

			assign out   = zero ? (in << 1) : in;
			assign count = zero;
		end
		else begin
			wire [W-1:0] o;
			wire [ORDER-1:0] c;

			wire zero = ~(|in[W-1:LW]);

			assign o = zero ? (in << HW) : in;

			align_si #(ORDER-1, W) l (o, out, c);

			assign count = {zero, c};
		end
	endgenerate
endmodule

/*
 * count = clz (top n bits of in)
 * out   = in << count
 *
 * Complexity: O(n) where n = 2^order = HW
 */
module align_s #(
	parameter ORDER = 3,
	parameter W = HW
)(
	input [W-1:0] in, output [W-1:0] out, output [ORDER:0] count
);
	localparam HW = 2 ** ORDER;
	localparam LW = W - HW;

	wire [W-1:0] o;
	wire [ORDER-1:0] c;

	align_si #(ORDER-1, W) l (in, o, c);

	wire zero = ~(|in[W-1:LW]);

	assign out   = zero ? (in << HW) : o;
	assign count = {zero, {ORDER {~zero}} & c};
endmodule

`endif  /* LOGIC_ALIGN_S_V */
