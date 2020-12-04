#!/bin/bash

SCRIPT_SRC="$(realpath ${BASH_SOURCE[0]})"
SCRIPT_DIR="$(dirname "${SCRIPT_SRC}")"

export CMAKE_FLAGS=-GNinja
export BUILD_TOOL=ninja
export XRAY_VIVADO_SETTINGS=/opt/Xilinx/Vivado/2017.2/settings64.sh
export URAY_VIVADO_SETTINGS=/image/Xilinx/Vivado/2019.2/settings64.sh
source ${SCRIPT_DIR}/steps/rapidwright.sh
source ${SCRIPT_DIR}/common.sh
source third_party/prjxray/.github/kokoro/steps/xilinx.sh
source third_party/prjuray/.github/kokoro/steps/xilinx.sh
echo
echo "========================================"
echo "prjxray Vivado version"
echo "----------------------------------------"
(
    source third_party/prjxray/utils/environment.sh
    $XRAY_VIVADO -version
)
echo "----------------------------------------"
echo
echo "========================================"
echo "prjuray Vivado version"
echo "----------------------------------------"
(
    source third_party/prjuray/utils/environment.sh
    $URAY_VIVADO -version
)
echo "----------------------------------------"

source ${SCRIPT_DIR}/steps/start_monitor.sh

echo
echo "========================================"
echo "Running xc7 vendor tests (make all_xc7_diff_fasm)"
echo "----------------------------------------"
(
	source env/conda/bin/activate symbiflow_arch_def_base
	cd build
	export VPR_NUM_WORKERS=${CORES}
	# Running with -k0 to attempt all tests, and show which ones failed.
	ninja -k0 -j${MAX_CORES} all_xc7_diff_fasm || sleep 86400
)
echo "----------------------------------------"

source ${SCRIPT_DIR}/steps/stop_monitor.sh
source ${SCRIPT_DIR}/package_results.sh
