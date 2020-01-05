#!/bin/bash
#make sure to make txt files named old and new to update names, these can be found in the g_p_a.csv
module purge
module load anaconda/colsa
source activate snp-sites

dir=/mnt/lustre/jones/mhartwick/envir_GBE/isolate_fq/Short_read_archive_fq/gff/pan_genome_alignment/*
#edit names in aln files

sed -i 's/_.*//' *fa*
paste old new | while read a b; do sed -i "s/$a/$b/" *fa.aln ; done

for i in $dir; do
echo $i
j=$(echo $i | awk -F/ '{ print $11 }')
k=$(echo $j | awk -F. '{ print $1 }')
echo $k
#this step will make a vcf from a fasta file
snp-sites -v $j -o $k'.vcf'
#remove headers
grep -v '^##' $k'.vcf' > $k'_x.vcf'
#paste column with name
sed -i "s/$/\t$k/" $k'_x.vcf'
sed -i "1s/$k/gene/" $k'_x.vcf'
done

#gzip *aln
mv *_x.vcf vcf_files/
rm *vcf
