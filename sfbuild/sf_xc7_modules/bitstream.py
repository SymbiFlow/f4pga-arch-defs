#!/usr/bin/python3

# Symbiflow Stage Module

# ----------------------------------------------------------------------------- #

import os

# Dumb hack to avoid the need to install sfbuild package 
import sys
mypath = os.path.realpath(os.sys.argv[0])
sys.path.append(os.path.join(mypath, '../'))

from sf_common import *
from sf_module import *

# ----------------------------------------------------------------------------- #

def bitstream_output_name(fasm: str):
    p = fasm
    m = re.match('(.*)\\.[^.]*$', fasm)
    if m:
        p = m.groups()[0]
    return p + '.bit'

class BitstreamModule(Module):
    def map_io(self, ctx: ModuleContext):
        mapping = {}
        mapping['bitstream'] = bitstream_output_name(ctx.takes.fasm)
        return mapping
    
    def execute(self, ctx: ModuleContext):
        database = sub('prjxray-config').decode().replace('\n', '')
        database = os.path.join(database, ctx.values.bitstream_device)

        yield 'Compiling FASM to bitstream...'
        sub(*(['xcfasm',
               '--db-root', database,
               '--part', ctx.values.part_name,
               '--part_file', os.path.join(database, ctx.values.part_name,
                                           'part.yaml'),
               '--sparse',
               '--emit_pudc_b_pullup',
               '--fn_in', os.path.realpath(ctx.takes.fasm),
               '--frm2bit', 'xc7frames2bit',
               '--bit_out', ctx.outputs.bitstream
               ]))
    
    def __init__(self, _):
        self.name = 'bitstream'
        self.no_of_phases = 1
        self.takes = [ 'fasm' ]
        self.produces = [ 'bitstream' ]
        self.values = [
            'part_name',
            'bitstream_device'
        ]

do_module(BitstreamModule)