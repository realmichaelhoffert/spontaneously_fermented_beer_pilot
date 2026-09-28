#!/bin/bash
#SBATCH --job-name=genotypeGVCFs
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --account=ucb712_asc1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=72G
#SBATCH --time=24:00:00
#SBATCH --output=genotypeGVCFs_%A_%a.out
#SBATCH --error=genotypeGVCFs_%A_%a.err

# ---- edit these paths ----
GATK=/projects/miho1832/gatk-4.2.3.0/gatk
REF=/scratch/alpine/miho1832/beer/data/gatk_yeast/yeast_files/Sace_S288c_reference_FullMatrixID.fna
DB_PREFIX=Combined_DATABASE
OUTDIR=./genotyped_vcfs
# ---------------------------

# list of chromosomes, one per line
CHROM_FILE=$1
mapfile -t CHROM_LIST < $CHROM_FILE
CHROM=${CHROM_LIST[$SLURM_ARRAY_TASK_ID]}


mkdir -p $OUTDIR

$GATK --java-options "-Xmx70G" GenotypeGVCFs \
    --intervals $CHROM \
    -R $REF \
    -V gendb://${DB_PREFIX} \
    -O ${OUTDIR}/${DB_PREFIX}.${CHROM}.vcf.gz

