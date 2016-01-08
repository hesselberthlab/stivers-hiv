#! /usr/bin/env bash

#BSUB -J bam[1-14]
#BSUB -o log/%J.%I.out
#BSUB -e log/%J.%I.err

set -o nounset -o pipefail -o errexit -x

source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
PROJECT="/vol3/home/ransom/projects/mutation-mapping"
RESULT=$PROJECT/results/20151201
DATA=$PROJECT/results/20151116  

bam=$DATA/$SAMPLE/alignment/$SAMPLE.bam
prefix=$SAMPLE

#To generate a bam file without chimeric and discordant reads
samtools view -H $bam >$prefix.header.temp
samtools view -F 0x800 -f 0x2 $bam >>$prefix.header.temp
samtools view -bS $prefix.header.temp >$prefix.nodis.nochim.bam
rm $prefix.header.temp

