/*
 * Bit Count Operation Module
 *
 * Copyright (c) 2021-2024 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef ALU_CIX_V
`define ALU_CIX_V  1

`define CIX_CTO		3'b010		/* count trailing ones		*/
`define CIX_CTZ		3'b011		/* count trailing zeroes	*/
`define CIX_CLO		3'b100		/* count leading ones		*/
`define CIX_CLZ		3'b101		/* count leading zeroes		*/
`define CIX_PCNT	3'b110		/* population count		*/
`define CIX_ZCNT	3'b111		/* count zeroes			*/

module cix #(
	parameter ORDER = 3
)(
	input [2:0] op, input [W-1:0] in, output [ORDER:0] out, output all
);
	localparam W = 2 ** ORDER;

	wire inv = op[0];	/* invert input			*/
	wire bot = op[1];	/* count low half always	*/
	wire top = op[2];	/* count top half always	*/

	generate
		if (ORDER == 0) begin
			assign out = in ^ inv;
			assign all = in ^ inv;
		end
		else begin
			wire [ORDER-1:0] lo, ho, a, b;
			wire la, ha;

			cix #(ORDER-1) l (op, in[W/2-1:0], lo, la);
			cix #(ORDER-1) h (op, in[W-1:W/2], ho, ha);

			assign a = (ha | bot) ? lo : 0;
			assign b = (la | top) ? ho : 0;

			assign out = a  + b;
			assign all = la & ha;
		end
	endgenerate
endmodule

`endif  /* ALU_CIX_V */
