/*
 * SPI LCD Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef SPI_LCD_V
`define SPI_LCD_V  1

`include "fifo.v"
`include "spi-master.v"

module spi_lcd (
	input reset, input clock,
	input dc, input [7:0] in, input put, output full,
	output LCD_reset_n, output LCD_clock, output LCD_cs_n,
	output LCD_dc, output LCD_mosi, input LCD_miso
);
	wire [8:0] spi_in;
	wire [7:0] spi_out;
	wire spi_get, spi_empty, spi_put, spi_full;

	assign spi_full = 0;

	fifo #(9, 4) f0 (reset, {dc, in}, put, full,
			 spi_in, spi_get, spi_empty);

	spi_master s0 (reset, clock, spi_in[7:0], spi_get, spi_empty,
		       spi_out, spi_put, spi_full,
		       LCD_cs_n, LCD_clock, LCD_mosi, LCD_miso);

	assign LCD_reset_n = ~reset;
	assign LCD_dc = spi_in[8];
endmodule

`endif  /* SPI_LCD_V */
