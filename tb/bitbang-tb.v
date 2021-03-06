/*
 * Bit-Bang Testbench
 *
 * Copyright (c) 2018-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "bitbang/spi-master.v"
`include "mem/rom-seq-0.v"
`include "timer/strobe.v"

module tb;
	reg clock = 0, reset;

	always	# 2.5	clock = ~clock;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 1825	$finish;
	end

	wire step;

	strobe #(2) t0 (clock, 2'h3, reset, 2'h0, 1'b0, step);

	wire [7:0] in, out;
	wire empty, get, put;
	wire spi_cs_n, spi_clock, spi_mosi, spi_miso;

	rom_seq_0 #(8, "hello.hex", 7) rom (clock, reset, in, get, empty);

	spi_master #(8) spi (clock, reset, step, in, get, empty, out, put,
			     spi_cs_n, spi_clock, spi_mosi, spi_miso);

	assign spi_miso = spi_mosi;  /* echo back */

	initial begin
		$dumpfile ("bitbang.vcd");
		$dumpvars ();
	end
endmodule
