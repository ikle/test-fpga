/*
 * SPI Master Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef SPI_MASTER_V
`define SPI_MASTER_V  1

module spi_master (
	input reset, input clock,
	input [7:0] in, output reg get, input empty,
	output reg [7:0] out, output reg put, input full,
	output spi_cs_n, output reg spi_clock, output spi_mosi, input spi_miso
);
	localparam STOP = 9'b1_0000_0000;

	reg avail;
	reg [7:0] data;
	reg [8:0] state;

	wire stop = (state[8:0] == STOP);
	wire last = (state[7:0] == STOP >> 1);

	always @(posedge reset, negedge clock) #1
		if (reset)
			get <= 0;
		else
			get <= !avail & !empty;

	always @(posedge reset or posedge clock) #1
		if (reset) begin
			avail     <= 0;
			state     <= STOP;
			spi_clock <= 0;
			put       <= 0;
		end
		else begin
			if (get) begin
				data  <= in;
				avail <= 1;
			end

			if (stop & avail) begin
				state <= {data[7:0], 1'b1};
				avail <= 0;
			end

			if (!full) begin
				if (!stop)
					spi_clock <= ~spi_clock;

				if (!stop & spi_clock) begin
					if (last & avail) begin
						state <= {data[7:0], 1'b1};
						avail <= 0;
					end
					else
						state <= state << 1;
				end

				put <= spi_clock & last;

				if (!stop & !spi_clock)
					out <= {out[6:0], spi_miso};
			end
		end

	assign spi_cs_n = stop;
	assign spi_mosi = !stop & state[8];
endmodule

`endif  /* SPI_MASTER_V */
