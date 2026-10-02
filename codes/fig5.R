##################################################################
# fig5.R — figure: high dimensions fail
#
# Reproduces figures/5.pdf: found-minimum f* at 8-D for all four
# configs M1 / S1 / S2 / M0.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
e=new.env();load("data/ablation-summary.RData",envir=e);tab=e$tab
cols=c(M1="#555555",S1="#222222",S2="#888888",M0="#bbbbbb")
pdf("../figures/5.pdf",width=4,height=4)
oldpar=par(mar=c(2,3,1,1),mgp=c(1.5,0.5,0))
dims=c("d1","d2","d4")
v=rbind("with screening"=as.numeric(tab[tab$config=="M1",dims]),"no screening"=as.numeric(tab[tab$config=="S1",dims]))
ord=c("M1","S1","S2","M0")
v8=as.numeric(tab[tab$config %in% ord,"d8"]);names(v8)=tab$config[tab$config %in% ord];v8=v8[ord]
barplot(v8,col=c("#555555","#222222","#888888","#bbbbbb"),border=NA,names.arg=c("M1","S1","S2","M0"),ylab="found minimum f* at 8-D",cex.axis=0.8,cex.names=0.9,ylim=c(0,22))
abline(h=0,lty=2)
box(col="#666666",lwd=0.8)
legend("topright",legend=c("M1: full pipeline","S1: no screening","S2: no fusion","M0: blank"),fill=cols[c("M1","S1","S2","M0")],border=NA,bty="n",cex=0.7)
par(oldpar)
dev.off()
