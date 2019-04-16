import argparse
import json
from lib.parse_usage import parse_usage


def main():
    parser = argparse.ArgumentParser(
        description="Converts VPR pack.log into usage numbers."
    )
    parser.add_argument('pack_log')
    parser.add_argument(
        '--assert_usage',
        help='Comma seperate block name list with expected usage stats.'
    )
    parser.add_argument(
        '--no_print_usage',
        action='store_false',
        dest='print_usage',
        help='Disables printing of output.'
    )

    args = parser.parse_args()

    usage = {}

    for block, count in parse_usage(args.pack_log):
        usage[block] = count

    if args.print_usage:
        print(json.dumps(usage, indent=2))

    if args.assert_usage:
        blocks = dict(b.split('=') for b in args.assert_usage.split(','))

        for block in usage:
            if block in blocks:
                assert usage[block] == int(
                    blocks[block]
                ), 'Expect usage of block {} = {}, found {}'.format(
                    block, int(blocks[block]), usage[block]
                )
            else:
                assert usage[
                    block
                ] == 0, 'Expect usage of block {} = 0, found {}'.format(
                    block, usage[block]
                )


if __name__ == "__main__":
    main()
