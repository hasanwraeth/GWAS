#!/bin/bash

source /home/hasan/miniconda3/etc/profile.d/conda.sh
conda activate alignment

#saves alignment to -S
bowtie2 -x ecoli_k12 -1 SRR11866736_1.fastq.gz -2 SRR11866736_2.fastq.gz -S SRR11866736.sam

#produce alignment to std out #not recommended as buffer gets depleted
bowtie2 -x ecoli_k12 -1 SRR11866736_1.fastq.gz -2 SRR11866736_2.fastq.gz \
	 | samtools view -b -o SRR11866736.bam


