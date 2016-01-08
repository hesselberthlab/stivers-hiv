#! /usr/bin/env bash

#BSUB -J align[1-14]
#BSUB -e log/align.%J.%I.err
#BSUB -o log/align.%J.%I.out

set -o nounset -o pipefail -o errexit -x

source config.sh
sample=${SAMPLES[$(($LSB_JOBINDEX - 1))]}

read1="$DATA/$sample.R1.fq.gz"
read2="$DATA/$sample.R2.fq.gz"

fastqc -o fastqcresults/ $read1 $read2 
