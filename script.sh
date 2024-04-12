#!

#For paired ended data
fastq-dump --gzip --defline-qual '+' --split-e SRR11866736/SRR11866736.sra

#Download E.coli reference genome
wget  ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz

#Burrows-Wheeler Transformation

#For zipped files
zgrep
zless 
grep -P -o 'ENST\d{11}' weeks/123.fasta > E.txt

>> #append

#Paste columns together
paste -d ',' E.txt I.txt > R.csv

#Illumina iGenomes has index files for BWA and Bowtie2 for some organisms
bowtie2-build GCF_000005845.2_ASM584v2_genomic.fna ecoli_k12
bowtie2 -x ecoli_k12 -1 SRR11866736_1.fastq.gz -2 SRR11866736_2.fastq.gz -S SRR11866736.sam
#time = time needed #-p 40 = 40 cores
time bowtie2 -p 40 -x ecoli_k12 -1 SRR11866736_1.fastq.gz -2 SRR11866736_2.fastq.gz -S SRR11866736.sam

#SAM to BAM
samtools view -b -o SRR11866736.bam SRR11866736.sam 
samtools sort -o SRR11866736.sort.bam SRR11866736.bam
samtools view -H SRR11866736.bam
samtools index SRR11866736.sort.bam
samtools view SRR11866736.sort.bam NC_000913.3:10000-20000 | wc -l
samtools flagstat SRR11866736.sort.bam

#bcftools #-Ob=bcf v=vcf u=bcf uncompressed
bcftools mpileup -Ou -f GCF_000005845.2_ASM584v2_genomic.fna -o SRR11866736.pileup.bcf SRR11866736.sort.bam
bcftools call -m -v -Ou -o SRR11866736.call.bcf SRR11866736.pileup.bcf 
bcftools view SRR11866736.call.bcf | less
#variants called
bcftools view SRR11866736.call.bcf | grep -v '^#'| wc -l 
#tidy up indel calls
bcftools norm -Ou -f GCF_000005845.2_ASM584v2_genomic.fna -d all -o SRR11866736.norm.bcf SRR11866736.call.bcf 
#filter #or -i 'QUAL>=40'
bcftools filter -Ob -e 'QUAL<40 || DP<10 || GT!="1/1"' -o SRR11866736.variants.bcf SRR11866736.norm.bcf 
bcftools view SRR11866736.variants.bcf | grep -v '^#'| wc -l 
bcftools view -Ov -o SRR11866736.variants.vcf SRR11866736.variants.bcf
bcftools mpileup [...] | bcftools call [...] | bcftools filter [...] -o SRR11866736.bcf


#Stream editor
sed 's/NC_000913.3/NC_000913/' SRR11866736.variants.vcf 


#Task manager
top
htop

tail -F #dynamic viewing
gunzip #to unzip

#find files
find ./Shared -name "*gencode*"

#GitHub just use github app
git config --global user.name ""
git config --global user.email ""
git config --global color.ui true
git config --global core.editor "nano"
git status
#staging
git add filename
git commit -m "Loop added"
#commit w/o add = -a flag
git commit -a -m "Changed if statement"
#show changes before commit compared to previous commit b=latest
git diff
git log
#move and delete should be done through git to avoid confusions
git mv filename filename2
#exclude from git
echo 'data' > .gitignore
#desctructive commit, rollback, hard reset deletes destructive commits
git reset --hard "commit #"
git clone "link"
git remote add "name" "link"
gut push origin master
git pull origin master
ssh-keygen -t rsa
git branch newbranch
#-b to make and enter newbranch, -d deletes branch
git checkout newbranch
git checkout master
git merge newbranch
#Atom text editor
#Git integration to R studio just need to add project file to a git directory
#nextflow ex1.nf -resume
#nextflow ex1.nf --str "Hasan Al Reza"




