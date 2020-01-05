#ST world

library(ggplot)
library(ggmap)
library(RcolorBrewer)
library(extrafont)
#font_import() #only do this once
loadfonts(device = "win")

pretty <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "black"))

brewer.pal(10, 'RdBu')-> color
coul <- colorRampPalette(color)(16)

#read in file with lat/long an other meta data

read.csv('ST.csv) -> st

#resources
#https://stackoverflow.com/questions/50201048/remove-antarctica-from-gglpot2-map
#https://www.r-bloggers.com/r-beginners-plotting-locations-on-to-a-world-map/

#build the map
mapWorld <- borders("world", colour = "gray85", fill = "gray80")
ggplot() +   mapWorld
ggplot() +   mapWorld + pretty + geom_point(data= st, aes(lat, long, color = ST))
ggplot() +   mapWorld + pretty + geom_point(data= st, aes(lat, long, color = ST), size = 3) + scale_color_brewer(palette = 'Paired')

ggplot() +   mapWorld + pretty + geom_point(data= st, aes(lat, long, fill = ST), shape = 21, size = 5, alpha = 0.4, color = 'black') + scale_fill_manual(values = coul, name = "Sequence Type", breaks=c("12","49","57", '104', ' 114', '380', '400', '614', '892', '1087', '1199', '1262', '1346', '1379', '1675')) + coord_cartesian(ylim = c(-50, 90)) + theme_map() + theme(text=element_text(family="Times New Roman"))
