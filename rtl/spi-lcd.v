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
`include "timeout.v"

module spi_lcd_wait #(
	parameter FREQ = 25_000_000, DELAY = 120
)(
	input reset, input clock,
	input [8:0] in, input get, output ready_n
);
	localparam SWRESET = 9'h001;
	localparam SLPIN   = 9'h010;
	localparam SLPOUT  = 9'h011;

	localparam TIMEOUT = DELAY * (FREQ / 1000);  /* DELAY ms */
	localparam TW      = $clog2 (TIMEOUT);

	wire [TW-1:0] count;
	wire power_cmd;

	assign count     = TIMEOUT;
	assign power_cmd = data == SWRESET | data == SLPIN | data == SLPOUT;

	reg [8:0] data;

	always @(posedge clock) #1
		if (reset | power_cmd)
			data <= 0;
		else
		if (get)		// todo: get_s + in_s?
			data <= in;

	timeout #(TW) t0 (reset, clock, count, power_cmd, ready_n);
endmodule

module spi_lcd #(
	parameter FREQ = 25_000_000, DELAY = 120
)(
	input reset, input clock,
	input dc, input [7:0] in, input put, output full,
	output LCD_reset_n, output LCD_clock, output LCD_cs_n,
	output LCD_dc, output LCD_mosi, input LCD_miso
);
	wire [8:0] spi_in;
	wire [7:0] spi_out;
	wire spi_get, spi_empty, spi_put, spi_full, ready_n;

	assign spi_full = 0;

	fifo #(9, 4) f0 (reset, {dc, in}, put, full,
			 spi_in, spi_get, spi_empty);

	spi_lcd_wait #(FREQ, DELAY) w0 (reset, clock, spi_in, spi_get, ready_n);

	spi_master s0 (reset, clock, spi_in[7:0], spi_get, spi_empty | ready_n,
		       spi_out, spi_put, spi_full,
		       LCD_cs_n, LCD_clock, LCD_mosi, LCD_miso);

	assign LCD_reset_n = ~reset;
	assign LCD_dc = spi_in[8];
endmodule

`endif  /* SPI_LCD_V */
