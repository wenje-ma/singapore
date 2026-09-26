setwd("C:/Users/18904/Github/singapore/codes")
library(lhs)
calibrate=function(fH,fL,b,p,budget,cost,n2.grid,nrep){
  nm=paste0("d",b)
  fout=file.path(data.dir,paste0("calibrate-",nm,".RData"))
  valid=FALSE
  if(file.exists(fout)){
    e=new.env();load(fout,envir=e)
    if(isTRUE(e$completed)&&nrow(e$fstars.all)==length(n2.grid)&&ncol(e$fstars.all)==nrep){
      return(list(n2star=e$n2star,meds=e$meds,med_tab=e$med_tab,fstars=e$fstars.all))
    }
    if(nrow(e$fstars.all)==length(n2.grid)&&ncol(e$fstars.all)==nrep){
      fstars.all=e$fstars.all;bests.all=e$bests.all;outs.all=e$outs.all
      seed.seq.all=e$seed.seq.all;cands=e$cands
      valid=TRUE
    }
  }
  if(!valid){   # 无缓存或参数已变（n2.grid/nrep 不匹配）：重新初始化
    set.seed(1);cands=randomLHS(5000,p)
    fstars.all=matrix(NA,nrow=length(n2.grid),ncol=nrep)
    bests.all=vector("list",length(n2.grid));outs.all=vector("list",length(n2.grid))
    seed.seq.all=vector("list",length(n2.grid))
  }
  for(ni in seq_along(n2.grid)){
    n2=n2.grid[ni]
    if(!is.na(fstars.all[ni,1])){next}
    seed.seq=b*10000+n2*100+1:nrep
    fstars=numeric(nrep);bests=vector("list",nrep);outs=vector("list",nrep)
    for(r in 1:nrep){
      out=project(fH,fL,p=p,budget=budget,cost=cost,n2=n2,
                  screening=TRUE,multifidelity=TRUE,cand=cands,seed=seed.seq[r])
      fstars[r]=out$fstar;bests[[r]]=out$best;outs[[r]]=out
    }
    fstars.all[ni,]=fstars;bests.all[[ni]]=bests;outs.all[[ni]]=outs;seed.seq.all[[ni]]=seed.seq
    completed=FALSE
    save(fstars.all,bests.all,outs.all,seed.seq.all,cands,completed,file=fout)
    cat(sprintf("  d%d n2=%2d done: median fstar=%.4f\n",b,n2,median(fstars)))
    flush(stdout())
  }
  meds=apply(fstars.all,1,median)
  n2star=n2.grid[which.min(meds)]
  med_tab=data.frame(n2=n2.grid,med=meds)
  completed=TRUE
  save(fstars.all,bests.all,outs.all,seed.seq.all,cands,meds,n2star,med_tab,completed,file=fout)
  list(n2star=n2star,meds=meds,med_tab=med_tab,fstars=fstars.all)
}