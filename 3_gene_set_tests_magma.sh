#!/bin/bash
geneset=./MAGMA/msigdb_v2022.1.Hs_files_to_download_locally/msigdb_v2022.1.Hs_GMTs/msigdb.v2022.1.Hs.entrez.gmt
./MAGMA/magma \
	--gene-results ./HDLC_chr3.genes.raw \
	--set-annot ${geneset} \
	--out HDLC_chr3
