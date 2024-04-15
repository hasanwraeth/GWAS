#Library--------------------
library(data.table)
library(dplyr)
library(ggplot2)
# install.packages("bigsnpr") # run this if its your first time using this package
library(bigsnpr)
library(bigstatsr) # a useful dependency of bigsnpr

#Data--------------------
head(fam <- fread('data/penncath.fam'))

(clinical <- fread('data/penncath.csv'))

bim <- fread('data/penncath.bim')
head(bim)

snp_readBed("data/penncath.bed")

penncath <- snp_attach("data/penncath.rds")
# check out this bigSNP object 
str(penncath)

#Chromosome Check------------
penncath$map$chromosome |> table()

#Missing Data------------
class(penncath$genotypes)
big_counts(penncath$genotypes, ind.row = 1:10, ind.col = 1:10)
snp_stats <- big_counts(penncath$genotypes)
dim(snp_stats)
boxplot(snp_stats[4,]) 

summary(snp_stats[4,]) 

# summarize genotype data by *sample* 
sample_stats <- big_counts(penncath$genotypes, byrow = TRUE)
sample_stats[, 1:10]
boxplot(sample_stats[4,])

summary(sample_stats[4,])

#Heterozygosity Check------------
allele_dat <- sweep(x = sample_stats[1:3,], 
                    # ^ leave off 4th row -- don't count NAs here
                    MARGIN = 1,
                    STATS = c(0, 1, 0),
                    FUN = "*") |> colSums()

boxplot(allele_dat/ncol(snp_stats))
hist(allele_dat/ncol(snp_stats),
     main = "Zygosity",
     xlab = "Proportion of samples which are heterozygous") # should be bell-curved shaped

#MAF Filtering------------
hist(snp_stats[1,])
summary(snp_stats[1,])

#QC Implementation----------------
system("plink_mac_20231211/plink --version")

path_to_qc_penncath <- snp_plinkQC(
  plink.path = "plink_mac_20231211/plink", # you will need to change this according to your machine!
  prefix.in = "data/penncath", # input current data
  prefix.out = "data/qc_penncath", # creates *new* rds with quality-controlled data
  maf = 0.01
)

system("plink_mac_20231211/plink --bfile data/penncath --make-bed --out data/penncath_clean")

path_to_qc_penncath_bed <- snp_plinkQC(plink.path = "plink_mac_20231211/plink", # again, you may need to change this according to your machine!
                                       prefix.in = "data/penncath_clean", # input data
                                       prefix.out = "data/qc_penncath", # creates *new* rds with quality-controlled data
                                       maf = 0.01, # filter out SNPs with MAF < 0.01
                                       geno = 0.1, # filter out SNPs missing more than 10% of data
                                       mind = 0.1, # filter out SNPs missing more than 10% of data,
                                       hwe = 1e-10, # filter out SNPs that have p-vals below this threshold for HWE test
                                       autosome.only = TRUE) # we want chromosomes 1-22 only

qc_file_path <- snp_readBed(bedfile = path_to_qc_penncath_bed)
qc <- snp_attach(qc_file_path)
dim(qc$genotypes)

#Imputation-------------------
# create a bigSNP data object using data from PLINK files created in previous module 
# snp_readBed("data/qc_penncath.bed") # again, snp_readBed is a one-time thing
obj <- snp_attach("data/qc_penncath.rds")
# double check dimensions 
dim(obj$fam)
dim(obj$map) 
dim(obj$genotypes)
snp_stats <- bigstatsr::big_counts(obj$genotypes)
# ^ bigstatsr is loaded with bigsnpr, just being explicit here for didactic purposes
colnames(snp_stats) <- obj$map$marker.ID
snp_stats[,1:5]
(any_missing <- sum(snp_stats[4,] != 0)) # shows # of SNPs with NA values 
call_rates <- colSums(snp_stats[1:3,])/colSums(snp_stats) 
head(call_rates)

