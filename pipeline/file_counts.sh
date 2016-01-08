#! /usr/bin/env bash
#BSUB -J count
#BSUB -e log/count.%J.err
#BSUB -o log/count.%J.err
source config.sh

#This file generates counts for all the files to import into a spreadsheet
for sample in ${SAMPLES[@]}; do
    bam=$sample/alignment/$sample.bam
    echo $sample
    samtools view -c $bam >> y_total.count 
done 

for sample in ${SAMPLES[@]}; do
    bam=$sample/alignment/$sample.bam
    echo $sample
    samtools view -c $bam HIV >> y_HIV.count
done

for sample in ${SAMPLES[@]}; do
    bam=$sample.rmdup.bam
    echo $sample
    samtools view -c $bam >>y_rmdup.count
done

for sample in ${SAMPLES[@]}; do
    bam=$sample.MD.bam
    echo $sample
    samtools view -c $bam >>y_MD.count
done

for sample in ${SAMPLES[@]}; do
    bam=$sample.chim.hiv.bam
    echo $sample
    samtools view -c $bam >>y_chim.count
done

for sample in ${SAMPLES[@]}; do
    bam=$sample.dis.hiv.bam
    echo $sample 
    samtools view -c $bam >>y_dis.count
done


