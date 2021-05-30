/*
 * Video Control Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef VIDEO_CONTROL_V
`define VIDEO_CONTROL_V  1

module video_control #(
	parameter HDE = 639, HSS = 656, HSE = 751, HE = 799,
	parameter VDE = 479, VSS = 490, VSE = 491, VE = 524
)(
	input clock, input reset,
	output reg [HW-1:0] x = 0, output reg [VW-1:0] y = 0,
	output reg hde = 1,   output reg vde = 1,
	output reg hsync = 0, output reg vsync = 0
);
	localparam HW = $clog2 (HE), VW = $clog2 (VE);

	always @(posedge clock)
		if (reset) begin
			x	<= 0;
			hde	<= 1;
			hsync	<= 0;
		end
		else begin
			x	<= (x == HE)  ? 0 : x + 1;
			hde	<= (x == HDE) ? 0 : (x == HE)  ? 1 : hde;
			hsync	<= (x == HSS) ? 1 : (x == HSE) ? 0 : hsync;
		end

	always @(posedge clock)
		if (reset) begin
			y	<= 0;
			vde	<= 1;
			vsync	<= 0;
		end
		else if (x == HE) begin
			y	<= (y == VE)  ? 0 : y + 1;
			vde	<= (y == VDE) ? 0 : (y == VE)  ? 1 : vde;
			vsync	<= (y == VSS) ? 1 : (y == VSE) ? 0 : vsync;
		end
endmodule

`endif  /* VIDEO_CONTROL_V */
