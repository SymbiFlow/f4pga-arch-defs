#!/bin/bash

source .travis/common.sh
set -e

$SPACER

start_section "symbiflow.all.1" "Running ${GREEN}make all${NC}"
make all
end_section "symbiflow.all.1"

start_section "symbiflow.all.2" "Running second ${GREEN}make all${NC}"
make all
end_section "symbiflow.all.2"

$SPACER

start_section "symbiflow.test" "Running ${GREEN}make test${NC}"
#make test
echo "TODO!"
end_section "symbiflow.test"

$SPACER

start_section "symbiflow.info.1" "Info on ${YELLOW}listfiles${NC}"
utils/listfiles.py | sed -e"s-^$PWD--"
end_section "symbiflow.info.1"

start_section "symbiflow.info.2" "Info on ${YELLOW}.gitignore${NC}"
cat .gitignore
end_section "symbiflow.info.2"

$SPACER

start_section "symbiflow.clean" "Running ${GREEN}make clean${NC}"
make clean
end_section "symbiflow.clean"

$SPACER
