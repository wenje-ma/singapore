setwd("C:/Users/18904/Github/singapore/codes")
library(SFDesign);library(lhs)
maxpro_design=function(n,p,seed=1){
  set.seed(seed)
  D=maxpro.optim(randomLHS(n,p))$design
  matrix(D,nrow=n,ncol=p)
}
