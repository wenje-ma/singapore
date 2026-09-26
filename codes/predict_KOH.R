setwd("C:/Users/18904/Github/singapore/codes")
predict_KOH=function(fit,x){
  if(is.null(dim(x)))x=matrix(x,nrow=1)
  pL=Predict.Kriging(fit$fitL,x)
	if(is.null(fit$fitD))return(list(mean=pL$mean,sd=pL$sd))
  pD=Predict.Kriging(fit$fitD,x)
  list(mean=pL$mean+pD$mean,sd=sqrt(pL$sd^2+pD$sd^2))
}