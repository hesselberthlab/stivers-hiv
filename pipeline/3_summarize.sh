#!/usr/bin/env bash

#BSUB -J summary 
#BSUB -o log/summary.%J.out
#BSUB -e log/summary.%J.err

set -o nounset -o pipefail -o errexit -x

source config.sh
out=$RESULT/combined22.tab.gz

index_type="virus"
strands=("pos" "neg")

for sample in ${SAMPLES[@]}; do

    samplenum=$(echo $sample | sed 's/JS//')
    hyb="enriched"

    if [[ $samplenum -gt 213 ]]; then
        treatment="udg"
    else
        treatment="none"
    fi
    if [[ $samplenum -eq 207 || $samplenum -eq 214 ]]; then
        expname="1:-V MDM"
    elif [[ $samplenum -eq 208 || $samplenum -eq 215 ]]; then
        expname="2:V MDM DP7"
    elif [[ $samplenum -eq 209|| $samplenum -eq 216 ]]; then
        expname="3:V MDM DP14"
    elif [[ $samplenum -eq 210 || $samplenum -eq 217 ]]; then
        expname="4:V MDM RTX:DPI1"
    elif [[ $samplenum -eq 211 || $samplenum -eq 218 ]]; then
        expname="5:V MDM RTX:RAL:DPI1"
    elif [[ $samplenum -eq 212 || $samplenum -eq 219 ]]; then
        expname="6:V MDM RTX:DPI30"
    elif [[ $samplenum -eq 213 || $samplenum -eq 220 ]]; then
        expname="7:V MDM RTX:RAL:DPI30"
    fi

    bgresults=$RESULT/$sample/bedgraphs

    for strand in ${strands[@]}; do

        countstab=$bgresults/$sample.strand.$strand.counts.tab.gz

        zcat $countstab \
            | awk '$1 == "HIV"' \
            | awk -v strand=$strand \
                -v sample=$sample -v treatment=$treatment \
                -v hyb=$hyb -v expname="$expname" -v scale="raw" \
                'BEGIN {OFS="\t"} {print $2, $3, sample, strand, 
                treatment, hyb, expname, scale}'
    done

done | gzip -c > $out 

