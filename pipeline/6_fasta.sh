#! /usr/bin/env bash

#BSUB -J segment
#BSUB -e log/segment.J.err
#BSUB -o log/segment.J.out

# to call the input files
vcf1=JS208.vcf
vcf2=JS215.vcf
# to obtain the upstream and downstream bases and generate a bed file
# this uses the original vcf files so may need slightly modified to work
# with the new ones
cat $vcf1 |awk '{OFS="\t"}{print $1, $2-3, $2+2, 1}' >JS208.bed
cat $vcf2 |awk '{OFS="\t"}{print $1, $2-3, $2+2, 1}' >JS215.bed
# This converts the bed file to a tab file so getfasta runs there is some
# spacing issue here that had to be addressed
unexpand JS208.bed >JS208.u.bed
unexpand JS215.bed >JS215.u.bed

#This generates the fasta file
bedtools getfasta -fi ~/projects/mutation-mapping/results/hiv.ref/HIV.fasta -bed JS208.bed -fo JS208.fa
bedtools getfasta -fi ~/projects/mutation-mapping/results/hiv.ref/HIV.fasta -bed JS215.bed -fo JS215.fa
#This gets the reverse complement of the fasta file
fastx_reverse_complement -i JS208.fa -o JS208.rev.fa
fastx_reverse_complement -i JS215.fa -o JS215.rev.fa
