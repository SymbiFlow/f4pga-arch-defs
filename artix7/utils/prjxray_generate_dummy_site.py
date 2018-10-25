#!/usr/bin/env python3

"""
Generates a dummy pb_type model for a site type.
"""

import argparse
import os
import prjxray.db
import prjxray.site_type
import os.path
import sys

import lxml.etree as ET

def main():
    mydir = os.path.dirname(__file__)
    prjxray_db = os.path.abspath(os.path.join(mydir, "..", "..", "third_party", "prjxray-db"))

    db_types = prjxray.db.get_available_databases(prjxray_db)

    parser = argparse.ArgumentParser(
        description=__doc__,
        fromfile_prefix_chars='@',
        prefix_chars='-~'
    )

    parser.add_argument(
        '--part', choices=[os.path.basename(db_type) for db_type in db_types],
        help="""Project X-Ray database to use.""")

    parser.add_argument(
        '--site_type',
        help="""Site type to generate for""")

    parser.add_argument(
        '--output-pb-type', nargs='?', type=argparse.FileType('w'), default=sys.stdout,
        help="""File to write the output too.""")

    parser.add_argument(
        '--output-model', nargs='?', type=argparse.FileType('w'), default=sys.stdout,
        help="""File to write the output too.""")

    args = parser.parse_args()

    db = prjxray.db.Database(os.path.join(prjxray_db, args.part))

    site_type = db.get_site_type(args.site_type.upper())

    pb_type_xml = ET.Element(
        'pb_type', {
            'name': 'BLK_DU-{}'.format(args.site_type),
        },
    )

    for site_pin_name in site_type.get_site_pins():
        site_pin = site_type.get_site_pin(site_pin_name)
        if site_pin.direction == prjxray.site_type.SitePinDirection.IN:
            ET.SubElement(pb_type_xml, 'input', {
                    'name': site_pin.name,
            })
        elif site_pin.direction == prjxray.site_type.SitePinDirection.OUT:
            ET.SubElement(pb_type_xml, 'output', {
                    'name': site_pin.name,
            })
        else:
            assert False, site_pin

    pb_type_str = ET.tostring(pb_type_xml, pretty_print=True).decode('utf-8')
    args.output_pb_type.write(pb_type_str)
    args.output_pb_type.close()

    model_xml = ET.Element('models')

    model_str = ET.tostring(model_xml, pretty_print=True).decode('utf-8')
    args.output_model.write(model_str)
    args.output_model.close()

if __name__ == '__main__':
    main()
