#!/usr/bin/env python3
"""
This script is used to test the minimal DDR litex design.

It performs the calibration step by sending commands and data through an UART bridge
to the DDR controller.

It makes use of the litex RemoteClient.

This script is able to calculate which are the correct bitslip and delay values of the
IOSERDESes.

If the DDR design is correctly working, depending on the system frequency, an output similar
to the following is desplayed as output of this script:

Minimal Arty DDR3 Design for tests with Project X-Ray 2020-02-03 11:30:24
Release reset
Bring CKE high
Load Mode Register 2, CWL=5
Load Mode Register 3
Load Mode Register 1
Load Mode Register 0, CL=6, BL=8
ZQ Calibration
bitslip 0: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|31|
bitslip 1: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 2: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 3: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 4: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 5: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 6: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|
bitslip 7: |..|..|..|..|..|..|..|..|..|.............|..|..|..|..|..|..|..|..|..|..|..|..|..|..|..|


NOTE: if the system frequency is lower than 50 MHz, the DDR won't correctly function

"""

import sys
import argparse

from litex import RemoteClient

from sdram_init import dfii_control_sel, init_sequence


def identify_fpga(wb):
    """ Gets the FPGA identifier and prints it on terminal."""
    fpga_id = ""
    for i in range(256):
        c = chr(wb.read(wb.bases.identifier_mem + 4 * i) & 0xff)
        fpga_id += c
        if c == "\0":
            break
    print(fpga_id)


def seed_to_data(seed, random=True):
    if random:
        return (1664525 * seed + 1013904223) & 0xffffffff
    else:
        return seed


def write_pattern(wb, length):
    for i in range(length):
        wb.write(wb.mems.main_ram.base + 4 * i, seed_to_data(i))


def check_pattern(wb, length, debug=False):
    errors = 0
    for i in range(length):
        error = 0
        if wb.read(wb.mems.main_ram.base + 4 * i) != seed_to_data(i):
            error = 1
            if debug:
                print(
                    "{}: 0x{:08x}, 0x{:08x} KO".format(
                        i, wb.read(wb.mems.main_ram.base + 4 * i),
                        seed_to_data(i)
                    )
                )
        else:
            if debug:
                print(
                    "{}: 0x{:08x}, 0x{:08x} OK".format(
                        i, wb.read(wb.mems.main_ram.base + 4 * i),
                        seed_to_data(i)
                    )
                )
        errors += error
    return errors


def find_bitslips_delays(wb):
    """ Finds bitslip and delay values that can be used with the implemented DDR design."""
    nbitslips = 8
    ndelays = 32
    nmodules = 2
    nwords = 16

    final_bitslip = None
    final_delay = None

    for bitslip in range(nbitslips):
        print("bitslip {:d}: |".format(bitslip), end="")
        for delay in range(ndelays):
            for module in range(nmodules):
                wb.regs.ddrphy_dly_sel.write(1 << module)
                wb.regs.ddrphy_rdly_dq_rst.write(1)
                wb.regs.ddrphy_rdly_dq_bitslip_rst.write(1)
                for i in range(bitslip):
                    wb.regs.ddrphy_rdly_dq_bitslip.write(1)
                for i in range(delay):
                    wb.regs.ddrphy_rdly_dq_inc.write(1)
            write_pattern(wb, nwords)
            errors = check_pattern(wb, nwords)
            if errors:
                print("..|", end="")
            else:
                print("{:02d}|".format(delay), end="")
                final_bitslip = bitslip if final_bitslip is None else final_bitslip
                final_delay = delay if final_delay is None else final_delay
            sys.stdout.flush()
        print("")

    assert final_bitslip is not None and final_delay is not None, "bitslip/delay values not found"

    return final_bitslip, final_delay


