#! /usr/bin/env bash
#BSUB -J vcf[1-14]
#BSUB -o log/%J.%I.out
#BSUB -e log/%J.%I.err

set -o nounset -o pipefail -o errexit -x

source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
PROJECT="$HOME/projects/mutation-mapping"
RESULT=$PROJECT/results/20151116

DATA=$PROJECT/results/20151116/$SAMPLE/alignment
bam="$SAMPLE.rmdup.bam"

VCFPREFIX=$SAMPLE
FASTA="$PROJECT/results/hiv.ref/hg19-hiv.lines.fa"
STDIN="-"

freebayes -f $FASTA $bam |vcffilter -f "QUAL > 40" > $VCFPREFIX.d1.vcf




