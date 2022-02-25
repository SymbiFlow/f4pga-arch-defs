#!/bin/bash

export CMAKE_FLAGS="-GNinja"
source $(dirname "$0")/setup.sh

set -e
source $(dirname "$0")/common.sh

source env/conda/bin/activate symbiflow_arch_def_base

pushd build

make_target docs "Building documentation (make docs)"

popd