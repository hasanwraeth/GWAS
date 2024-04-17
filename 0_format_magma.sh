#!/bin/bash
#for macos need to add '<' after zcat not for linux
zcat < ./ldsc/BBJ_HDLC.txt.gz | awk 'NR>1 && $2==3 {print $1,$2,$3}' > ./ldsc/HDLC_chr3.magma.input.snp.chr.pos.txt
zcat < ./ldsc/BBJ_HDLC.txt.gz | awk 'NR>1 && $2==3 {print $1,10^(-$11)}' >  ./ldsc/HDLC_chr3.magma.input.p.txt
