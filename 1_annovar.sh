#!/bin/bash
#need to download annovar first by registering for free
input=annovar_input_firth.txt
humandb=./annovar/humandb
./annovar/table_annovar.pl ${input} ${humandb} -buildver hg19 -out myannotation -remove -protocol refGene -operation g -nastring . -polish


#Example: Downloading avsnp150 for hg19 from ANNOVAR
./annovar/annotate_variation.pl -buildver hg19 -downdb -webfrom annovar avsnp150 humandb/


#An example of annotation using multiple databases
# input file is in vcf format
./annovar/table_annovar.pl \
  ${in_vcf} \
  ${humandb} \
  -buildver hg19 \
  -protocol refGene,avsnp150,clinvar_20200316,gnomad211_exome \
  -operation g,f,f,f \
  -remove \
  -vcfinput \
  -out ${out_prefix} \ 