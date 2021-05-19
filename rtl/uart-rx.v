/*
 * UART RX Module
 *
 * Copyright (c) 2018-2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef UART_RX_V
`define UART_RX_V  1

`include "clock.v"
`include "fifo.v"

/*
 * UART receiver
 */
module uart_rx #(
	parameter DIV = 16
)(
	input reset, input clock,
	output rts, input rx,
	output reg [7:0] out, output reg put
);
	localparam START = 9;
	localparam STOP  = 8;
	localparam ERROR = 10;

	wire rx_value, rx_lock, next;
	reg [3:0] state;

	filter #(DIV/2)      f0 (reset, clock, rx, rx_value, rx_lock);
	alarm  #(DIV, DIV/2) a0 (rx_lock, ~clock, next);

	/*
	 * TODO: Wait at least 9 ones to be sure the framing is correct on reset
	 */
	always @(posedge reset, posedge clock) #1
		if (reset)
			state <= ERROR;
		else
		if (next)
		case (state)
		START:	if (~rx_value)	state <= 0;
		0:	state <= 1;
		1:	state <= 2;
		2:	state <= 3;
		3:	state <= 4;
		4:	state <= 5;
		5:	state <= 6;
		6:	state <= 7;
		7:	state <= STOP;
		STOP:	state <= rx_value ? START : ERROR;
		default:
			if (rx_value)	state <= START;
		endcase

	assign rts = ~(state < ERROR);

	always @(negedge clock) #1
		if (next & state < 8)
			out <= {rx_value, out[7:1]};

	always @(posedge reset, negedge clock) #1
		if (reset)
			put <= 0;
		else
			put <= (next & state == STOP & rx_value);
endmodule

/*
 * UART receiver with FIFO buffer
 */
module uart_rx_fifo #(
	parameter DIV = 16, ORDER = 4
)(
	input reset, input clock,
	output rts, input rx,
	output [7:0] out, input get, output empty
);
	wire [7:0] data;
	wire rts_i, put, full;

	uart_rx #(DIV)   u0 (reset, clock, rts_i, rx, data, put);
	fifo #(8, ORDER) f0 (reset, data, put, full, out, get, empty);

	assign rts = rts_i | full;  /* request to send, active low */
endmodule

`endif  /* UART_RX_V */
