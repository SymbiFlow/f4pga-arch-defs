include $(COMMON_MK_DIR)/files.mk
include $(COMMON_MK_DIR)/func.mk

# Generate other files

# ------------------
$(call include_type_all,mux) 	# Run Muxgen first
$(call include_type_all,N)	# Then ntemplates
$(call include_type_all,v2x)	# Then Verilog -> XML

# Artix-7 specific
$(call include_type_all,xray)
