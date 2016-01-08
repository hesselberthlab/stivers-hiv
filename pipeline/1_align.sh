#! /usr/bin/env bash

#BSUB -J align[1-14]
#BSUB -e log/align.%J.%I.err
#BSUB -o log/align.%J.%I.out
#BSUB -R "select[mem>8] rusage[mem=8] span[hosts=1]"
#BSUB -q normal
#BSUB -P stivers
#BSUB -n 6

<<DOC
DOC

set -o nounset -o pipefail -o errexit -x

source config.sh  
sample=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

threads=6

read1="$DATA/$sample.R1.fq.gz"
read2="$DATA/$sample.R2.fq.gz"

result=$RESULT/$sample/alignment

if [[ ! -d $result ]]; then
    mkdir -p $result
fi


bam="$result/$sample.bam"

bwa mem -t $threads $BWAIDX $read1 $read2 \
    | samtools view -ShuF4 - \
    | samtools sort -o - $result/$sample.temp -m 8G \
    > $bam
samtools index $bam

