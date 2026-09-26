setwd("C:/Users/18904/Github/singapore/codes")
rm(list=ls())
data.dir="data"; if(!dir.exists(data.dir))dir.create(data.dir,recursive=TRUE)
source("maxpro_design.R")
source("mofat_design.R")
source("nested_design.R")
source("fit_KOH.R")
source("predict_KOH.R")
source("EI.R")
source("project.R")
source("functions.R")
source("calibrate.R")
budget=15; cost=20; n2.grid=2:15; nrep=20
benchmarks=list(
  list(b=1,p=1,fH=fH1,fL=fL1),
  list(b=2,p=2,fH=fH2,fL=fL2),
  list(b=4,p=4,fH=fH4,fL=fL4),
  list(b=8,p=8,fH=fH8,fL=fL8))
bnames=sapply(benchmarks,function(bm)paste0("d",bm$b))
r1=calibrate(benchmarks[[1]]$fH,benchmarks[[1]]$fL,benchmarks[[1]]$b,benchmarks[[1]]$p,budget,cost,n2.grid,nrep)
r2=calibrate(benchmarks[[2]]$fH,benchmarks[[2]]$fL,benchmarks[[2]]$b,benchmarks[[2]]$p,budget,cost,n2.grid,nrep)
r4=calibrate(benchmarks[[3]]$fH,benchmarks[[3]]$fL,benchmarks[[3]]$b,benchmarks[[3]]$p,budget,cost,n2.grid,nrep)
r8=calibrate(benchmarks[[4]]$fH,benchmarks[[4]]$fL,benchmarks[[4]]$b,benchmarks[[4]]$p,budget,cost,n2.grid,nrep)
all=list(d1=r1,d2=r2,d4=r4,d8=r8)
tab=data.frame(n2=n2.grid)
for(nm in names(all))tab[[nm]]=all[[nm]]$med_tab$med
flush(stdout())
cat("各维度 n2*：",paste(names(all),sapply(all,function(x)x$n2star),sep="=",collapse="    "),"\n")
flush(stdout())
n2star=sapply(all,function(x)x$n2star)
save(n2star, all, benchmarks, budget, cost, n2.grid, nrep, bnames,file=file.path(data.dir,"calibrate-summary.RData"))
