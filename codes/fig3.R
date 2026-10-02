##################################################################
# fig3.R — figure: fusion matters
#
# Reproduces figures/3.pdf: median found-minimum f* in 1/2/4-D,
# comparing high-fidelity alone (M0) vs high+low fusion (S2).
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
e=new.env();load("data/ablation-summary.RData",envir=e);tab=e$tab
dims=c("d1","d2","d4")
v=rbind("high"=as.numeric(tab[tab$config=="M0",dims]),"high + low"=as.numeric(tab[tab$config=="S2",dims]))
pdf("../figures/3.pdf",width=4,height=4)
oldpar=par(mar=c(2,3,1,1),mgp=c(1.5,0.5,0))
bp=barplot(v,beside=TRUE,names.arg=c("1-D","2-D","4-D"),col=c("#999999","#222222"),border=NA,ylab="median found minimum f*",cex.axis=0.8,cex.names=0.9,ylim=c(-2,2))
abline(h=0,lty=2)
legend("topleft",c("high","high + low"),fill=c("#999999","#222222"),border=NA,bty="n",cex=0.8)
box(col="#666666",lwd=0.8)
par(oldpar)
dev.off()
