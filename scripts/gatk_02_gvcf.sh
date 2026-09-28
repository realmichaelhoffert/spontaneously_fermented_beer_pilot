#!/bin/bash
set -euo pipefail

# using beer_metagenomics env
# /data/mhoffert/miniconda3/envs/beer_metagenomics
# adapted from https://zenodo.org/records/12580561
# Scripts.tar.gz: Scripts/02_SNPCalling.sh


REF=/data/mhoffert/fiererlab/beer/data/gatk_yeast/yeast_files/Sace_S288c_reference_FullMatrixID.fna
IND=$1
OUTPUT=/data/mhoffert/fiererlab/beer/data/gatk_yeast/gatk_procedure/${IND}

~/tools/gatk-4.2.3.0/gatk HaplotypeCaller -R $REF -I $OUTPUT.bam -O $OUTPUT.g.vcf.gz --emit-ref-confidence GVCF
