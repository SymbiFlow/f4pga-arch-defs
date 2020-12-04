#!/bin/bash

SCRIPT_SRC="$(realpath ${BASH_SOURCE[0]})"
SCRIPT_DIR="$(dirname "${SCRIPT_SRC}")"

export CMAKE_FLAGS="-GNinja"
export BUILD_TOOL=ninja
source ${SCRIPT_DIR}/common.sh

source ${SCRIPT_DIR}/steps/start_monitor.sh

echo
echo "========================================"
echo "Running xc7 tests (make all_xc7)"
echo "----------------------------------------"
(
	source env/conda/bin/activate symbiflow_arch_def_base
	pushd build
	export VPR_NUM_WORKERS=${CORES}
	ninja -j${MAX_CORES} all_xc7 || sleep 86400
	ninja print_qor > xc7_qor.csv
	popd
)
echo "----------------------------------------"

source ${SCRIPT_DIR}/steps/stop_monitor.sh
source ${SCRIPT_DIR}/package_results.sh
