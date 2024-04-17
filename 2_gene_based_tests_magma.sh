#!/bin/bash
ref=./MAGMA/g1000_eas/g1000_eas
./MAGMA/magma \
	--bfile $ref \
	--pval ./ldsc/HDLC_chr3.magma.input.p.txt N=70657 \
	--gene-annot ./HDLC_chr3.genes.annot \
	--out HDLC_chr3
