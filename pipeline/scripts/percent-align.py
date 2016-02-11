#! /usr/bin/env python

import sys
from collections import OrderedDict

info = OrderedDict()
total = 0.0

for line in sys.stdin:
    chrom, size, n_align, _ = line.strip().split('\t')
    info[chrom] = (size, n_align)

    total += float(n_align)

for chrom in info:
    size, n_align = info[chrom]

    frac_align = float(n_align) / total

    print '\t'.join([chrom, size, n_align, str(frac_align)])
