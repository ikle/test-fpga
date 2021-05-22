LIBRARY	= $(CURDIR)/../rtl

TARGET	+= bitbang.vcd crossbar.vcd
TARGET	+= spi-master.vcd timeout.vcd uart-rx.vcd uart-tx.vcd

.PHONY: all clean prog

all: $(TARGET)

# VCD from Verilog testbench

VC ?= iverilog -gspecify -I$(LIBRARY)

%.vvp: %-tb.v
	$(VC) $(VFLAGS) -o $@ $<

%.vcd: %.vvp
	vvp $<

clean:
	$(RM) *.vcd *.vvp

bitbang.vcd: hello-rom.v
