#!/bin/bash

genotypeFile="1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing/1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing"

./plink \
    --bfile ${genotypeFile} \
    --chr 22 \
    --r2 \
    --out plink_results22