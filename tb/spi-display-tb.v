/*
 * SPI Display Testbench
 *
 * Copyright (c) 2018-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "bitbang/spi-display.v"
`include "display/dcs-filter.v"
`include "mem/rom-seq-0.v"
`include "timer/strobe.v"

module tb;
	reg clock = 0, reset;

	always	# 2.5	clock = ~clock;

	initial begin
		# 10	reset <= 1;
		# 13	reset <= 0;
		# 5500	$finish;
	end

	wire step;

	strobe #(2) t0 (clock, 2'h3, reset, 2'h0, 1'b0, step);

	wire [8:0] rom_in;
	wire [7:0] dcs_in;
	wire rom_get, rom_empty, dcs_dc, dcs_get, dcs_empty;
	wire spi_cs_n, spi_clock, spi_dc, spi_mosi;

	rom_seq_0 #(9, "spi-display.hex", 20)
		rom (clock, reset, rom_in, rom_get, rom_empty);

	dcs_filter #(8, 8_000, 10)
		dcs (clock, reset,
		     rom_in[8], rom_in[7:0], rom_get, rom_empty,
		     dcs_dc, dcs_in, dcs_get, dcs_empty);

	spi_display
		display (clock, reset, step,
			 dcs_dc, dcs_in, dcs_get, dcs_empty,
			 spi_cs_n, spi_clock, spi_dc, spi_mosi);

	initial begin
		$dumpfile ("spi-display.vcd");
		$dumpvars ();
	end
endmodule
