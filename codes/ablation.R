setwd("C:/Users/18904/Github/singapore/codes")
library(lhs)
ablation=function(fH,fL,b,p,n2=5,budget=15,cost=20,nrep=20,config="M1",cand=NULL){
  data.dir="data"; if(!dir.exists(data.dir))dir.create(data.dir,recursive=TRUE)
  scr=switch(config,M1=c(TRUE,TRUE),S2=c(FALSE,TRUE),S1=c(TRUE,FALSE),M0=c(FALSE,FALSE))
  screening=scr[1];multifidelity=scr[2]
  nm=paste0("ablation-",config,"-d",b)
  fout=file.path(data.dir,paste0(nm,".RData"))
  valid=FALSE
  if(file.exists(fout)){
    e=new.env();load(fout,envir=e)
    if(isTRUE(e$completed)&&length(e$fstars)==nrep&&isTRUE(e$n2==n2)){
      return(list(config=config,fstars=e$fstars,bests=e$bests,outs=e$outs,seed.seq=e$seed.seq))
    }
    if(length(e$fstars)==nrep&&isTRUE(e$n2==n2)){
      fstars=e$fstars;bests=e$bests;outs=e$outs;seed.seq=e$seed.seq;cand=e$cand
      valid=TRUE
    }
  }
  if(!valid){
    if(is.null(cand)){set.seed(1);cand=randomLHS(5000,p)}
    fstars=rep(NA_real_,nrep);bests=vector("list",nrep);outs=vector("list",nrep)
    seed.seq=b*10000+n2*100+1:nrep
  }
  for(r in 1:nrep){
    if(!is.na(fstars[r])){next}
    out=project(fH,fL,p=p,budget=budget,cost=cost,n2=n2,
                screening=screening,multifidelity=multifidelity,cand=cand,seed=seed.seq[r])
    fstars[r]=out$fstar;bests[[r]]=out$best;outs[[r]]=out
    completed=FALSE
    save(fstars,bests,outs,seed.seq,cand,completed,n2,config,file=fout)
    cat(sprintf("  %s d%d n2=%2d rep=%2d done: fstar=%.4f\n",config,b,n2,r,fstars[r]))
    flush(stdout())
  }
  completed=TRUE
  save(fstars,bests,outs,seed.seq,cand,completed,n2,config,file=fout)
  list(config=config,fstars=fstars,bests=bests,outs=outs,seed.seq=seed.seq)
}
