#!/bin/bash

genotypeFile="1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing/1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing"

#extract the 1000 samples with the pruned SNPs, and make a bed file.
./plink \
    --bfile ${genotypeFile} \
    --extract plink_results.prune.in \
    --make-bed \
    --out plink_1000_pruned

#convert the bed/bim/fam to ped/map
./plink \
        --bfile plink_1000_pruned \
        --recode \
        --out plink_1000_pruned