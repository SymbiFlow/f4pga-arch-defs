#!/usr/bin/env python3
"""
Generate a Makefile .d fragment for the Makefile includes.
"""

import argparse
import os
import sys

from io import StringIO

from lib.asserts import assert_eq
from lib.deps import deps_file
from lib.deps import write_deps


parser = argparse.ArgumentParser()
parser.add_argument(
    "inputfile",
    type=argparse.FileType('r'),
    help="""\
Input Makefile
""")


my_path = os.path.abspath(__file__)
my_dir = os.path.dirname(my_path)
topdir = os.path.abspath(os.path.join(my_dir, ".."))


def main(argv):
    args = parser.parse_args(argv[1:])

    data = StringIO()

    to_check = set([args.inputfile.name])
    checked = []
    while to_check:
        makefile = to_check.pop()
        checked.append(makefile)
        reldir = os.path.realpath(os.path.dirname(makefile))

        for line in open(makefile):
            line = line.strip()
            if not line.startswith("include"):
                continue
            _, includefile_path = line.split(" ", 1)
            assert_eq(_, "include")

            includefile_path = includefile_path.replace("$(SELF_DIR)", reldir)
            if "$" in includefile_path:
                print("Skipping {}".format(includefile_path))
                continue

            includefile_fullpath = os.path.realpath(includefile_path)
            if includefile_fullpath in checked:
                continue

            to_check.add(includefile_fullpath)

            data.write("""
{inputfile_deps}: {includefile}
""".format(
    inputfile_deps=deps_file(args.inputfile.name),
    includefile=includefile_fullpath,
))

    write_deps(args.inputfile.name, data)


if __name__ == "__main__":
    sys.exit(main(sys.argv))
