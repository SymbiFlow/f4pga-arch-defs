$(INC_DIR)_FILES_OUTPUT_MUX := \
	$(INC_DIR)/$(MUX_OUTFILE).model.xml \
	$(INC_DIR)/$(MUX_OUTFILE).pb_type.xml \
	$(INC_DIR)/$(MUX_OUTFILE).sim.v

include $(TOP_DIR)/make/mux-args.mk

$($(INC_DIR)_FILES_OUTPUT_MUX): INC_DIR := $(INC_DIR)
$($(INC_DIR)_FILES_OUTPUT_MUX): MUX_GEN_ARGS := $(MUX_GEN_ARGS)

$($(INC_DIR)_FILES_OUTPUT_MUX): $(THIS_FILE)

$($(INC_DIR)_FILES_OUTPUT_MUX):
	@cd $(INC_DIR); $(MUX_GEN_CMD) $(MUX_GEN_ARGS)

OUTPUTS += $($(INC_DIR)_FILES_OUTPUT_MUX)

undefine MUX_NAME
undefine MUX_OUTFILE
undefine MUX_GEN_ARGS
