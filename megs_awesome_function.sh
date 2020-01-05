#might need to edit header of roary to get gene names
sed 's/[^ ]* />/' pan_genome_reference.fa > new_file.fasta

#unwrap
awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' pan_clean_headers.fasta > unwrapped.fasta

#get uniprot ids
blastx -max_target_seqs 1 -num_threads 16 -db /mnt/lustre/hcgs/shared/databases/uniref90/blast/uniref90.fasta -query gamma.fasta -outfmt "10 ppos qacc sacc" > uniref_blast_3.csv

#select uniprot ids
awk -F"," '$1=$1' OFS="\t" annotated.csv > an.csv

awk -F"," '$1=$1' OFS="\t" annotated.csv | awk '{print $3}' | awk -F"_" '$1=$1' OFS="\t" | awk '{print $2}' > an.txt

#then upload uniprot ids as list or annotate in r
http://www.uniprot.org/uploadlists/
uniprot_kb to uniprot_kb
#Query pangenome

source("https://bioconductor.org/biocLite.R")
#biocLite("GO.db")

library(splitstackshape)
library(dplyr)
library(GO.db)
library(reshape2)

#https://cran.r-project.org/web/packages/splitstackshape/splitstackshape.pdf
b <- cSplit(a, "go", sep = ";", direction = "long")
c <- cSplit(a, "go", sep = ";", direction = "wide")
c <- c[,1:41]


#from the go.db package, this will annotate how as CC, MF, or BP
b$go <- as.character(b$go)
b$class <- Ontology(b$go)

#read in file
genes<-read.delim("gene_presence_absence.Rtab", header=T)

#subset to Go terms and unique identifiers
a <- genes[1:nrow(genes), 1:5]

#split go term column into new rows, can still further clean using gene name(unique identifier)
b <- cSplit(a, "go", sep = ";", direction = "long")

#use summary and dim to check format at any time or
#lapply(a, class)

b$go <-as.character(b$go)

#from the go.db package, this will annotate how as CC, MF, or BP
b$class <- Ontology(b$go)

#subset to the classes of ontologies(GO requirement)
BP <- subset(b, class == 'BP')

BP_unique<-BP[-which(duplicated(BP$go)), ]
#dim(BP)
#[1] 8681    6
dim(BP_unique)
[1] 1314    6

x <-as.list(GOBPANCESTOR[BP_unique$go])
y<-ldply(x, rbind)
# or y<-ldply(x, rbind)
dim(y)
#[1] 1314   82

merged <- merge(BP, y, by.x = 'go', by.y = '.id')
dim(merged)
[1] 8681   87

colnames(y)[1] <- "go"
merged<- merge(BP, y, by = 'go')
clean <- merged[,c(1:2,7:87)]

goterms <- Term(GOTERM)
head(goterms)
goingterms<-as.dataframe(goterms)
d <- cbind(names = rownames(goingterms), goingterms)


!!THIS, 4.29.18
take uniprot annotations, list long, GO.db to sub function and GO out to ancestors, melt, remove na's merge with terms and table
final[complete.cases(final), ]



> summary -> VPcg
> table(shared_yep$goterms) -> summary
> as.data.frame(summary)-> summary
> summary<-summary[order(-summary$Freq),]
> colnames(summary)[2] <- 'shared_core'
> summary -> shared_core
> table(yep2$goterms) -> summary
> as.data.frame(summary)-> summary
> colnames(summary)[2] <- 'Pangenome'
> summary<-summary[order(-summary$Freq),]
Error in -summary$Freq : invalid argument to unary operator
> summary<-summary[order(-summary$Pangenome),]
> summary -> pan
> merge(Pangenome, shared_core, VPcg, variable, by = 'Var1', all = TRUE) -> enrichment
Error in merge(Pangenome, shared_core, VPcg, variable, by = "Var1", all = TRUE) :
  object 'Pangenome' not found
> merge(pan, shared_core, VPcg, variable, by = 'Var1', all = TRUE) -> enrichment
Error in fix.by(by.x, x) :
  'by' must specify one or more columns as numbers, names or logical
> head(pan)
                                     Var1 Pangenome
2411                                  all      4695
4505                   biological_process      4695
6023                     cellular process      3527
19322                   metabolic process      3182
26323 organic substance metabolic process      3007
5996           cellular metabolic process      2827
> head(shared_core)


plot <- ggplot(data = clean1,  mapping = aes(x = Var1, fill = variable,  y = ifelse(test = variable == "variable",  yes = -value, no = value))) + geom_bar(stat = "identity") + scale_y_continuous(labels = abs, limits = max(clean1$value) * c(-1,1)) + labs(y = "Biological Process GO") + coord_flip() + theme(axis.title.y=element_blank(),axis.text.y=element_blank()) + scale_fill_discrete("Pangenome", breaks=c("variable","shared_core", 'VPcg'), labels=c("Variable", "Vpcg Core", "GBE Core"))

https://www.biostars.org/p/50564/
# load the GO library
library(GO.db)
# extract a named vector of all terms
goterms <- Term(GOTERM)
# work with it in R, or export it to a file
write.table(goterms, sep="\t", file="goterms.txt")

