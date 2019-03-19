import re
from collections import namedtuple

FasmEntry = namedtuple("FasmDbEntry", "feature bits")
IceDbEntry = namedtuple("IceDbEntry", "tile_type loc bits names idx")


def _parse_icedb_bit(bit):
    mm = re.match(r"([\!]?)B([0-9]+)\[([0-9]*)\]", bit)
    if mm is None:
        print("ERROR", bit)
    return mm.group(1), int(mm.group(2)), int(mm.group(3))


def _parse_fasm_bit(bit):
    mm = re.match(r"([\!]?)([0-9]+)_([0-9]+)", bit)
    if mm is None:
        print("ERROR", bit)
    return mm.group(1), int(mm.group(2)), int(mm.group(3))


class Feature(object):
    def __init__(self, tile_type, loc, bit_tuples, parts, idx=None):
        self.tile_type = tile_type
        self.loc = loc
        self.bit_tuples = bit_tuples
        self.parts = parts
        self.idx = idx

    def to_icedb_entry(self):
        parts = [
            re.sub(r"((lutff|io)_[a-z0-9]+|ram_)(_)([^\.]*)", r"\1/\4", part)
            for part in self.parts
        ]
        bits = ["{}B{}[{}]".format(*bit) for bit in self.bit_tuples]

        return IceDbEntry(self.tile_type, self.loc, bits, parts, self.idx)

    def to_fasm_entry(self):
        rem = ".".join(self.parts)
        feature = "{}_X{}_Y{}.{}".format(self.tile_type, *self.loc, rem)
        if self.idx is not None and self.idx is not 0:
            feature += "[{}]".format(self.idx)

        bits = ["{}{}_{}".format(*bit) for bit in self.bit_tuples]
        return FasmEntry(feature, bits)

    @classmethod
    def from_fasm_entry(cls, entry):
        tile, rem = entry.feature.split(".", 1)

        mm = re.match(r"([A-Za-z]+)_X([0-9]+)_Y([0-9]+)", tile)
        tile_type = mm.group(1)
        loc = [int(mm.group(2)), int(mm.group(3))]
        parts = rem.split(".")

        # if there is '[5]' set bit_idx to 5
        mm = re.match(r"([^\[\]]+)\[([0-9]+)\]", parts[-1])
        bit_idx = None
        if mm:
            bit_idx = int(mm.group(2))
            parts[-1] = mm.group(1)

        bits = [_parse_fasm_bit(each) for each in entry.bits]

        return cls(tile_type, loc, bits, parts, bit_idx)

    @classmethod
    def from_icedb_entry(cls, entry):
        parts = [part.replace("/", "_") for part in entry.names]
        bits = [_parse_icedb_bit(bit) for bit in entry.bits]
        idx = entry.idx

        return cls(entry.tile_type, entry.loc, bits, parts, idx)
