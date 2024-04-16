#!/bin/bash

plinkFile="sample_data.clean"
outPrefix="plink_results"
hildset=hild.set 
threadnum=2

# LD-pruning, excluding high-LD and HLA regions
./plink2 \
        --bfile ${plinkFile} \
        --maf 0.01 \
        --threads ${threadnum} \
        --exclude ${hildset} \
        --indep-pairwise 500 50 0.2 \
        --out ${outPrefix}

# Remove related samples using king-cuttoff
./plink2 \
        --bfile ${plinkFile} \
        --extract ${outPrefix}.prune.in \
        --king-cutoff 0.0884 \
        --threads ${threadnum} \
        --out ${outPrefix}

# PCA after pruning and removing related samples
./plink2 \
        --bfile ${plinkFile} \
        --keep ${outPrefix}.king.cutoff.in.id \
        --extract ${outPrefix}.prune.in \
        --freq counts \
        --threads ${threadnum} \
        --out ${outPrefix} \
        --pca approx allele-wts 10 \


# Projection (related and unrelated samples)
./plink2 \
        --bfile ${plinkFile} \
        --threads ${threadnum} \
        --read-freq ${outPrefix}.acount \
        --score ${outPrefix}.eigenvec.allele 2 5 header-read no-mean-imputation variance-standardize \
        --score-col-nums 6-15 \
        --out ${outPrefix}_projected \
