#!/bin/bash
plinkFile="1KG.EAS.auto.snp.norm.nodup.split.maf005.thinp020"
./gcta \
  --bfile ${plinkFile} \
  --autosome \
  --maf 0.01 \
  --make-grm \
  --out 1kg_eas

#the grm we calculated in step1
GRM=1kg_eas

# phenotype file
phenotypeFile=1kgeas_binary_gcta.txt

# disease prevalence used for conversion to liability-scale heritability
prevalence=0.5

# use 5PCs as covariates 
awk '{print $1,$2,$5,$6,$7,$8,$9}' plink_results_projected.sscore > 5PCs.txt

gcta \
  --grm ${GRM} \
  --pheno ${phenotypeFIile} \
  --prevalence ${prevalence} \
  --qcovar  5PCs.txt \
  --reml \
  --out 1kg_eas


#wget https://yanglab.westlake.edu.cn/software/gcta/bin/gcta-1.94.1-linux-kernel-3-x86_64.zip
#unzip gcta-1.94.1-linux-kernel-3-x86_64.zip
#cd gcta-1.94.1-linux-kernel-3-x86_64.zip