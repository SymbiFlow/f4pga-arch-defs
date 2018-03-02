ifeq (,$(INC_FILES_MK))
INC_FILES_MK := 1

# FIXME: Include this exclude from a file or something.
#-------------------------
EXCLUDE :=

# Exclude special directories
EXCLUDE += docs tests third_party

# Exclude anything in a special "unused" directories
EXCLUDE += unused

# Exclude the .git directory
EXCLUDE += .git

# Exclude anything in a special directories
EXCLUDE += make common library

# Exclude the dependency files
EXCLUDE += \.d$$
EXCLUDE += \.dmk

# Exclude Python cache files
EXCLUDE += __pycache__ \.pyc \.pyo

# Exclude the .git directory
EXCLUDE += /\.

# Exclude merged output
EXCLUDE += \.merged.xml

#-------------------------

EXCLUDE_FILTER := grep -v "$$(echo '\($(strip $(EXCLUDE))\)' | sed -e's- -\\|-g')"
ifeq (1,$(V))
$(info EXCLUDE_FILTER: $(EXCLUDE_FILTER))
endif

FILES_EXISTING := $(sort $(abspath $(shell find $(TOP_DIR) -type f | $(EXCLUDE_FILTER))))

# Tools which generate files should append their files to this variable.
FILES_GENERATED :=
find_generated_files = $(call find_files_in,$(1),$(FILES_GENERATED))

# Tools which have template files should append their files to this variable
FILES_TEMPLATES :=

# Find files in a list.
find_files_in = $(sort $(filter $(subst *,%,$(1)),$(2)))

# Find files, including those files which are generated by other stages but
# might not exist yet.
FILES_POSSIBLE=$(FILES_EXISTING) $(sort $(abspath $(FILES_GENERATED)))
find_files = $(call find_files_in,$(1),$(FILES_POSSIBLE))

# Find only files which are not generated.
FILES_NON_GENERATED=$(filter-out $(FILES_GENERATED),$(FILES_EXISTING))
find_nongenerated_files = $(call find_files_in,$(1),$(FILES_NON_GENERATED))

# Find all files, except those being used as templates for generating other
# files.
FILES_NON_TEMPLATES=$(filter-out $(sort $(abspath $(FILES_TEMPLATES))),$(FILES_POSSIBLE))
find_nontemplate_files = $(call find_files_in,$(1),$(FILES_NON_TEMPLATES))

ifeq (1,$(V))
$(info Found $(words $(FILES_EXISTING)) files currently existing.)
endif

ifeq (0,$(words $(FILES_EXISTING)))
$(error Found no files! Check the exclude patterns!)
endif

endif
