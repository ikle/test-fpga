LIBRARY	= $(CURDIR)/../rtl
STREAM	= uart.bit
TARGET	= crossbar.vcd uart-rx.vcd uart-tx.vcd $(STREAM)

ARCH	= ecp5
CHIP	= --25k --speed 6 --package CABGA381
BOARD	= --lpf uart.lpf
DESIGN	= --freq 50 -l nextpnr.log

.PHONY: all clean prog

all: $(TARGET)

# VCD from Verilog testbench

VC ?= iverilog -gspecify -I$(LIBRARY)

%.vvp: %-tb.v
	$(VC) $(VFLAGS) -o $@ $<

%.vcd: %.vvp
	vvp $<

# bit stream from Verilog

YPREFIX	= verilog_defaults -add -I$(LIBRARY);
YSUFFIX	= synth_$(ARCH) -top top -abc9

%.yosys: %-top.v
	yosys -QT -p "$(YPREFIX) read_verilog $<; $(YSUFFIX) -json $@"

%.trellis: %.yosys %.lpf
	nextpnr-$(ARCH) $(CHIP) $(BOARD) $(DESIGN) --json $< --textcfg $@

%.bit: %.trellis
	ecppack $< $@

clean:
	$(RM) *.sp *.vcd *.vvp *.yosys *.trellis *.bit nextpnr.log uart-pll.v

prog: $(STREAM)
	ecpdap -f 10000 program $<

flash: $(STREAM)
	ecpdap -f 10000 flash write $<

uart-pll.v:
	ecppll -i 25.0 -o 29.4912 --highres -f $@ \
	       -n uart_pll --clkin_name clock_i --clkout0_name clock_o \
	       --standby

crossbar.vvp: crossbar.v

uart-rx.vvp:	clock.v uart-rx.v
uart-tx.vvp:	clock.v uart-tx.v
uart.yosys:	uart-pll.v clock.v uart-rx.v uart-tx.v
