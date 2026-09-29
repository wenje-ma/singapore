setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
e=new.env();load("data/ablation-summary.RData",envir=e);tab=e$tab
cols=c(M1="#555555",S2="#222222",S1="#888888",M0="#bbbbbb")
lbl=c(d1="1-D",d2="2-D",d4="4-D",d8="8-D")
all_vals=unlist(tab[tab$config %in% c("M1","S2","S1","M0"), c("d1","d2","d4","d8")])
y_min=min(all_vals)
y_max=max(all_vals)
pdf("../figures/6.pdf",width=8,height=8)
layout(matrix(c(1,2,3,4),nrow=2,byrow=TRUE),heights=c(1,1))
oldpar=par(mar=c(3.2,3.4,2.4,0.6),mgp=c(2.2,0.6,0))
for(d in c("d1","d2","d4","d8")){
  v=as.numeric(tab[tab$config %in% c("M1","S2","S1","M0"),d])
  names(v)=tab$config[tab$config %in% c("M1","S2","S1","M0")]
  v=v[c("M1","S2","S1","M0")]
  barplot(v,col=cols[c("M1","S2","S1","M0")],border=NA,names.arg=c("M1","S2","S1","M0"),ylab="f*  (lower is better)",cex.axis=0.8,cex.names=0.85,ylim=c(y_min,y_max))
  mtext(lbl[d],side=3,line=0.2,cex=0.85,font=2)
  box(col="#666666",lwd=0.8)
  if(d=="d1"){
    legend("topright",legend=c("M1  full pipeline","S2  no screening","S1  no fusion","M0  blank"),fill=cols[c("M1","S2","S1","M0")],border=NA,bty="n",cex=0.9)
  }
}
par(oldpar)
dev.off()
