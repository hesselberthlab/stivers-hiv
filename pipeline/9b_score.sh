#! /usr/bin/env bash

#BSUB -J segment[1-14]
#BSUB -e log/segment.%J.err
#BSUB -o log/segment.%J.out

set -o nounset -o pipefail -o errexit -x

source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
PREFIX=$SAMPLE

#This call takes the bed file and sorts it based on the segment and
#generates a file with segment and number of hits
cat $PREFIX.peaks.chimera.segment.bed |cut -f1-4 |sort -k4 |uniq -f3 -c |cut -f1,4 > $PREFIX.chim.count
#This reorganizes the data in a more reasonable way 
cat $PREFIX.chim.count | awk 'BEGIN{OFS=" "}{print $1,"\t", $3}' >$PREFIX.chim.score

cat $PREFIX.peaks.discordant.segment.bed |cut -f1-4 |sort -k4 |uniq -f3 -c |cut -f1,4 > $PREFIX.dis.count

cat $PREFIX.dis.count | awk 'BEGIN{OFS=" "}{print $1,"\t",$3}'>$PREFIX.dis.score


