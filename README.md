# F4PGA Architecture Definitions

**This repository is used during the development of architecture support in F4PGA, if you are looking to use the**
**toolchain you should start with the [f4pga-examples repository](https://github.com/chipsalliance/f4pga-examples).**

<p align="center">
  <a title="License Status" href="https://github.com/SymbiFlow/f4pga-arch-defs/blob/master/COPYING"><img alt="License Status" src="https://img.shields.io/github/license/SymbiFlow/f4pga-arch-defs?longCache=true&style=flat-square&label=License"></a><!--
  -->
  <a title="Documentation Status" href="https://f4pga.readthedocs.io/projects/arch-defs/"><img alt="Documentation Status" src="https://img.shields.io/readthedocs/symbiflow-arch-defs/latest?longCache=true&style=flat-square&logo=ReadTheDocs&logoColor=fff&label=Docs"></a><!--
  -->
  <a title="'Automerge' workflow Status" href="https://github.com/SymbiFlow/f4pga-arch-defs/actions/workflows/Automerge.yml"><img alt="'Tests' workflow Status" src="https://img.shields.io/github/workflow/status/SymbiFlow/f4pga-arch-defs/Automerge/main?longCache=true&style=flat-square&label=Tests&logo=github%20actions&logoColor=fff"></a><!--
  -->
</p>

This repo contains documentation of various FPGA architectures, it is currently concentrating on:

* [Lattice iCE40](ice40)
* [Xilinx Series 7 (Artix 7 and Zynq 7)](xc/xc7)
* [QuickLogic](quicklogic)

The aim is to include useful documentation (both human and machine readable) on the primitives and routing
infrastructure for these architectures.
We hope this enables growth in the open source FPGA tools space.

The repo includes:

 * Black box part definitions
 * Verilog simulations
 * Verilog To Routing architecture definitions
 * Documentation for humans

The documentation can be generated using Sphinx.

# Getting Started

To initialize submodules and setup the CMake build system, from the root of the `f4pga-arch-defs` directory run:

```bash
make env
```

To build all demo bitstreams there are 3 useful targets:

```bash
# Build all demo bitstreams, targetting all architectures
make all_demos

# Build all 7-series demo bitstreams
make all_xc7

# Build all ice40 demo bitstreams
make all_ice40
```

Specific bitstreams can be built by specifying their target name, followed by a suffix specifying the desired output.
For example, the LUT-RAM test for the RAM64X1D primative is called `dram_test_64x1d`.
Example targets are:


```bash
# Just run synthesis on the input Verilog
make dram_test_64x1d_eblif

# Complete synthesis and place and route the circuit
make dram_test_64x1d_route

# Create the output bitstream (including synthesis and place and route)
make dram_test_64x1d_bin

# Run bitstream back into Vivado for timing checks, etc.
make dram_test_64x1d_vivado
```

# Tools installed via submodules

 * [`third_party/netlistsvg`](https://github.com/nturley/netlistsvg/)
   Tool for generating nice logic diagrams from Verilog code.

 * [`third_party/icestorm`](https://github.com/cliffordwolf/icestorm/)
   Bitstream and timing database + tools for the Lattice iCE40.

 * [`third_party/prjxray`](https://github.com/f4pga/prjxray/)
   Tools for the Xilinx Series 7 parts.

 * [`third_party/prjxray-db`](https://github.com/f4pga/prjxray-db/)
   Bitstream and timing database for the Xilinx Series 7 parts.

## Tools installed via conda

 * [yosys](https://github.com/YosysHQ/yosys)
   Verilog parsing and synthesis.

 * [vtr](https://github.com/verilog-to-routing/vtr-verilog-to-routing)
   Place and route tool.

 * [iverilog](https://github.com/steveicarus/iverilog)
   Very correct FOSS Verilog Simulator

## Tools potentially used in the future

 * [verilator](https://www.veripool.org/wiki/verilator)
   Fast FOSS Verilog Simulator

 * [sphinx](http://www.sphinx-doc.org/en/master/)
   Tool for generating nice looking documentation.

 * [breathe](https://breathe.readthedocs.io/en/latest/)
   Tool for allowing Doxygen and Sphinx integration.

 * doxygen-verilog
   Allows using Doxygen style comments inside Verilog files.

 * [symbolator](https://kevinpt.github.io/symbolator/)
   Tool for generating symbol diagrams from Verilog (and VHDL) code.

 * [wavedrom](https://wavedrom.com/)
   Tool for generating waveform / timing diagrams.

## Pre-built architecture files

The Continuous Integration system builds and uploads the various architecture data files.
A set of latest architecture build artifact links is generated and uploaded to a dedicated [GCS bucket](https://storage.cloud.google.com/symbiflow-arch-defs-gha/).

## Resource Requirements

To run examples provided, please make sure these resources are available:
 * Memory: 5.5G
 * Disk space: 20G

## Development notes

Since Architecture Definitons rely on yosys and VPR, it may be useful to override the default packaged binaries with
locally supplied binaries.
The build system allows this via environment variables matching the executable name.
Here is a list of common environment variables to defined when doing local yosys and VPR development.

* YOSYS : Path to yosys executable to use.
* VPR : Path to VPR executable to use.
* GENFASM : Path genfasm executable to use.

There are more binaries that are packaged (e.g. VVP), but the packaged versions are typically good enough for most use
cases.

After setting or clearing one of these environment variables, CMake needs to be re-run.
