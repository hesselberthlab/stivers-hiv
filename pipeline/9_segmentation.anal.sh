#! /usr/bin/env bash

#BSUB -J segment[1-14]
#BSUB -e log/segment.%J.err
#BSUB -o log/segment.%J.out

set -o nounset -o pipefail -o errexit -x
source config.sh

SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

segment=/vol3/home/ransom/class/project/results/Final_Project/data/segment.Hepg2.bed.gz
chromsize=/vol3/home/ransom/class/project/results/Final_Project/hiv.ref/hg19.hiv.chrom.sizes

PREFIX=$SAMPLE
CHIMERA=$DATA/$SAMPLE.chim.hiv3.uniq.bed
DISCORDANT=$DATA/$SAMPLE.dis.hiv.bed

# to remove hiv sequences from files
cat $PREFIX.dis.hiv.bed |grep -v '^HIV' > $PREFIX.dis.bed
cat $PREFIX.chim.hiv3.uniq.bed |grep -v '^HIV' > $PREFIX.chim.bed

# to create an intersect file with chimeras that overlap segments

bedtools intersect -a $segment -b $PREFIX.chim.bed >$PREFIX.peaks.chimera.segment.uniq.bed

# to create a slop file for discordant reads with 1000 bp of upstream slop

bedtools slop -l 1000 -r 0 -i $PREFIX.dis.bed -g $chromsize >$PREFIX.discordant.1000slop.bed

#to create an intersect file with discordant reads slopped 1000bp 

bedtools intersect -a $segment -b $PREFIX.discordant.1000slop.bed >$PREFIX.peaks.discordant.segment.bed

