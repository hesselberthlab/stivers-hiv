#! /usr/bin/env bash

#BSUB -J index
#BSUB -o index.out
#BSUB -e index.err

set -o nounset -o pipefail -o errexit -x

FASTA_FULL="hg19-HIV.fa.gz"
FASTA_HIV="HIV.fa.gz"

for FASTA in $FASTA_FULL $FASTA_HIV; do
    samtools faidx $FASTA
    bwa index -p $(basename $FASTA .fa.gz) $FASTA
done
