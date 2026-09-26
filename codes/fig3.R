setwd("C:/Users/18904/Github/singapore/codes")
if(!dir.exists("data"))dir.create("data")
if(!dir.exists("../figures"))dir.create("../figures")
if(!file.exists("data/3-plot.RData")){
  library(MOFAT);p=2;l=4;s=1
  set.seed(s);D1=mofat(p,l,method="uniform")
  A1=D1[1:l,];C11=D1[(l+1):(2*l),];C12=D1[(2*l+1):(3*l),]
  set.seed(s);D2=mofat(p,l,method="projection")
  A2=D2[1:l,];C21=D2[(l+1):(2*l),];C22=D2[(2*l+1):(3*l),]
  save(A1,C11,C12,A2,C21,C22,l,file="data/3-plot.RData")
}
load("data/3-plot.RData")
pdf("../figures/3.pdf",width=8,height=4)
oldpar<-par(mar=c(1,1,1,1),mfrow=c(1,2))
for(side in 1:2){
  if(side==1){A=A1;C1=C11;C2=C12}else{A=A2;C1=C21;C2=C22}
  plot(A,pch=16,cex=1.4,col="#222222",axes=FALSE,xlab="",ylab="",xlim=c(0,1),ylim=c(0,1),asp=1)
  points(C1,pch=2,cex=1.4,col="#222222",lwd=1.1)
  points(C2,pch=3,cex=1.4,col="#222222",lwd=1.1)
  for(i in 1:l){
    arrows(A[i,1],A[i,2],C1[i,1],C1[i,2],lty=i,col="#666666",lwd=0.7,length=0.07)
    arrows(A[i,1],A[i,2],C2[i,1],C2[i,2],lty=i,col="#666666",lwd=0.7,length=0.07)
  }
  box(col="#666666",lwd=0.8)
}
par(oldpar)
dev.off()