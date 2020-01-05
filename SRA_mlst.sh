##Query the SRA (short read archive)
##Download SRA check ST, append SRA-ID and ST to new file
##delete file, move on to the next file in the list

#!/bin/bash

for i in $(cat try.txt);
do
dt="$(echo "$i"|tr -d '\r')"
echo $dt

module purge
module load anaconda/colsa
source activate sra_wrapper

fastq-dump --split-files $dt
#parallel-fastq-dump --sra-id SRR748205 --threads 16 --outdir $dt/ --split-files --gzip

conda deactivate
source activate srst2-0.2.0

cd $dt/
gunzip *gz
cp *_1*  $dt'_S1_L001_R1_001.fastq'
cp *_2* $dt'_S1_L001_R2_001.fastq'

srst2 --input_pe $dt'_S1_L001_R1_001.fastq' $dt'_S1_L001_R2_001.fastq'  --output $dt --threads 4 --mlst_db /mnt/lustre/jones/mhartwick/my_databases/SRST_Vp/*fasta --mlst_definitions /mnt/lustre/jones/mhartwick/my_databases/SRST_Vp/vparahaemolyticus.txt --mlst_delimiter '_'

cat *results.txt > ST.txt
#tail -1 *results.txt > n.txt
#cat n.txt ../ST.txt >> ../ST.txt

cd ../
rm -r $dt/

conda deactivate

done

