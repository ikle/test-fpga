LIBRARY	= $(CURDIR)/../../rtl

TARGET	+= cix.vcd redux.vcd

.PHONY: all clean prog

all: $(TARGET)

# VCD from Verilog testbench

VC	?= iverilog -gspecify -I$(LIBRARY)

%.vvp: %-tb.v
	$(VC) $(VFLAGS) -o $@ $<

%.vcd: %.vvp
	vvp $<

clean:
	$(RM) *.vcd *.vvp

redux.vcd: VFLAGS += -g2005-sv
