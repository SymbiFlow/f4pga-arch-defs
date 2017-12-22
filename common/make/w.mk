SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

WPY = $(shell realpath $(SELF_DIR)/../../utils/w.py)

NAMES := $(foreach W,A B C D,$(NAME_PREFIX)$(W)$(NAME_SUFFIX))

PB_TYPE_XML := $(foreach N,$(NAMES),pb_type.$(N).xml)
SIM_V := $(foreach N,$(NAMES),sim.$(N).v)

pb_type.%.xml: pb_type.xml $(WPY)
	$(WPY) $$(echo $@ | sed -e's/^.*$(NAME_PREFIX)\(.\)$(NAME_SUFFIX).*$$/\1/') $@

sim.%.v: sim.v $(WPY)
	$(WPY) $$(echo $@ | sed -e's/^.*$(NAME_PREFIX)\(.\)$(NAME_SUFFIX).*$$/\1/') $@

clean:
	rm -f pb_type.*.xml
	rm -f sim.*.v

all: $(PB_TYPE_XML) $(SIM_V)
