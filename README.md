# Population-Adaptations
Assemble, Annotate and Analyze Microbial Genomes and Populations

![alt text](https://github.com/meghartwick/Population-Adaptations/blob/master/heatmapped.png)

*code for this graphic provide in `heatmap.R` and explained in 'Visualizing the Pangenome'*
# Introduction

This is a 'work in progress' pipeline to assemble, annotate and analyze bacterial genomes for evidence of adaptation using a pangenome framework. No program installation information is provided but I will link to the programs that are used in this documentation. Some scripts are executable and I provide the documentation for their usage below. Others are still being developed but they are documented and I will summarize their application clearly. I'm happy to provide any information and clarify any questions about any of the steps or code. 

## Assembly and Annotation

The first step in any population analysis is to assemble, annotate and QA/QC the genomes. `assemble_annotate_ST.sh` is an executable program that takes a fastq file and the identifier that you would like to assign as its input. The fastqc file is evaluated by fastqc, trimmed for adapters and low quality reads in trimmomatic and assembled with SPAdes. The assembly is evaluated by Quast then annotated by Prokka. The final step in this program is to assign a *Vibrio parahaemolyticus* sequence type (ST) with SRTS2.

Usage
```
sh assemble_annotate_ST.sh <filename.fastqc> <target identifier> 
```

## Pangenome Analysis

For pangenome analysis and the majority of analysis that follows I use the output files from [Roary](https://sanger-pathogens.github.io/Roary/). Roary is well documented, provides scripts and links to complementary programs for visualization and further pangenome analysis and very helpful output files. The standard input files for Roary are GFF3 files which I make in Prokka, but they also provide links and scripts for workinig with different input files.  

The most basic usage of Roary is to put all your .gff files in one directory and: 

```
roary *.gff
```
To make the output files that I like to have, I use: 

```
roary -e -r -z *.gff
```
```
-e uses PRANK instead of mafft to make a core alignment
-r produces really helpful graphical summaries from R
-z keeps the intermediate files that I find very useful
```

Once Roary is complete you can immediately visualize your pangenome by using their python script 
```
roary_plots.py name_of_your_newick_tree_file.tre gene_presence_absence.csv
```
or navigating to a [Phandango website](http://jameshadfield.github.io/phandango/#/) where you can drag and drop your accessory genome tree file (.tre) and the gene_presence_absence.csv

## Phylogenetic Analysis

I like to start with phylogenetic analysis even though the results from bacterial populations can be hard to interpret (... a little wonky). It provides a basis to compare your study to other work and gives context to the downstream outcomes. 

Roary provides a `.tre` file for the accessory genome. I make an alignment file of the ST MLST with `SRST2_MLST.sh` to create a fasta file from the SRST2 output of the `assemble_annotate_ST.sh` and align the fasta file in mafft. I use [RAxML](https://cme.hits.org/exelixis/web/software/raxml/index.html) to make `tre` files from the core genome alignment from Roary and the MLST alignment. `core_alignment.sh` provides basic scripts to run RAxML and recombination analysis in ClonalFrameML. The output can can be visualized quickly in R with `ggtree` or in the gui [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)   

If you have identified specific genes of interest that you would like to run through phylogenetic and recombination analysis, these can be merged and aligned, then analyzed with `core_alignment.sh`.

A custom annotated VCF file can also be made from the alignment files you retained by using `-z`. `make_vcf.sh` will create concatenated alignments of your genes of interest for each genome in the pangenome and produce an annoated VCF file. This is very helpful if you want to create whole genome phylogenies or look for evidence of selection in specific genes. This approach only uses coding regions so there are some definite drawbacks to this approach since it is excludes non-coding regions.    

## Gene Presence and Absence

Simple gene presence and absence can provide useful basic summaries of the differences between genomes. If you are trying to identify differences between groups of genomes that may relate to meta variables, these can be investigated using univariate approaches (ANOVA, Student's-t) with corrections for multiple comparisons or multivariate analysis (PCoA, NMDS, MRPP, ISA) that are easily implemented in R with add-on packages `vegan` and `indicspecies`. I will be providing code for these analysis using user created meta data and the Roary `gene_presence_absence.Rtab`. 

## Function and GO

Grouping genes into categories of function can overcome some of the challenges of interpreting gene presence/absence data, especially in pangenome analysis where genes annotated with different identifiers act in the same way or when there are a large number of genes annotated as hypothetical proteins. Grouping these genes by function creates larger 'bins' in the data and may help resolve some of the noise from genomes that are highly diverse. The `GOandFunction.sh` provides the code to annotate the Roary `pangenome.fasta` with Uniprot identiers using a custom BLAST. Once the genes from the pangenome have Uniprot identifiers the corresponding GO ID can be linked to the Roary gene id and the `gene_presence_abscence.Rtab`. `GO.db` and `TopGO` in R can be used to explore the acyclic hierchical structure of GO terms. `TopGO` as well as the analysis from the  'Gene Presence and Absence' section can be used to look for evidence of functional enrichment in between categories of interest. 

## Visualizing the Pangenome

Once you have analyzed the patterns of SNPs, gene presence/absence and function in your pangenome, it is very helpful to be able to produce a visualization that can effectively summarize your findings. The code in `Heatmap.R` provides some steps to create a customizable graphic of the meta data, associated function or presence/absence and phylogenetic relationships in the genomes from your population. 

## Comparing Populations

![alt text](https://github.com/meghartwick/Population-Adaptations/blob/master/worldmap.png)

Once you know something about your microbial population you might want to see how it compares to other strains or populations. I like  to use [NCBI's Short Read Archive](https://www.ncbi.nlm.nih.gov/sra) (SRA) in order to integrate new genomes into my studies through my own assembly and annotation pipeline. For this study, I wanted to identify the isolates recovered outside of my study area that were of the same ST as isolates in my study. I queried that SRA and populated a list with the SRA identifiers. I used `SRA_mlst.sh` to ST each SRA record in the list and append its result to a CSV. I chose the reads of isolates that matched my study and ran them through my assembly and annotation pipeline with `assembly_annotation_ST.sh`. 

To use `SRA_mlst.sh` create a tab-delimited list of SRA IDs as a text file

```
sh SRA_mlst.sh <filename.txt>
```

I made a quick map of the location of isolates that shared the same ST as isolates in my study with the code in `worldmap.R`


# There's lots more to come and lots of cleaning left to go!
I hope that you found something helpful if you came upon this page after wading through lots of keyword searches!
Please reach out if you have any questions, suggestions or want to use the code provided here for your own microbial pangenome population analyses!





