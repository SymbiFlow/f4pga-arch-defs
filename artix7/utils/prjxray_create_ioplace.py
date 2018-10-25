""" Convert a PCF file into a VPR io.place file. """
from __future__ import print_function
import argparse
from collections import namedtuple
import csv
import sys
import re
import vpr_io_place

PcfIoConstraint = namedtuple('PcfIoConstraint', 'net pad line_str line_num')

def parse_simple_pcf(f):
    for line_number, line in enumerate(f):
        line_number += 1

        # Remove comments.
        args = re.sub(r"#.*", "", line.strip()).split()

        if not args or args[0] != 'set_io':
            continue

        # Ignore arguments to set_io.
        args = [arg for arg in args if arg[0] != '-']

        assert len(args) == 3, args

        yield PcfIoConstraint(
                net=args[1],
                pad=args[2],
                line_str=line.strip(),
                line_num=line_number,
        )

def main():
    parser = argparse.ArgumentParser(description='Convert a PCF file into a VPR io.place file.')
    parser.add_argument(
            "--pcf", '-p', "-P",
            type=argparse.FileType('r'), required=True,
            help='PCF input file')
    parser.add_argument(
            "--blif", '-b',
            type=argparse.FileType('r'), required=True,
            help='BLIF / eBLIF file')
    parser.add_argument(
            "--map", '-m', "-M",
            type=argparse.FileType('r'), required=True,
            help='Pin map CSV file')
    parser.add_argument(
            "--output", '-o', "-O",
            type=argparse.FileType('w'),
            default=sys.stdout,
            help='The output io.place file')

    args = parser.parse_args()

    io_place = vpr_io_place.IoPlace()
    io_place.read_io_list_from_eblif(args.blif)

    # Map of pad names to VPR locations.
    pad_map = {}

    for pin_map_entry in csv.DictReader(args.map):
        pad_map[pin_map_entry['name']] = (
                int(pin_map_entry['x']),
                int(pin_map_entry['y']),
                int(pin_map_entry['z']),
        )

    for pcf_constraint in parse_simple_pcf(args.pcf):
        if not io_place.is_net(pcf_constraint.net):
            print('PCF constraint "{}" from line {} constraints net {} which is not in available netlist:\n{}'.format(
                    pcf_constraint.line_str, pcf_constraint.line_num,
                    pcf_constraint.net,
                    '\n'.join(io_place.get_nets())), file=sys.stderr)
            sys.exit(1)

        if pcf_constraint.pad not in pad_map:
            print('PCF constraint "{}" from line {} constraints pad {} which is not in available pad map:\n{}'.format(
                    pcf_constraint.line_str, pcf_constraint.line_num,
                    pcf_constraint.pad,
                    '\n'.join(sorted(pad_map.keys()))), file=sys.stderr)
            sys.exit(1)

        io_place.constrain_net(net_name=pcf_constraint.net, loc=pad_map[pcf_constraint.pad], comment=pcf_constraint.line_str)

    io_place.output_io_place(args.output)

if __name__ == '__main__':
    main()
