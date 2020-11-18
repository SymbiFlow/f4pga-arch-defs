# This CMake include defines the following functions:
#
# * ADD_LITEX_TEST - Generates LiteX designs and adds the target tests

function(ADD_LITEX_TEST)
  # ~~~
  # ADD_LITEX_TEST(
  #    NAME <name>
  #    LITEX_DIR <litex directory>
  #    LITEX_BOARD <litex board name>
  #    LITEX_SOURCES <litex generated sources>
  #    EXTERNAL_SOURCES <external sources>
  #    BOARD <symbiflow board name>
  #    [USE_XDC] <option to use XDC constraints>
  #    FLAGS <additional litex options>
  #    GENERATE_SCRIPT <generate script>
  #    FIXUP_SCRIPT <fixup script>
  #    [DISABLE_DIFF_TEST] <option to disable the diff fasm test>
  # )
  #
  # LITEX_DIR is the directory that is generated by litex and used to get the generated source files
  #
  # LITEX_BOARD is the name of the board used by litex to generate the source files:
  # * E.g.: a7-35, a7-100
  #
  # LITEX_SOURCES is a list of source files generated by litex for this test
  #
  # BOARD is the actualy name of the symbiflow board used for the test:
  # * E.g.: arty-full, arty100t-full
  #
  # USE_XDC is an optional argument to specify whether the constraint file should be XDC or PCF+SDC
  #
  # FLAGS is a string containing additional options for litex
  #
  # ~~~

  set(options USE_XDC DISABLE_DIFF_TEST)
  set(oneValueArgs NAME LITEX_DIR LITEX_BOARD BOARD GENERATE_SCRIPT FIXUP_SCRIPT VIVADO_XDC)
  set(multiValueArgs FLAGS LITEX_SOURCES EXTERNAL_SOURCES)
  cmake_parse_arguments(
    ADD_LITEX_TEST
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    "${ARGN}"
  )

  set(NAME ${ADD_LITEX_TEST_NAME})
  set(LITEX_DIR ${ADD_LITEX_TEST_LITEX_DIR})
  set(LITEX_BOARD ${ADD_LITEX_TEST_LITEX_BOARD})
  set(LITEX_SOURCES ${ADD_LITEX_TEST_LITEX_SOURCES})
  set(EXTERNAL_SOURCES ${ADD_LITEX_TEST_EXTERNAL_SOURCES})
  set(BOARD ${ADD_LITEX_TEST_BOARD})
  set(GENERATE_SCRIPT ${ADD_LITEX_TEST_GENERATE_SCRIPT})
  set(FIXUP_SCRIPT ${ADD_LITEX_TEST_FIXUP_SCRIPT})
  set(USE_XDC ${ADD_LITEX_TEST_USE_XDC})
  set(VIVADO_XDC ${ADD_LITEX_TEST_VIVADO_XDC})
  set(FLAGS ${ADD_LITEX_TEST_FLAGS})
  set(DISABLE_DIFF_TEST ${ADD_LITEX_TEST_DISABLE_DIFF_TEST})

  set(LITEX_GATEWARE ${CMAKE_CURRENT_BINARY_DIR}/${LITEX_DIR}/gateware/)

  list(TRANSFORM LITEX_SOURCES PREPEND ${LITEX_GATEWARE})

  set(DEPS "")

  append_file_dependency(DEPS ${GENERATE_SCRIPT})
  append_file_dependency(DEPS ${FIXUP_SCRIPT})

  get_target_property_required(PYTHON3 env PYTHON3)

  add_custom_command(
    OUTPUT ${LITEX_SOURCES}
    DEPENDS ${PYTHON3} ${DEPS}
    COMMAND
    ${CMAKE_COMMAND} -E env PYTHON=${PYTHON3}
      ${PYTHON3} ${GENERATE_SCRIPT} --board ${LITEX_BOARD} --builddir ${LITEX_DIR} ${FLAGS}
    COMMAND
      ${PYTHON3} ${FIXUP_SCRIPT} --xdc ${LITEX_GATEWARE}/top.xdc
  )

  foreach(SRC ${LITEX_SOURCES})
    add_file_target(FILE ${SRC} GENERATED ABSOLUTE)
  endforeach()

  if (${USE_XDC})
    add_fpga_target(
      NAME ${NAME}
      BOARD ${BOARD}
      SOURCES
        ${LITEX_GATEWARE}/top.v
        ${EXTERNAL_SOURCES}
      INPUT_XDC_FILE ${LITEX_GATEWARE}/top.xdc
      EXPLICIT_ADD_FILE_TARGET
    )
  else()
    add_fpga_target(
      NAME ${NAME}
      BOARD ${BOARD}
      SOURCES
        ${LITEX_GATEWARE}/top.v
        ${EXTERNAL_SOURCES}
      INPUT_IO_FILE ${LITEX_GATEWARE}/top.pcf
      INPUT_SDC_FILE ${LITEX_GATEWARE}/top.sdc
      EXPLICIT_ADD_FILE_TARGET
    )
  endif()

  if (${DISABLE_DIFF_TEST})
    add_vivado_target(
        NAME ${NAME}_vivado
        PARENT_NAME ${NAME}
        XDC ${VIVADO_XDC}
        DISABLE_DIFF_TEST
    )
  else()
    add_vivado_target(
        NAME ${NAME}_vivado
        PARENT_NAME ${NAME}
        XDC ${VIVADO_XDC}
    )
  endif()

endfunction()
