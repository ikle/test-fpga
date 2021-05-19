/*
 * UART TX Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
*/

`ifndef UART_TX_V
`define UART_TX_V  1

`include "clock.v"
`include "fifo.v"

/*
 * UART transmitter
 */
module uart_tx (
	input reset, input clock,
	input [7:0] in, output reg get, input empty,
	input cts, output tx
);
	localparam STOP = 10'b1;

	wire cts_s;
	reg [9:0] state;
	wire stop = (state == STOP);

	sync s0 (clock, cts, cts_s);

	always @(posedge reset, posedge clock) #1
		if (reset)
			state <= STOP;
		else begin
			if (stop & get)
				state <= {1'b1, in, 1'b0};

			if (!stop)
				state <= state >> 1;
		end

	always @(posedge reset, negedge clock) #1
		if (reset)
			get <= 0;
		else
			get <= (stop & ~cts_s & !empty);

	assign tx = state[0];
endmodule

/*
 * UART transmitter with FIFO buffer
 */
module uart_tx_fifo #(
	parameter ORDER = 4
)(
	input reset, input clock,
	input [7:0] in, input put, output full,
	input cts, output tx
);
	wire [7:0] out;
	wire get, empty;

	fifo #(8, ORDER) f0 (reset, in, put, full, out, get, empty);
	uart_tx          u0 (reset, clock, out, get, empty, cts, tx);
endmodule

`endif  /* UART_TX_V */
