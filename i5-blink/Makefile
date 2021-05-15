STREAM	= blink.bit
TARGET	= $(STREAM)

ARCH	= ecp5
CHIP	= --25k --speed 6 --package CABGA381
BOARD	= --lpf blink.lpf
DESIGN	= --freq 50 -l nextpnr.log

.PHONY: all clean prog

all: $(TARGET)

# VCD from Verilog testbench

VC ?= iverilog -gspecify

%.vvp: %-tb.v
	$(VC) $(VFLAGS) -o $@ $<

%.vcd: %.vvp
	vvp $<

# bit stream from Verilog

%.yosys: %-top.v
	yosys -QT -p "synth_$(ARCH) -top top -abc9 -json $@" $<

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
