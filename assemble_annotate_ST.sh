#!/bin/sh
#Assembly pipeline

mv *_R1_001.fastq.gz $1.R1.fastq.gz
mv *_R2_001.fastq.gz $1.R2.fastq.gz

fastqc $1.R1.fastq.gz

fastqc $1.R2.fastq.gz

mkdir qc_analysis
mv *qc* qc_analysis/

#trimmomatic PE -phred33 4826.R1.fastq.gz 4826.R2.fastq.gz output_forward_paired.fq.gz output_forward_unpaired.fq.gz output_reverse_paired.fq.gz output_reverse_unpaired.fq.gz ILLUMINACLIP:$HOME/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

trimmomatic PE -phred33 -trimlog $1_log $1.R1.fastq.gz $1.R2.fastq.gz $1_output_forward_paired.fq.gz $1_output_forward_unpaired.fq.gz $1_output_reverse_paired.fq.gz $1_output_reverse_unpaired.fq.gz ILLUMINACLIP:$HOME/adapters/NexteraPE-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36


#spades.py -h
#spades.py --pe1-12 lib1_1.fastq --pe1-12 lib1_2.fastq --pe1-s lib1_unpaired_1.fastq --pe1-s lib1_unpaired_2.fastq  -o spades_$
#spades.py --pe1-1 output_forward_paired.fq.gz --pe1-2 output_reverse_paired.fq.gz --pe1-s output_forward_unpaired.fq.gz --pe2$

spades.py --pe1-1 $1_output_forward_paired.fq.gz --pe1-2 $1_output_reverse_paired.fq.gz --pe1-s $1_output_forward_unpaired.fq.gz --pe1-s $1_output_reverse_unpaired.fq.gz -o spades_output

mkdir trimmomatic
mv *paired* trimmomatic/

#quast
cd $HOME/envir_GBE/isolate_fq/Sample_$1/spades_output
python /mnt/lustre/software/linuxbrew/colsa/bin/quast scaffolds.fasta -o $HOME/envir_GBE/isolate_fq/Sample_$1/quast/$1

mv contigs.fasta $1_contigs.fasta
mv scaffolds.fasta $1_scaffolds.fasta

prokka --outdir $HOME/envir_GBE/isolate_fq/Sample_$1/prokka_output --prefix $1 --genus Vibrio *contigs.fasta

cd $HOME/envir_GBE/isolate_fq/Sample_$1/prokka_output
cp *gff $HOME/envir_GBE/isolate_fq/gff


module purge
module load anaconda/colsa
source activate srst2-0.2.0

cd $HOME/envir_GBE/isolate_fq/Sample_$1/
gunzip *fastq.gz
mkdir $HOME/envir_GBE/isolate_fq/Sample_$1/SRST2

cp $1.R1.fastq $HOME/envir_GBE/isolate_fq/Sample_$1/SRST2/$1_S1_L001_R1_001.fastq
cp $1.R2.fastq $HOME/envir_GBE/isolate_fq/Sample_$1/SRST2/$1_S1_L001_R2_001.fastq

cd $HOME/envir_GBE/isolate_fq/Sample_$1/SRST2/

srst2 --input_pe $1_S1_L001_R1_001.fastq $1_S1_L001_R2_001.fastq  --output $1  --report_all_consensus --mlst_db /mnt/lustre/jones/mhartwick/my_databases/SRST_Vp/*fasta --mlst_definitions /mnt/lustre/jones/mhartwick/my_databases/SRST_Vp/vparahaemolyticus.txt --mlst_delimiter '_'

source deactivate
module purge
module load linuxbrew/colsa

gzip *S1_L001*

cd ..

gzip *.fastq


echo "All Done!!!!"
