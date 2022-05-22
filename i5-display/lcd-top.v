/*
 * ST7789 240x240 SPI TFT LCD Test
 *
 * Copyright (c) 2021-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`include "bitbang/spi-display.v"
`include "display/dcs-filter.v"
`include "mem/rom-seq-0.v"
`include "reset.v"
`include "timer/strobe.v"

module top #(
	parameter FREQ = 25_000_000, DELAY = 120
)(
	input osc,
	output LCD_backlight,
	output LCD_reset_n, output LCD_cs_n,
	output LCD_clock, output LCD_dc, output LCD_mosi
);
	wire reset_s;

	reset_gen #(22) r0 (1'b0, osc, reset_s);

	wire step;

	strobe #(2) t0 (osc, 2'h3, reset_s, 2'h0, 1'b0, step);

	wire [8:0] rom_in;
	wire [7:0] dcs_in;
	wire rom_get, rom_empty, dcs_dc, dcs_get, dcs_empty;
	wire LCD_cs_n, LCD_clock, LCD_dc, LCD_mosi;

	rom_seq_0 #(9, "machaon.hex", 20 + 720 * 10)
		rom (osc, reset_s, rom_in, rom_get, rom_empty);

	dcs_filter #(8, FREQ, DELAY)
		dcs (osc, reset_s,
		     rom_in[8], rom_in[7:0], rom_get, rom_empty,
		     dcs_dc, dcs_in, dcs_get, dcs_empty);

	spi_display
		display (osc, reset_s, step,
			 dcs_dc, dcs_in, dcs_get, dcs_empty,
			 LCD_cs_n, LCD_clock, LCD_dc, LCD_mosi);

	assign LCD_backlight = 1;
	assign LCD_reset_n   = !reset_s;
endmodule
