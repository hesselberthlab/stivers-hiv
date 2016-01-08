#!/usr/bin/env bash

#BSUB -J coverage[1-14]
#BSUB -e log/coverage.%J.%I.err
#BSUB -o log/coverage.%J.%I.out
#BSUB -q normal
#BSUB -P stivers

<<DOC
Calculate coverage from bam files
DOC

set -o nounset -o pipefail -o errexit -x

source config.sh
sample=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

results=$RESULT/$sample
bgresults=$RESULT/$sample/bedgraphs

if [[ ! -d $bgresults ]]; then
    mkdir -p $bgresults
fi

strands=(pos neg both)
strand_args=("-strand +" "-strand -" "")

bam=$results/alignment/$sample.bam
    
for strand_idx in ${!strands[@]}; do

    strand=${strands[$strand_idx]}
    strand_arg=${strand_args[$strand_idx]}

    bedgraph=$bgresults/$sample.strand.$strand.counts.bg.gz
    tab=$bgresults/$sample.strand.$strand.counts.tab.gz

    if [[ ! -f $bedgraph ]]; then
        bedtools genomecov -bg -g $CHROM_SIZES \
            -ibam $bam $strand_arg \
            | gzip -c \
            > $bedgraph
    fi

    if [[ ! -f $tab ]]; then
        bedtools genomecov -dz -g $CHROM_SIZES \
            -ibam $bam $strand_arg \
            | gzip -c \
            > $tab
    fi

done


