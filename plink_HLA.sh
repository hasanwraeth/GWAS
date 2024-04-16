#!/bin/bash

plinkFile="sample_data.clean"

./plink \
    --bfile ${plinkFile} \
    --make-set high-ld-hg19.txt \
    --write-set \
    --out hild