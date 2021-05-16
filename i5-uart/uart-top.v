/*
 * UART TX Test Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`include "reset.v"
`include "uart-pll.v"
`include "uart-rx.v"
`include "uart-tx.v"

/*
 * Clock divisor by power of two
 */
module clock_div_pow2 #(
	parameter ORDER = 10
)(
	input reset, input clock_i, output clock_o
);
	reg [ORDER-1:0] counter;

	always @(posedge clock_i)
		if (reset)
			counter <= 0;
		else
			counter <= counter + 1;

	assign clock_o = counter[ORDER-1];
endmodule

/*
 * Hello ROM
 */
module hello_rom (
	input reset,
	output reg [7:0] out, (* noglobal *) input get, output empty
);
	localparam N = 7;
	localparam W = $clog2 (N + 1);

	wire [7:0] m[N-1:0];

	assign 	m[0] = 8'h48;
	assign	m[1] = 8'h65;
	assign	m[2] = 8'h6C;
	assign	m[3] = 8'h6C;
	assign	m[4] = 8'h6F;
	assign	m[5] = 8'h0D;
	assign	m[6] = 8'h0A;

	reg [W-1:0] index;

	assign empty = ~(index < N);

	always @(posedge get)
		out <= m[index];

	always @(posedge reset, negedge get)
		if (reset)
			index <= 0;
		else
		if (!empty)
			index <= index + 1;
endmodule

/*
 * UART TX test bench
 */
module uart_tb (
	input reset, input uart_clock_16, input uart_clock,
	input rx, output tx
);
	wire [7:0] out, out_a, out_b;
	wire empty, empty_a, empty_b, get, get_a, get_b, rts;
	wire cts = 0;

	assign out   = empty_a ? out_b : out_a;
	assign empty = empty_a & empty_b;

	assign get_a = ~empty_a & get;
	assign get_b =  empty_a & get;

	hello_rom    r0  (reset, out_a, get_a, empty_a);
	uart_rx_fifo f0  (reset, uart_clock_16, rts, rx, out_b, get_b, empty_b);
	uart_tx      tx0 (reset, uart_clock, out, get, empty, cts, tx);
endmodule

/*
 * Top design module
 */
module top (
	input osc, input UART_rx, output UART_tx, output led_n
);
	wire reset_s;

	reset_gen r0 (0, osc, reset_s);

	wire uart_clock_256, uart_clock_ok;

	uart_pll pll0 (0, osc, uart_clock_256, uart_clock_ok);

	wire uart_clock_16, uart_clock;

	clock_div_pow2 #(4) c0 (reset_s, uart_clock_256, uart_clock_16);
	clock_div_pow2 #(4) c1 (reset_s, uart_clock_16,  uart_clock);

	uart_tb u0 (reset_s, uart_clock_16, uart_clock,
		    UART_rx, UART_tx);

	clock_div_pow2 #(16) c2 (reset_s, uart_clock, led_n);
endmodule
