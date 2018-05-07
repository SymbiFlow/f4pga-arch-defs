import lib.rr_graph.graph as graph

def print_block_types(rr_graph):
    '''Sequentially list block types'''
    bg = rr_graph.block_grid

    for type_id, bt in bg.block_types.items():
        print("{:4}  ".format(type_id), "{:40s}".format(bt.to_string()), bt.to_string(extra=True))

def print_grid(rr_graph):
    '''ASCII diagram displaying XY layout'''
    bg = rr_graph.block_grid
    grid = bg.size()

    #print('Grid %dw x %dh' % (grid.width, grid.height))
    col_widths = []
    for x in range(0, grid.width):
        col_widths.append(max(len(bt.name) for bt in bg.block_types_for(col=x)))

    print("    ", end=" ")
    for x in range(0, grid.width):
        print("{: ^{width}d}".format(x, width=col_widths[x]), end="   ")
    print()

    print("   /", end="-")
    for x in range(0, grid.width):
        print("-"*col_widths[x], end="-+-")
    print()

    for y in reversed(range(0, grid.height)):
        print("{: 3d} |".format(y, width=col_widths[0]), end=" ")
        for x, bt in enumerate(bg.block_types_for(row=y)):
            assert x < len(col_widths), (x, bt)
            print("{: ^{width}}".format(bt.name, width=col_widths[x]), end=" | ")
        print()

def print_nodes(rr_graph, lim=None):
    '''Display source/sink edges on all XML nodes'''
    ids = rr_graph.ids
    print('Nodes: {}, edges {}'.format(len(ids._xml_nodes), len(ids._xml_edges)))
    for nodei, node in enumerate(ids._xml_nodes):
        print()
        if lim and nodei >= lim:
            print('...')
            break
        #print(nodei)
        #ET.dump(node)
        print('{} ({})'.format(ids.node_name(node), node.get("id")))
        srcs = []
        snks = []
        for e in ids.edges_for_node(node):
            src, snk = ids.nodes_for_edge(e)
            if src == node:
                srcs.append(e)
            elif snk == node:
                snks.append(e)
            else:
                print("!?@", ids.edge_name(e))

        print("  Sources:")
        for e in srcs:
            print("   ", ids.edge_name(e))
        if not srcs:
            print("   ", None)

        print("  Sink:")
        for e in snks:
            print("   ", ids.edge_name(e, flip=True))
        if not snks:
            print("   ", None)

def print_graph(rr_graph, lim=0):
    print()
    print_block_types(rr_graph)
    print()
    print_grid(rr_graph)
    print()
    print_nodes(rr_graph, lim=lim)
    print()

def main():
    import argparse

    parser = argparse.ArgumentParser("Print rr_graph.xml file")
    parser.add_argument("--lim", type=int, default=0)
    parser.add_argument("rr_graph")
    args = parser.parse_args()

    g = graph.Graph(args.rr_graph)
    print_graph(g, lim=args.lim)

if __name__ == "__main__":
    main()
