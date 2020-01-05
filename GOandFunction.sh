#This is a work in progress to annotate the pangenome fasta from Roary with GO identifiers
#The GO ids are recovered from UNIPROT
#R GO.db assigns the acyclic heirachical structure and then custom R queries summarize
#A script to produce tree maps in R is provided at the end

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

#R
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



lapply(BP, as.character)-> BP[]
BP$behavior <- apply(BP, 1, function(x)as.integer(any(grep("GO:0007610",x))))
BP$adhesion <- apply(BP, 1, function(x)as.integer(any(grep("GO:0022610",x))))
BP$phase <- apply(BP, 1, function(x)as.integer(any(grep("GO:0044848",x))))
BP$regulation <- apply(BP, 1, function(x)as.integer(any(grep("GO:0065007",x))))
BP$mineraalization <- apply(BP, 1, function(x)as.integer(any(grep("GO:0110148",x))))
BP$carb_utilization <- apply(BP, 1, function(x)as.integer(any(grep("GO:0009758",x))))
BP$carbon_utilization <- apply(BP, 1, function(x)as.integer(any(grep("GO:0015976",x))))
BP$cell_aggregation <- apply(BP, 1, function(x)as.integer(any(grep("GO:0098743",x))))
BP$cell_killing <- apply(BP, 1, function(x)as.integer(any(grep("GO:GO:0001906",x))))
BP$cell_pop_prolif <- apply(BP, 1, function(x)as.integer(any(grep("GO:0008283",x))))
BP$cell_biogenisis <- apply(BP, 1, function(x)as.integer(any(grep("GO:0071840",x))))
BP$cell_biogenisis2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0071841",x))))
BP$detox <- apply(BP, 1, function(x)as.integer(any(grep("GO:0098754",x))))
BP$development <- apply(BP, 1, function(x)as.integer(any(grep("GO:0032502",x))))
BP$development2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0044767",x))))
BP$growth <- apply(BP, 1, function(x)as.integer(any(grep("GO:0040007",x))))
BP$growth2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0048590",x))))
BP$localization <- apply(BP, 1, function(x)as.integer(any(grep("GO:0051179",x))))
BP$localization2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:1902578",x))))
BP$locomotion <- apply(BP, 1, function(x)as.integer(any(grep("GO:0040011",x))))
BP$metabolic <- apply(BP, 1, function(x)as.integer(any(grep("GO:0008152",x))))
BP$metabolic2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0044236",x))))
BP$metabolic3 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0044710",x))))
BP$N_utuliz <- apply(BP, 1, function(x)as.integer(any(grep("GO:0019740",x))))
BP$P_utuliz <- apply(BP, 1, function(x)as.integer(any(grep("GO:0006794",x))))
BP$repro <- apply(BP, 1, function(x)as.integer(any(grep("GO:0000003",x))))
BP$repro2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0019952",x))))
BP$repro3 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0050876",x))))
BP$response_stimulus <- apply(BP, 1, function(x)as.integer(any(grep("GO:0050896",x))))
BP$signaling <- apply(BP, 1, function(x)as.integer(any(grep("GO:0023052",x))))
BP$signaling2 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0023046",x))))
BP$signaling3 <- apply(BP, 1, function(x)as.integer(any(grep("GO:0044700",x))))
BP$sulfur_utiliz <- apply(BP, 1, function(x)as.integer(any(grep("GO:0006791",x))))


l$one <- apply(l, MARGIN=1, FUN = function(x) { ifelse(any(grepl("1", x[1:10])==T), 1,"0") } )
BP2[c(3,141:171)]-> BP_sub
t(BP_sub)-> BP_sub
as.data.frame(BP_sub) -> BP_sub
dim(BP_sub)
lapply(BP_sub, as.character) -> BP_sub[]
colnames(BP_sub) <- BP_sub[1,]
head(BP_sub[1:10])
BP_sub[-1,]-> BP_sub
rowSums(BP_sub) -> BP_sub$totals
BP_sub[BP_sub$totals > 0,]-> BP_s


treemap(BP_s, #Your data frame object
        index=c("BP"),  #A list of your categorical variables
        vSize = "totals",  #This is your quantitative variable
        type="index", #Type sets the organization and color scheme of your treemap
        palette = "Reds",  #Select your color palette from the RColorBrewer presets or make your own.
        title="BP", #Customize your title
        fontsize.title = 14 #Change the font size of the title
        )