# impute based on mode
obj$geno_imputed <- snp_fastImputeSimple(Gna = obj$genotypes,
                                         method = "mode",
                                         ncores = nb_cores())
# save imputed values 
obj$geno_imputed$code256 <- bigsnpr::CODE_IMPUTE_PRED

# look to see that imputation was successful:
imp_snp_stats <- big_counts(X.code = obj$geno_imputed)
imp_snp_stats[,1:5] # all 0s in NA row 
obj <- bigsnpr::snp_save(obj)

#saveRDS(obj, file="obj.rds")

#Pop Structure-----------------
#PCA-------------
# read in our QC'd, imputed data
obj <- snp_attach("data/qc_penncath.rds")
# SVD 
svd_X <- big_SVD(obj$geno_imputed, # must have imputed data
                 big_scale(), # centers and scales data -- REALLY IMPORTANT! 
                 k = 10) # use 10 PCs for now -- can ask for more if needed
saveRDS(svd_X, "data/svd_X.rds")
# load data from above 
svd_X <- readRDS("data/svd_X.rds")
# look at what we have:
str(svd_X)
# scree plot
plot(svd_X) # 5 PCs seem to capture most of the variance
# plot PCs 1 and 2 
plot(svd_X, type = "scores") # first 2 PCs definately capture some separation

clinical <- fread('data/penncath.csv') |>
  mutate(across(.cols = c(sex, CAD),
                .fns = as.factor))
dplyr::glimpse(clinical)
plot(svd_X, type = "scores") +
  aes(color = clinical$sex) +
  labs(color = "Sex")

# get K 
K <- big_tcrossprodSelf(X = obj$geno_imputed,
                        fun.scaling = big_scale())
saveRDS(K, 'data/K.rds')
corrplot::corrplot(K[1:50, 1:50]*(1/ncol(obj$geno_imputed)),
                   is.corr = FALSE,
                   tl.pos = "n")

#Analysis-----------------------
# add the clinical data to the data in the fam file
# NOTE: the key here is to make IDs align

obj$fam <- dplyr::full_join(x = obj$fam,
                            y = clinical,
                            by = c('family.ID' = 'FamID'))
# calculate the PCs                          
pc <- sweep(svd_X$u, 2, svd_X$d, "*")
dim(pc) # will have same number of rows as U
names(pc) <- paste0("PC", 1:ncol(pc))

# Fit a logistic model between the phenotype and each SNP separately
y_train=as.numeric(obj$fam$CAD)
y_train[y_train=='2']=3
y_train[y_train=='1']=0
y_train[y_train=='3']=1
# while adding PCs as covariates to each model
obj.gwas <- big_univLogReg(X = obj$geno_imputed,
                           y01.train = y_train,
                           covar.train = pc[,1:5],
                           ncores = nb_cores())
# this takes a min or two, so I will save these results 
saveRDS(object = obj.gwas, file = "data/gwas.rds")

#Visualize-----------------
# Q-Q plot of the object
qq <- bigsnpr::snp_qq(obj.gwas)
qq

viridis22 <- c(rep(c("#fde725", "#90d743", "#35b779", "#21918c", "#31688e", 
                     "#443983", "#440154"), 3), "#fde725")
manh <- snp_manhattan(gwas = obj.gwas,
                      infos.chr = obj$map$chromosome,
                      infos.pos = obj$map$physical.pos,
                      colors = viridis22)
manh

# NB:  5 × 10e−8 is a common threshold for significance in GWAS studies, 
#   whereas 5 x 10e-6 is a common threshold for "suggestive" results

signif_threshold <- 5e-8 
suggest_threshold <- 5e-6 

(manh + 
    geom_hline(yintercept = -log10(signif_threshold),
               # note: plot y-axis is on -log10 scale 
               color = "#35b779",
               lty = 2) + 
    geom_hline(yintercept = -log10(suggest_threshold),
               color = "#443983",
               lty = 2)
)




