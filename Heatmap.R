#heatmap
library(ggtree)
library(ggplot2)
library(reshape2)

#check phylogeny
read.tree('core.nwk') -> nwk
nwk$tip.label -> order
as.data.frame(order)-> order
order$o <- 1:nrow(order)

#code stuff to pretty heatmap
read.delim('gene_presence_absence.Rtab', check.names = F)-> genes

as.character(genes$Gene) -> genes$Gene
as.data.frame(t(genes)) -> genes
lapply(genes, as.character) -> genes[]
colnames(genes) <- genes[1,]
genes[-1,] -> genes

lapply(genes, as.character) -> genes[]
lapply(genes, as.numeric) -> genes[]

melt(genes, id.vars = 'isolate.id)-> g_melt
brewer.pal(10, 'RdBu')-> color
coul <- colorRampPalette(color)(18)
ggplot(g_melt, aes(x=reorder(variable, -value, sum, order=TRUE), y=reorder(id, order))) +geom_tile(aes(fill= value)) + scale_fill_gradient(low="white", high="royalblue4") + xlab("") + ylab("") + theme(axis.title.x=element_blank(),axis.text.x=element_blank(),axis.ticks.x=element_blank(), axis.text.y=element_text(size = 6)) + theme(legend.position = "none") -> heat

read.csv('meta.csv')
melt(meta, id.vars = 'isolate.id') -> melt_m
ggplot(melt_m, aes(x=variable, y=reorder(isolate.id, order))) +geom_tile(aes(fill= value)) + xlab("") + ylab("") + theme(axis.title.y=element_blank(),axis.text.y=element_blank(),axis.ticks.y=element_blank(), axis.text.x=element_text(size = 6))+ theme(legend.position = "none")+ scale_fill_manual(values=coul) -> two

ggtree(nwk)
ggtree(nwk) -> p

png("heatmapped.png", width = 800, height = 350, units = 'px')
grid.newpage()
print(p, vp = viewport(x = 0.08, y = 0.5, width = 0.15, height = .98))
print(heat, vp = viewport(x = 0.49, y = 0.5, width = 0.7, height = .89))
print(two, vp = viewport(x = 0.92, y = 0.48, width = 0.17, height = 0.93))
dev.off()

