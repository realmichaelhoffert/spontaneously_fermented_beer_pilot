#!/bin/bash

set -eo pipefail

# =============================================================================
# Project         : Full SaCe SNP matrix
# title           : 3_CombineGVCF.sh
# description     : This script merge GVCF files in a GVCF database with the
#                   gatk genomicsDBImport function. It is the third step for 
#                   the construction of the Full SaCe SNP matrix. 
#                   The script requires 4 CPUs. 
# author          : vloegler, mhoffert
# date            : 2022/11/04, modified 06-2026
# version         : 1.0
# usage           : bash 3_CombineGVCF.sh -o OutputPrefix -b Reference.fasta.bed *.g.vcf.gz 
# =============================================================================

# using beer_metagenomics env
# /data/mhoffert/miniconda3/envs/beer_metagenomics


usage() { echo "Usage: bash gatk_03_combine.sh -o OutputPrefix -b Reference.fasta.bed *.g.vcf.gz
                " 1>&2; exit 0; }

while getopts ':o:b:' flag
do
    case "${flag}" in
        o) PREFIX=${OPTARG};;
        b) BED=${OPTARG};;
        *) usage
           
    esac
done

if [ -z "$PREFIX" ] || [ -z "$BED" ]; then
    echo "PREFIX (-p) for output and BED (-b) must be defined"
    usage
fi

GVCF_FILES=""
for ARG in "$@" 
do
    if [ $ARG != "-o" ] && [ $ARG != "-b" ] && [ $ARG != $PREFIX ] && [ $ARG != $BED ]
    then
        GVCF_FILES=${GVCF_FILES}"-V $ARG "
    fi
done

# Build GVCF database over all chromosomes
~/tools/gatk-4.2.3.0/gatk GenomicsDBImport --batch-size 20 --genomicsdb-workspace-path ${PREFIX}_DATABASE -L $BED $GVCF_FILES
