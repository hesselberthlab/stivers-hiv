#! /usr/bin/env python

import sys
import pdb
from pysam import AlignmentFile
from collections import defaultdict

bamfilename = sys.argv[1]
chimerafilename = sys.argv[2]

kept_records = defaultdict(dict)

with AlignmentFile(bamfilename) as bamfile:
    for record in bamfile:
        if record.is_supplementary:

            if bamfile.getrname(record.rname) == 'HIV' or \
               bamfile.getrname(record.next_reference_id) == 'HIV':
            
                if record.next_reference_id != '=' \
                    and record.rname != record.next_reference_id:

                    this_pos = '%s-%s' % (record.rname, record.pos)
                    that_pos = '%s-%s' % (record.next_reference_id,
                                         record.next_reference_start)

                    kept_records[this_pos][that_pos] = record
                    
with AlignmentFile(chimerafilename, 'wb', template=bamfile) as chimeras:
    for this_pos in kept_records:
        for that_pos, record in kept_records[this_pos].items():
            chimeras.write(record)
