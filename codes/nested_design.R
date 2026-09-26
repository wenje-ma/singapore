setwd("C:/Users/18904/Github/singapore/codes")
library(SFDesign)
nested_design=function(n1,n2,p,seed=1){
  set.seed(seed)
  D1=maxpro_design(n1,p,seed)
  D2=maxpro.remove(D1,n.remove=n1-n2,delta=1/n1^2)
  list(D1=D1,D2=matrix(D2,nrow=n2,ncol=p))
}
