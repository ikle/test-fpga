/*
 * SPI Master Bit-Bang Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef BITBANG_SPI_MASTER_V
`define BITBANG_SPI_MASTER_V  1

`include "bitbang.v"
`include "logic/unzip.v"
`include "logic/zip.v"

module spi_master #(
	parameter W = 8
)(
	input reset, input clock,
	input  [W-1:0] in,  output get, input empty,
	output [W-1:0] out, output put,
	/* input [1:0] mode, */
	output spi_cs_n, output spi_clock, output spi_mosi, input spi_miso
);
	localparam BW = W * 2;

	wire [BW-1:0] ai, bi, ci, do;

	bitbang #(BW) a (reset, clock, ai,    , empty,   ,    , 1'b1, spi_cs_n );
	bitbang #(BW) b (reset, clock, bi,    , empty,   ,    , 1'b0, spi_clock);
	bitbang #(BW) c (reset, clock, ci, get, empty,   ,    , 1'b0, spi_mosi );
	bitbang #(BW) d (reset, clock, do,    , empty, do, put, spi_miso,      );

	assign ai = {W {2'b00}};	/* cs_n active low */
	assign bi = {W {2'b01}};	/* clock mode 0    */

	zip   #(W) z0 (in, in, ci);	/* sample on both clock edges  */
	unzip #(W) z1 (do,   , out);	/* sample on active clock edge */
endmodule

`endif  /* BITBANG_SPI_MASTER_V */
