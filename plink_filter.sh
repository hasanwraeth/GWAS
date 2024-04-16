#!/bin/bash

genotypeFile="1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing/1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing"

./plink \
        --bfile ${genotypeFile} \
        --maf 0.01 \
        --geno 0.02 \
        --mind 0.02 \
        --hwe 1e-6 \
        --remove high_het.sample \
        --keep-allele-order \
        --make-bed \
        --out sample_data.clean