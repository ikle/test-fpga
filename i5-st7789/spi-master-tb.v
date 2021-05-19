/*
 * SPI Master Testbench
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "spi-master.v"

module hello_rom (
	input reset,
	output reg [7:0] out, input get, output empty
);
	localparam N = 7;
	localparam W = $clog2 (N + 1);

	wire [7:0] m[N-1:0];

	assign  m[0] = 8'h48;
	assign  m[1] = 8'h65;
	assign  m[2] = 8'h6C;
	assign  m[3] = 8'h6C;
	assign  m[4] = 8'h6F;
	assign  m[5] = 8'h0D;
	assign  m[6] = 8'h0A;

	reg [W-1:0] index;

	assign empty = ~(index < N);

	always @(posedge get) # 1
		out <= m[index];

	always @(posedge reset, negedge get) #1
		if (reset)
			index <= 0;
		else
		if (!empty)
			index <= index + 1;
endmodule

module tb;
	reg reset, clock = 0, full = 0;

	initial begin
		# 10	reset <= 1;
		# 20	reset <= 0;
		# 397	full  <= 1;
		# 50	full  <= 0;
		# 223	$finish;
	end

	always	# 2.5	clock = ~clock;

	wire [7:0] in, out;
	wire get, empty, put;
	wire spi_cs_n, spi_clock, spi_mosi, spi_miso;

	hello_rom  r0 (reset, in, get, empty);
	spi_master s0 (reset, clock, in, get, empty, out, put, full,
		       spi_cs_n, spi_clock, spi_mosi, spi_miso);

	assign spi_miso = spi_mosi;  /* echo back */

	initial begin
		$dumpfile ("spi-master.vcd");
		$dumpvars ();
	end
endmodule
