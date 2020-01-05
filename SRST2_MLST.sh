#!/bin/bash
#use with file_loop1.sh to move all SRST2 output to new directory and reformat with filename header
#can be used as input for alignments, trees etc
for F in ./*.fasta; do
  T=${F##*/} ## Removes directory part. Same as $(basename "$F")
  T=${T%.all_consensus_alleles.fasta}
  cat $F | paste - - < $F | sort -k1 -u | awk '{$1=$2=""}1' | xargs | sed -e 's/ //g' > $T.txt
  sed -i '1i>'"$T"'\' $T.txt
done
