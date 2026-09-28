#!/bin/bash

set -eo pipefail

echo "DP10 filter"
bcftools +setGT Combined_DATABASE.vcf.gz -- -t q -n . -e 'FMT/DP>-10' | bcftools +fill-tags | bcftools view -Oz -o Combined_DATABASE.DP10.vcf.gz
echo "GQ20 filter"
bcftools +setGT Combined_DATABASE.DP10.vcf.gz -- -t q -n . -e 'FMT/GQ>=20' | bcftools +fill-tags | bcftools view -Oz -o Combined_DATABASE.DP10.GQ20.vcf.gz
echo "sample missing filter"
bcftools stats -s - Combined_DATABASE.DP10.GQ20.vcf.gz | grep -E ^PSC | cut -f3,14 > Combined_DATABASE.DP10.GQ20.imiss
nSites=$(bcftools +counts Combined_DATABASE.DP10.GQ20.vcf.gz | grep "Number of sites" | rev | cut -d " " -f 1 | rev)
awk -v nSites=$nSites '{if ($2 / nSites <= 0.2) print $1}' Combined_DATABASE.DP10.GQ20.imiss > Samples.Mind20

# filtering
bcftools view --samples-file Samples.Mind20 Combined_DATABASE.DP10.GQ20.vcf.gz | bcftools +fill-tags | bcftools view -Oz -o Combined_DATABASE.DP10.GQ20.Mind20.vcf.gz
