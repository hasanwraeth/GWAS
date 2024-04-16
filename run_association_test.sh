#!/bin/bash

genotypeFile="sample_data.clean"
phenotypeFile="1kgeas_binary.txt"
covariateFile="plink_results_projected.sscore"

covariateCols=6-10
colName="B1"
threadnum=2

./plink2 \
	--bfile ${genotypeFile} \
	--pheno ${phenotypeFile} \
	--pheno-name ${colName} \
	--maf 0.01 \
	--covar ${covariateFile} \
	--covar-col-nums ${covariateCols} \
	--glm hide-covar firth firth-residualize single-prec-cc \
	--threads ${threadnum} \
	--out 1kgeas
