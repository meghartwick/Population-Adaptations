#!/bin/sh

run_gubbins.py --threads 16 *core_gene_alignment.aln
raxmlHPC-PTHREADS-AVX -s core_gene_alignment.fasta -n raxml_GBE_core.out -m GTRCAT -f a -x 123 -T 16 -N autoMRE -p 456

#module purge
#module load anaconda/colsa

#source activate  snp-sites
#snp-sites -v core_gene_alignment.aln

#source deactivate
#module purge
#module load linuxbrew/colsa

cp RAxML_bestTree.raxml_GBE_core.out RAxML_bestTree.raxml_GBE_core.nwk
ClonalFrameML RAxML_bestTree.raxml_GBE_core.nwk core_gene_alignment.fasta core_genome_recomb -embranch

echo 'core genome analysis!'
