#run a phylogenetic and recombination analysis of the core genome 
#!/bin/sh

raxmlHPC-PTHREADS-AVX -s core_gene_alignment.fasta -n raxml_GBE_core.out -m GTRCAT -f a -x 123 -T 16 -N autoMRE -p 456
cp RAxML_bestTree.raxml_GBE_core.out RAxML_bestTree.raxml_GBE_core.nwk
ClonalFrameML RAxML_bestTree.raxml_GBE_core.nwk core_gene_alignment.fasta core_genome_recomb -embranch

echo 'core genome analysis!'
