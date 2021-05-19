LIBRARY	= $(CURDIR)/../rtl
STREAM	= blink.bit
TARGET	= $(STREAM)

ARCH	= ecp5
CHIP	= --25k --speed 6 --package CABGA381
BOARD	= --lpf blink.lpf
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
	$(RM) *.sp *.vcd *.vvp *.yosys *.trellis *.bit nextpnr.log

prog: $(STREAM)
	ecpdap -f 10000 program $<

flash: $(STREAM)
	ecpdap -f 10000 flash write $<

uart.yosys:	reset.v clock.v
