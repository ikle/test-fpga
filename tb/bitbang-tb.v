/*
 * Bit-Bang Testbench
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "bitbang/spi-master.v"
`include "hello-rom.v"

module tb;
	reg reset, clock = 0;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 625	$finish;
	end

	always	# 2.5	clock = ~clock;

	wire [7:0] in, out;
	wire empty, get, put;
	wire spi_cs_n, spi_clock, spi_mosi, spi_miso;

	hello_rom rom (clock, reset, get, in, empty);

	spi_master #(8) spi (reset, clock, in, get, empty, out, put,
			     spi_cs_n, spi_clock, spi_mosi, spi_miso);

	assign spi_miso = spi_mosi;  /* echo back */

	initial begin
		$dumpfile ("bitbang.vcd");
		$dumpvars ();
	end
endmodule
