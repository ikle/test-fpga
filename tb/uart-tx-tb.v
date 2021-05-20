/*
 * UART TX Testbench Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`timescale 1ns / 100ps

`include "uart-tx.v"

module hello_rom (
	input reset,
	output reg [7:0] out, input get, output empty
);
	localparam N = 7;
	localparam W = $clog2 (N + 1);

`ifndef NUMS
	wire [7:0] m[N-1:0];

	assign  m[0] = 8'h48;
	assign  m[1] = 8'h65;
	assign  m[2] = 8'h6C;
	assign  m[3] = 8'h6C;
	assign  m[4] = 8'h6F;
	assign  m[5] = 8'h0D;
	assign  m[6] = 8'h0A;
`endif
	reg [W-1:0] index;

	assign empty = ~(index < N);

	always @(posedge get) # 1
`ifndef NUMS
		out <= m[index];
`else
		out <= (8'h30 + index);
`endif
	always @(posedge reset, negedge get) # 1
		if (reset)
			index <= 0;
		else
		if (!empty)
			index <= index + 1;
endmodule

module tb;
	reg reset, sys_clock = 0, uart_clock = 0;
	reg [7:0] in;
	reg put = 0, cts = 0;
	wire full, uart_tx;

	initial begin
		# 25	reset <= 1;
		# 100	reset <= 0;
		# 11000	$finish;
	end

	always
		# 2.5	sys_clock = ~sys_clock;

	always
		# 71	uart_clock = ~uart_clock;

	initial begin
		# 200	in  <= 8'h48;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h65;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h6C;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h6C;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h6F;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h0D;
		# 25	put <= 1;
		# 25	put <= 0;
		# 25	in  <= 8'h0A;
		# 25	put <= 1;
		# 25	put <= 0;
	end

	uart_tx_fifo u0 (reset, uart_clock, in, put, full, cts, uart_tx);

	wire [7:0] out, out_a;
	wire empty, get, empty_a, get_a, tx;

	assign out   = out_a;
	assign empty = empty_a;

	assign get_a = get & !empty;

	hello_rom r0  (reset, out_a, get_a, empty_a);
	uart_tx   tx0 (reset, uart_clock, out, get, empty, cts, tx);

	specify
		$setup (tx0.state, posedge tx0.clock, 0.5);
	endspecify

	initial begin
		$dumpfile ("uart-tx.vcd");
		$dumpvars;
	end
endmodule
