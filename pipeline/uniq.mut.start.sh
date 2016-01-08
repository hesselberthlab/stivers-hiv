#! /usr/bin/env bash

#BSUB -J uniq[1-14]
#BSUB -e log/uniq.%J.%I.err
#BSUB -o log/uniq.%J.%I.out

source config.sh
SAMPLE=${SAMPLES[$(($LSB_JOBINDEX - 1))]}
filename=$SAMPLE.mut.tab
fasta=~/projects/mutation-mapping/results/hiv.ref/hg19-hiv.lines.fa
#pull out the uniq sequences for each mutation

for pos in $(cut -f2 $filename); do
    samtools view -b $SAMPLE.rmdup.bam HIV:$pos-$pos\
        |samtools fillmd -e - $fasta \
        | grep -v "^@" \
        | awk -v ref="$pos" 'BEGIN {OFS = FS = "\t"} ; {n=split($10,a,"") ; if (a[(ref-$4)+1] != "=") print ref, (ref-$4)+1, a[(pos-$4)+1], $1, $4, $10}' >>$SAMPLE.mut.uniq.tab
done

cat $SAMPLE.mut.uniq.tab |cut -f1,5 |uniq -c |awk 'BEGIN{FS=" "}{OFS="\t"}{print $2}' |uniq -c |awk 'BEGIN{FS=" "}{OFS="\t"}{print $1}'> $SAMPLE.mut.uniq.num
