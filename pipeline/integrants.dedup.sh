#! /usr/bin/env bash

#BSUB -J dup[1-14]
#BSUB -o log/%J.%I.out
#BSUB -e log/%J.%I.err
#BSUB -R "select[mem>10] rusage[mem=10]"


source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
PROJECT="/vol3/home/ransom/projects/mutation-mapping"
RESULT=$PROJECT/results/20151201
DATA=$PROJECT/results/20151116
bamfilename="$DATA/$SAMPLE/alignment/$SAMPLE.bam"
prefix=$SAMPLE

python dedup_chimeras.py $bamfilename $SAMPLE.chim.dedup.bam
samtools sort $SAMPLE.chim.dedup.bam $SAMPLE.chim.dedup
samtools index $SAMPLE.chim.dedup.bam

python dedup_discordants.py $bamfilename $SAMPLE.dis.dedup.bam 
samtools sort $SAMPLE.dis.dedup.bam $SAMPLE.dis.dedup
samtools index $SAMPLE.dis.dedup.bam
