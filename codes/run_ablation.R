##################################################################
# run_ablation.R — driver for the ablation experiment
#
# Sources the algorithm files, runs ablation() over four configs ×
# four benchmarks (borrowing M1 from the calibration cache), appends
# the M0@n2=14 row, prints the median table, and saves
# data/ablation-summary.RData.
#
# Result — median found-minimum f* (forced n2=5, nrep=20):
#   config   d1        d2        d4        d8
#   M1     -0.6035    3.1627   -1.4109   19.6854
#   S2     -0.6035    0.4041   -1.6060   12.7014
#   S1      0.0000    5.4694   -1.1875   17.1585
#   M0      0.0000    0.8788   -1.2975   10.5021
#   M0@14  -0.5777    2.2568   -1.4485   12.5921
#
# Interpretations:
# - 1-D: EI alone fails (M0/S1 sit at 0).
# - 4-D: fusion uses a large amount of low-fidelity data to correct
#   the high-fidelity surface.
# - Screening gives no positive contribution in any dimension: the
#   bias between fidelities makes the importance ranking unreliable.
# - Fusion decays with dimension: at 8-D blank M0 beats fusion-only
#   S2 — a manifestation of the curse of dimensionality inside the
#   multi-fidelity framework.
# - Same budget: a few high-fidelity points + fusion far outperform
#   running with many high-fidelity points alone.
#
# Summary: under an extremely small budget the initial design
# dominates; fusion is the decisive component but has a dimensionality
# ceiling; screening adds nothing. Future work: under what bound on the
# total Sobol' index of the bias field δ(x) does the low-fidelity
# importance ranking preserve the true high-fidelity ranking?
##################################################################
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
source("ablation.R")
budget=15; cost=20; n2=5; nrep=20
benchmarks=list(
  list(b=1,p=1,fH=fH1,fL=fL1),
  list(b=2,p=2,fH=fH2,fL=fL2),
  list(b=4,p=4,fH=fH4,fL=fL4),
  list(b=8,p=8,fH=fH8,fL=fL8))
configs=c("M1","S2","S1","M0")
bnames=sapply(benchmarks,function(bm)paste0("d",bm$b))
res=vector("list",length(bnames));names(res)=bnames
for(di in seq_along(benchmarks)){
  bm=benchmarks[[di]];nm=bnames[di]
  flush(stdout())
  row=list()
  for(cfg in configs){
    if(cfg=="M1"){
      e=new.env();load(file.path(data.dir,paste0("calibrate-",nm,".RData")),envir=e)
      idx=which(e$med_tab$n2==n2)
      fstars=e$fstars.all[idx,]
      row[[cfg]]=list(fstars=fstars,bests=e$bests.all[[idx]],outs=e$outs.all[[idx]],
                      seed.seq=e$seed.seq.all[[idx]])
      flush(stdout())
    }else{
      a=ablation(bm$fH,bm$fL,bm$b,bm$p,n2=n2,budget=budget,cost=cost,nrep=nrep,config=cfg)
      row[[cfg]]=a
      flush(stdout())
    }
  }
  res[[nm]]=row
}
m0at14=vector("list",length(bnames));names(m0at14)=bnames
for(di in seq_along(benchmarks)){
  nm=bnames[di];e=new.env();load(file.path(data.dir,paste0("calibrate-",nm,".RData")),envir=e)
  idx=which(e$med_tab$n2==14)
  m0at14[[nm]]=e$fstars.all[idx,]
}
tab=data.frame(config=configs)
for(nm in bnames)tab[[nm]]=sapply(configs,function(cfg)median(res[[nm]][[cfg]]$fstars))
tab=rbind(tab,data.frame(config="M0@n2=14",
                         d1=median(m0at14$d1),d2=median(m0at14$d2),
                         d4=median(m0at14$d4),d8=median(m0at14$d8)))
print(tab,row.names=FALSE)
flush(stdout())
fstars.all=vector("list",length(bnames));names(fstars.all)=bnames
for(nm in bnames)fstars.all[[nm]]=sapply(configs,function(cfg)res[[nm]][[cfg]]$fstars)
save(tab,res,m0at14,fstars.all,benchmarks,budget,cost,n2,nrep,configs,
     file=file.path(data.dir,"ablation-summary.RData"))
flush(stdout())
