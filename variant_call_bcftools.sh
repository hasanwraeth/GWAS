#!user/bin/perl

bcftools mpileup -Ou -f GCF_000005845.2_ASM584v2_genomic.fna \
 -o SRR11866736.pileup.bcf SRR11866736.sort.bam
bcftools view SRR11866736.call.bcf | grep -v '^#'| wc -l 
bcftools norm -Ou -f GCF_000005845.2_ASM584v2_genomic.fna \
 -d all -o SRR11866736.norm.bcf SRR11866736.call.bcf 
