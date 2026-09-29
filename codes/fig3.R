setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
e=new.env();load("data/ablation-summary.RData",envir=e);tab=e$tab
dims=c("d1","d2","d4")
v=rbind("only precise (M0)"=as.numeric(tab[tab$config=="M0",dims]),"precise + cheap (S2)"=as.numeric(tab[tab$config=="S2",dims]))

pdf("../figures/3.pdf",width=4,height=4)
oldpar=par(mar=c(3.2,3.6,0.8,0.6),mgp=c(2.2,0.6,0))
bp=barplot(v,beside=TRUE,names.arg=c("1-D","2-D","4-D"),col=c("#999999","#222222"),border=NA,ylab="median found minimum  f*  (lower is better)",cex.axis=0.8,cex.names=0.9,ylim=c(-2,2))
legend("topleft",c("only precise (M0)","precise + cheap (S2)"),fill=c("#999999","#222222"),border=NA,bty="n",cex=0.8)
box(col="#666666",lwd=0.8)
par(oldpar)
dev.off()
