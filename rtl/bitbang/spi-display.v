/*
 * SPI Display Bit-Bang Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef BITBANG_SPI_DISPLAY_V
`define BITBANG_SPI_DISPLAY_V  1

`include "bitbang/spi-master.v"

module spi_display #(
	parameter W = 8
)(
	input clock, input reset, input step,
	input dc, input [W-1:0] in, output get, input empty,
	output spi_cs_n, output spi_clock, output spi_dc, output spi_mosi
);
	localparam BW = W * 2;

	spi_master #(W) spi (clock, reset, step, in, get, empty, , ,
			     spi_cs_n, spi_clock, spi_mosi, );

	wire [BW-1:0] di = {BW {dc}};

	bitbang #(BW) d (clock, reset, step, di, , empty, , , 1'b0, spi_dc);
endmodule

`endif  /* BITBANG_SPI_DISPLAY_V */
