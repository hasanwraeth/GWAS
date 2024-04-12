#!usr/bin/bash
#Find stats from multi_qc report and genome.fna file
#Velvet advisor
conda install spades
spades.py -1 SRR11866736_1.fastq.gz -2 SRR11866736_2.fastq.gz\
 -k 125 --cov-cutoff auto -o test_assembly

