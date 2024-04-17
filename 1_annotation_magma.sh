#!/bin/bash
snploc=./ldsc/HDLC_chr3.magma.input.snp.chr.pos.txt
ncbi37=./MAGMA/NCBI37.3/NCBI37.3.gene.loc
./MAGMA/magma --annotate \
      --snp-loc ${snploc} \
      --gene-loc ${ncbi37} \
      --out HDLC_chr3
