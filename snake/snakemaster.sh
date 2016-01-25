#! /usr/bin/env bash

#BSUB -J snakemaster
#BSUB -o results-stivers-hiv/log/snakemaster_log.%J.out
#BSUB -e results-stivers-hiv/log/snakemaster_log.%J.err

workdir="results-stivers-hiv"
if [[ ! -d $workdir/log ]]; then
    mkdir -p $workdir/log
fi

drmaa_args=" -q normal -n {threads} -o {log}.out -e {log}.err \
-R 'span[hosts=1]' -J {params.job_name}"

snakemake --configfile config.yaml --jobs 32 --drmaa "$drmaa_args"
