#!/bin/bash
input=annovar_input_firth.txt
humandb=./annovar/humandb
./annovar/table_annovar.pl ${input} ${humandb} -buildver hg19 -out myannotation -remove -protocol refGene -operation g -nastring . -polish
