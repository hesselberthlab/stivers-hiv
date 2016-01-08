#! /usr/bin/env python

import sys
import pdb
from pysam import AlignmentFile
from collections import defaultdict

bamfilename = sys.argv[1]
discordantfilename = sys.argv[2]

kept_records = defaultdict(dict)

with AlignmentFile(bamfilename) as bamfile:
    for record in bamfile:
        if not record.is_proper_pair:

            if (bamfile.getrname(record.rname) == 'HIV' and \
                bamfile.getrname(record.next_reference_id) != 'HIV') or \
               (bamfile.getrname(record.rname) != 'HIV' and \
                bamfile.getrname(record.next_reference_id) == 'HIV'):

                # skip HIV-HIV discordants
                if bamfile.getrname(record.rname) == '=' or \
                   bamfile.getrname(record.next_reference_id) == '=':
                    continue

                this_pos = '%s-%s' % (record.rname, record.pos)
                that_pos = '%s-%s' % (record.next_reference_id,
                                     record.next_reference_start)

                kept_records[this_pos][that_pos] = record
                
with AlignmentFile(discordantfilename, 'wb', template=bamfile) as discordants:
    for this_pos in kept_records:
        for that_pos, record in kept_records[this_pos].items():
            discordants.write(record)
