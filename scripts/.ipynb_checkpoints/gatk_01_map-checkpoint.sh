#!/bin/bash
set -euo pipefail
# using beer_metagenomics env
# /data/mhoffert/miniconda3/envs/beer_metagenomics
# adapted from https://zenodo.org/records/12580561
# Scripts.tar.gz: Scripts/01_ReadsMapping.sh

REF=/data/mhoffert/fiererlab/beer/data/gatk_yeast/yeast_files/Sace_S288c_reference_FullMatrixID.fna
IND=$1
# SAMTOOLS=~/tools/samtools-1.17/samtools

# declare variables
FORWARD=/data/mhoffert/fiererlab/beer/data/trimmed_reads/${IND}_R1.trimmed.fastq.gz
REVERSE=/data/mhoffert/fiererlab/beer/data/trimmed_reads/${IND}_R2.trimmed.fastq.gz
OUTPUT=/data/mhoffert/fiererlab/beer/data/gatk_yeast/gatk_procedure/${IND}

# then align and sort
echo "Aligning $IND with bwa"
/data/mhoffert/tools/bwa-mem2-2.3_x64-linux/bwa-mem2 mem -t 4 $REF $FORWARD $REVERSE | samtools sort -o $OUTPUT.bam -T reads.$IND.tmp
/data/mhoffert/tools/gatk-4.2.3.0/gatk AddOrReplaceReadGroups -I $OUTPUT.bam -O $OUTPUT.bam.ReadGroups --RGID $IND --RGLB $IND --RGPL ILLUMINA --RGPU $IND --RGSM $IND
rm -f $OUTPUT.bam
mv $OUTPUT.bam.ReadGroups $OUTPUT.bam
samtools index $OUTPUT.bam