def set_bitslip_delay(wb, bitslip, delay):
    """ Sets bitslip and delay values."""
    nmodules = 2

    for module in range(nmodules):
        wb.regs.ddrphy_dly_sel.write(1 << module)
        wb.regs.ddrphy_rdly_dq_rst.write(1)
        wb.regs.ddrphy_rdly_dq_bitslip_rst.write(1)
        for i in range(bitslip):
            wb.regs.ddrphy_rdly_dq_bitslip.write(1)
        for i in range(delay):
            wb.regs.ddrphy_rdly_dq_inc.write(1)


def read_word_offset(read_only=False):
    word = None
    if not read_only:
        print("\n==================================================\n")
        print(
            "Set a byte long word to write to memory (e.g. 0xdeadbeef): ",
            end=""
        )
        word = int(input(), 16) & 0xffffffff

    print("\n==================================================\n")
    print("Set offset from base memory address: ", end="")
    offset = int(input())

    print("\n==================================================\n")
    print("Set number of words to read or write: ", end="")
    length = int(input())

    return word, offset, length


def write_user_pattern(wb, offset, length, pattern):
    """
    Writes to memory words set by user.

    inputs:
        - offset -> offset from base RAM address
        - length -> number of words to be written starting
                    from offset
        - pattern -> word to be written at offset
    """
    for i in range(length):
        wb.write(wb.mems.main_ram.base + 4 * (offset + i), pattern)


def read_user_pattern(wb, offset, length, pattern=None):
    """
    Reads from memory at address set by user.

    inputs:
        - offset -> offset from base RAM address
        - length -> number of lines to be read
        - pattern -> pattern to be checked against read value

    """
    for i in range(length):
        read_value = wb.read(wb.mems.main_ram.base + 4 * (offset + i))

        if pattern is None:
            print("0x{:08x}".format(read_value))
        else:
            if read_value == pattern:
                outcome = "CORRECT"
            else:
                outcome = "INCORRECT"

            print(
                "{} --> 0x{:08x}, 0x{:08x}".format(
                    outcome, read_value, pattern
                )
            )


def start_command_interface(wb):

    cmd_list = """
Commands list:
    0 --> Write memory
    1 --> Read memory
    2 --> Write/Read memory
    3 --> Print commands list
    4 --> Exit
"""

    print(cmd_list)

    while True:
        print("\nWaiting for command: ", end="")
        cmd = int(input())

        if cmd == 0:
            word, offset, length = read_word_offset()
            write_user_pattern(wb, offset, length, word)
        elif cmd == 1:
            word, offset, length = read_word_offset(True)
            read_user_pattern(wb, offset, length)
        elif cmd == 2:
            word, offset, length = read_word_offset()
            write_user_pattern(wb, offset, length, word)
            read_user_pattern(wb, offset, length, word)
        elif cmd == 3:
            print(cmd_list)
        elif cmd == 4:
            break
        else:
            print("Command not recognized, try again...")


def main():
    parser = argparse.ArgumentParser(
        description="Script to test correct DDR behaviour."
    )

    parser.add_argument(
        '--bitslip', default=None, help="Defines a bitslip value."
    )
    parser.add_argument('--delay', default=None, help="Defines a delay value.")

    args = parser.parse_args()

    wb = RemoteClient(debug=False)
    wb.open()

    # software control
    wb.regs.sdram_dfii_control.write(0)

    # sdram initialization
    for i, (comment, a, ba, cmd, delay) in enumerate(init_sequence):
        print(comment)
        wb.regs.sdram_dfii_pi0_address.write(a)
        wb.regs.sdram_dfii_pi0_baddress.write(ba)
        if i < 2:
            wb.regs.sdram_dfii_control.write(cmd)
        else:
            wb.regs.sdram_dfii_pi0_command.write(cmd)
            wb.regs.sdram_dfii_pi0_command_issue.write(1)

    # hardware control
    wb.regs.sdram_dfii_control.write(dfii_control_sel)

    if args.bitslip is None or args.delay is None:
        bitslip, delay = find_bitslips_delays(wb)
    else:
        bitslip = int(args.bitslip)
        delay = int(args.delay)

    set_bitslip_delay(wb, bitslip, delay)

    start_command_interface(wb)

    wb.close()


if __name__ == "__main__":
    main()
