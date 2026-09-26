setwd("C:/Users/18904/Github/singapore/codes")
mofat_design=function(p,m,seed=1){
  library(MOFAT);set.seed(seed)
  Dm=mofat(p,m,method="projection")
  list(A=Dm[1:m,],C1=Dm[(m+1):(2*m),],C2=Dm[(2*m+1):(3*m),])
}