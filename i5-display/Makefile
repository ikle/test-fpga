LIBRARY	= $(CURDIR)/../rtl
STREAM	= lcd.bit
TARGET	= machaon.hex $(STREAM)

ARCH	= ecp5
CHIP	= --25k --speed 6 --package CABGA381
BOARD	= --lpf lcd.lpf
DESIGN	= --freq 50 -l nextpnr.log

.PHONY: all clean prog

all: $(TARGET)

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
	$(RM) $(TARGET) *.yosys *.trellis nextpnr.log

prog: $(STREAM)
	ecpdap -f 10000 program $<

flash: $(STREAM)
	ecpdap -f 10000 flash write $<

lcd.bit: machaon.hex

machaon.hex: lcd-init.hex machaon.jpg
	sh image-gen.sh $^ $@
