##################################################################
# fig6.R — figure: the whole picture
#
# Reproduces figures/6.pdf: a shared-range 2x2 panel of the four
# configs across d1/d2/d4/d8 on the same y-axis.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
e=new.env();load("data/ablation-summary.RData",envir=e);tab=e$tab
cols=c(M1="#555555",S1="#222222",S2="#888888",M0="#bbbbbb")
lbl=c(d1="1-D",d2="2-D",d4="4-D",d8="8-D")
all_vals=unlist(tab[tab$config %in% c("M1","S1","S2","M0"), c("d1","d2","d4","d8")])
y_min=min(all_vals)
y_max=max(all_vals)
pdf("../figures/6.pdf",width=8,height=8)
layout(matrix(c(1,2,3,4),nrow=2,byrow=TRUE),heights=c(1,1))
oldpar=par(mar=c(2,3,2,1),mgp=c(1.5,0.5,0))
for(d in c("d1","d2","d4","d8")){
  v=as.numeric(tab[tab$config %in% c("M1","S1","S2","M0"),d])
  names(v)=tab$config[tab$config %in% c("M1","S1","S2","M0")]
  v=v[c("M1","S1","S2","M0")]
  barplot(v,col=cols[c("M1","S1","S2","M0")],border=NA,names.arg=c("M1","S1","S2","M0"),ylab="median found minimum f*",cex.axis=0.8,cex.names=0.85,ylim=c(y_min,y_max))
  abline(h=0,lty=2)
  mtext(lbl[d],side=3,line=0.2,cex=0.85,font=2)
  box(col="#666666",lwd=0.8)
  if(d=="d1"){
    legend("topright",legend=c("M1: full pipeline","S1: no screening","S2: no fusion","M0: blank"),fill=cols[c("M1","S1","S2","M0")],border=NA,bty="n",cex=0.9)
  }
}
par(oldpar)
dev.off()
