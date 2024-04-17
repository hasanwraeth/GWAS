#!/bin/bash
#wget -O BBJ_LDLC.txt.gz http://jenger.riken.jp/61analysisresult_qtl_download/
#wget -O BBJ_HDLC.txt.gz http://jenger.riken.jp/47analysisresult_qtl_download/

mkdir resource
cd ./resource

# snplist
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/w_hm3.snplist.bz2

# EAS ld score files
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/eas_ldscores.tar.bz2

# EAS weight
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_EAS_weights_hm3_no_MHC.tgz

# EAS frequency
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_EAS_plinkfiles.tgz

# EAS baseline model
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/1000G_Phase3_EAS_baseline_v1.2_ldscores.tgz

# Cell type ld score files
wget https://storage.googleapis.com/broad-alkesgroup-public/LDSCORE/LDSC_SEG_ldscores/Cahoy_EAS_1000Gv3_ldscores.tar.gz