/*
 * Video Test Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef VIDEO_TEST_V
`define VIDEO_TEST_V  1

`include "video/control.v"

module video_test #(
	parameter HDE = 639, HSS = 687, HSE = 719, HE = 799,
	parameter VDE = 479, VSS = 482, VSE = 486, VE = 493
)(
	input clock, input reset,
	output reg [7:0] r, output reg [7:0] g, output reg [7:0] b,
	output reg de = 0, output reg hsync = 0, output reg vsync = 0
);
	localparam HW = $clog2 (HE), VW = $clog2 (VE);

	/* generate control signals */

	wire [HW-1:0] x;
	wire [VW-1:0] y;
	wire hde, vde, vc_hsync, vc_vsync;

	video_control #(HDE, HSS, HSE, HE, VDE, VSS, VSE, VE)
		vc (clock, reset, x, y, hde, vde, vc_hsync, vc_vsync);

	/* generate pattern **/

	wire [23:0] h, v, m;

	assign h = (x[4:0] < 21) ? 24'h105003 :
		   (x[4:0] < 22) ? 24'hE03010 :
		   (x[4:0] < 31) ? 24'h703005 : 24'hE03010;

	assign v = (y[4:0] < 21) ? 24'h105003 :
		   (y[4:0] < 22) ? 24'hE03010 :
		   (y[4:0] < 31) ? 24'h703005 : 24'hE03010;

	assign m = h | v;

	always @(posedge clock) begin
		r     <= m[23:16];
		g     <= m[15:8];
		b     <= m[7:0];
		de    <= hde & vde;
		hsync <= vc_hsync;
		vsync <= vc_vsync;
	end
endmodule

`endif  /* VIDEO_TEST_V */
