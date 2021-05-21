/*
 * SPI Master Module
 *
 * Copyright (c) 2021 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

`ifndef SPI_MASTER_V
`define SPI_MASTER_V  1

module spi_master #(
	parameter W = 8
)(
	input reset, input clock,
	input dc, input [W-1:0] in, output reg get, input empty,
	output reg [W-1:0] out, output reg put, input full,
	output spi_cs_n, output reg spi_clock,
	output spi_dc, output spi_mosi, input spi_miso
);
	localparam STOP = {1'b1, {W {1'b0}}};

	reg avail;
	reg [W:0] data;
	reg [W*2:0] state;

	wire stop = (state[W:0]   == STOP);
	wire last = (state[W-1:0] == STOP >> 1);

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
				data  <= {dc, in};
				avail <= 1;
			end

			if (stop & avail) begin
				state <= {{W {data[W]}}, data[W-1:0], 1'b1};
				avail <= 0;
			end

			if (!full) begin
				if (!stop)
					spi_clock <= ~spi_clock;

				if (!stop & spi_clock) begin
					if (last & avail) begin
						state <= {{W {data[W]}}, data[W-1:0], 1'b1};
						avail <= 0;
					end
					else
						state <= state << 1;
				end

				put <= spi_clock & last;

				if (!stop & !spi_clock)
					out <= {out[W-2:0], spi_miso};
			end
		end

	assign spi_cs_n = stop;
	assign spi_dc   = !stop & state[W*2];
	assign spi_mosi = !stop & state[W];
endmodule

`endif  /* SPI_MASTER_V */
