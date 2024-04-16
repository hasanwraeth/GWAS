#!/bin/bash

genotypeFile="1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing/1KG.EAS.auto.snp.norm.nodup.split.rare002.common015.missing"

./plink \
    --bfile ${genotypeFile} \
    --extract plink_results.prune.in \
    --het \
    --out plink_results