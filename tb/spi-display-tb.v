/*
 * SPI Display Testbench
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "bitbang/spi-display.v"
`include "mem/rom-seq.v"
`include "timer/strobe.v"

module tb;
	reg clock = 0, reset;

	always	# 2.5	clock = ~clock;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 5000	$finish;
	end

	wire step;

	strobe #(2) t0 (clock, 2'h3, reset, 2'h0, 1'b0, step);

	wire [8:0] in;
	wire empty, get;
	wire spi_cs_n, spi_clock, spi_dc, spi_mosi;

	rom_seq #(9, "spi-display.hex", 20) rom (clock, reset, in, get, empty);

	spi_display display (clock, reset, step, in[8], in[7:0], get, empty,
			     spi_cs_n, spi_clock, spi_dc, spi_mosi);

	initial begin
		$dumpfile ("spi-display.vcd");
		$dumpvars ();
	end
endmodule
