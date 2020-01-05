# Population-Adaptations
Scripts to Assemble, Annotate and Analyze Microbial Genomes and Populations

![alt text](https://github.com/meghartwick/Population-Adaptations/blob/master/heatmapped.png)

*code for this graphic provide in `heatmap.R` and explained in 'Visualizing the Pangenome'*
# Introduction

This is a 'work in progress' pipeline to assemble, annotate and analyze bacterial genomes for evidence of adaptation using a pangenome framework. No program installation information is provided but I will link to the programs that are used in this documentation. Some scripts are executable and I provide the documentation for their usage below. Others are still being developped but they are documented and I will summarize their application clearly. I'm happy to provide any information and clarify any questions about any of the steps or code. 

# Assembly and Annotation

The first step in any population analysis is to assemble, annotate and QA/QC the genomes. `assemble_annotate_ST.sh` is a executable program that takes a fastq file and the identifier that you would like to assign as its input. The fastqc file is evaluated by fastqc, trimmed for adapters and low quality reads in trimmomatic and assembled with SPAdes. The assembley is evaluated by Quast then annotated by Prokka. The final step in this program is to assign a *Vibrio parahaemolyticus* sequence type (ST) with SRTS2.

Usage
```
sh assemble_annotate_ST.sh <filename.fastqc> <target identifier> 
```

# Pangenome Analysis

For pangenome analysis and the majority of analysis that follows I use the output files from [Roary](https://sanger-pathogens.github.io/Roary/). Roary is well documented, provides scripts and links to complementary programs for visualization and further pangenome analysis and very helpful output files. The standard input files for Roary are GFF3 files which I make in Prokka, but they also provide links and scripts for workinig with different input files.  

The most basic usage of Roary is to put all your .gff files in one directory and: 

```
roary *.gff
```
To make the output files that I like to have, I use: 

```
roary -e -r -z *.gff
```
`-e` uses PRANK instead of mafft to make a core alignment
`-r` produces really helpful graphical summaries from R
`-z` keeps the intermediate files that I find very useful

Once Roary is complete you can immediately visualize your pangenome by using a python script 
```
roary_plots.py name_of_your_newick_tree_file.tre gene_presence_absence.csv
```
or navigating to a [Phandango website](http://jameshadfield.github.io/phandango/#/) where you can drag and drop your accessory genome tree file (.tre) and the gene_presence_absence.csv

# Phylogenetic Analysis

Though there are lots of reasons that phylogenetic analysis of bacterial populations can be misleading, I like to start here. I think it provides a basis to compare your study to other work and gives context to the downstream outcomes. 

Roary provides a `.tre` file for the accessory genome. I use the `SRST2_MLST.sh` to create a fasta file from the SRST2 ouput of the `assemble_annotate_ST.sh` and align the fasta file in mafft. I use [RAxML](https://cme.hits.org/exelixis/web/software/raxml/index.html) to make `tre` files from the core genome alignment made in Roary and the MLST alignment from SRST2 and mafft. `core_alignment.sh` provides basic scripts to run RAxML and recombination analysis in ClonalFrameML. These output can be visualized quickly in R with ggtree or in the gui [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)   

The intermediate files from Roary include an alignment file for each genome of all the genes in the pangenome. If you have identified specific genes of interest that you would like to run through phylogenetic and recombination analysis, these can be concatonated, aligned and analyzed with `core_alignment.sh`. A custom annotated VCF file can also be made from these intermediate files with `make_vcf.sh`. This is very helpful is you want to perform whole genome phylogenies or look for evidence of selection in specific genes. This approach only uses coding regions so there are some definite drawbacks to this appraoch in the big picture as it is excludes non-coding regions of the genome.    

# Gene Presence and Absence

Simple gene presence and absence can provide useful basic summaries of the differences between genomes. If you are trying to identify differences between groups of genomes that may relate to meta variables, these can be investigated using univariate approaches (ANOVA, student's-t) with corrections for multiple comparisons or multivariate analysis (PCoA, NMDS, MRPP, ISA) that are easily implemented in R with add-on packages `vegan` and `indicspecies`. I will be providing code for these analysis using user created meta data and the `gene_presence_absence.Rtab` Roary file soon. 

# Function and GO

Grouping genes into categories of function can overcome some of the challenges of interpretting gene presence/absence data especially in pangenome analysis where genes annotated with different identifiers act in the same way or when there are a large number of genes annotates as hypothetical proteins. Grouping these genes by function creates larger 'bins' in the daata and may help resolve some of the noise from genomes that are highly diverse. The `GOandFunction.sh` provides the code to annotate the Roary `pangenome.fasta` with Uniprot identiers using a custom BLAST. Once the genes from the pangenome have Uniprot identifiers the corresponding GO ID can be linked to the Roary gene id and the `gene_presence_abscence.Rtab`. `GO.db` and `TopGO` in R can be used to explore the acyclic hierchical structure of GO terms. `TopGO` as well as the analysis from the # Gene Presence and Absence section can be used to look for evidence of functional enrichment in between categories of interest. 

# Visualizing the Pangenome

Once you have analyzed the patterns of SNPs, gene presence/absence and function in your pangenome, it is very helpful to be able to produce a visualization that can effectively summarize your findings. The code in `Heatmap.R` provides some steps to create a customizable graphic of the meta data, associated function or presence/absence and phylogenetic relationships in the genomes from your population. 

# Comparing Populations

![alt text](https://github.com/meghartwick/Population-Adaptations/blob/master/worldmap.png)






