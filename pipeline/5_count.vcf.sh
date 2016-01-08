#! /usr/bin/env bash

#BSUB -J dup[1-14]
#BSUB -o log/%J.%I.out
#BSUB -e log/%J.%I.err
#BSUB -R "select[mem>10] rusage[mem=10]"

set -o nounset -o pipefail -o errexit -x

source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
PROJECT="/vol3/home/ransom/projects/mutation-mapping"
RESULT=$PROJECT/results/20151201
DATA=$PROJECT/results/20151116/$SAMPLE/alignment
bam="$RESULT/$SAMPLE.nodis.nochim.bam"
prefix=$SAMPLE

cat $SAMPLE.d1.vcf| grep 'HIV'| cut -f1,2,4,5,10 | awk '{FS=":"}{OFS="\t"}{print $1, $2, $3, $5}' >$SAMPLE.mut.tab
cat $SAMPLE.chim.vcf| grep 'HIV'| cut -f1,2,4,5,10 | awk '{FS=":"}{OFS="\t"}{print $1, $2, $3, $5}' >$SAMPLE.chim.mut.tab
cat $SAMPLE.dis.vcf | grep 'HIV'| cut -f1,2,4,5,10 | awk '{FS=":"}{OFS="\t"}{print $1, $2, $3, $5}' >$SAMPLE.chim.mut.tab
 
 
