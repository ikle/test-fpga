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
	output reg [8:0] out, input get, output empty
);
	localparam N = 7;
	localparam W = $clog2 (N + 1);

	wire [8:0] m[N-1:0];

	assign  m[0] = 9'h048;
	assign  m[1] = 9'h165;
	assign  m[2] = 9'h16C;
	assign  m[3] = 9'h06C;
	assign  m[4] = 9'h16F;
	assign  m[5] = 9'h00D;
	assign  m[6] = 9'h00A;

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

	wire [8:0] in;
	wire [7:0] out;
	wire get, empty, put;
	wire spi_cs_n, spi_clock, spi_dc, spi_mosi, spi_miso;

	hello_rom  r0 (reset, in, get, empty);
	spi_master s0 (reset, clock,
		       in[8], in[7:0], get, empty,
		       out, put, full,
		       spi_cs_n, spi_clock, spi_dc, spi_mosi, spi_miso);

	assign spi_miso = spi_mosi;  /* echo back */

	initial begin
		$dumpfile ("spi-master.vcd");
		$dumpvars ();
	end
endmodule
