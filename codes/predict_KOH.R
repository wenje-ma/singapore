##################################################################
# predict_KOH.R — KOH fusion prediction
#
# GP prior  h(x) ~ GP{μ, τ² R(·)}  and its posterior (Joseph 2026):
#   h(x)|D_n,y_n ~ N{ μ + r_n' R_n^{-1} (y_n - μ 1_n),
#                     τ² (1 - r_n' R_n^{-1} r_n) }               (13,14)
# The fused prediction combines both fitted levels:
#   mean = ŷL + ŷδ ,  sd² = sd_L² + sd_δ²   (quadrature).
# Without fitD it degrades to the plain low-fidelity prediction.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
predict_KOH=function(fit,x){
  if(is.null(dim(x)))x=matrix(x,nrow=1)
  pL=Predict.Kriging(fit$fitL,x)
	if(is.null(fit$fitD))return(list(mean=pL$mean,sd=pL$sd))
  pD=Predict.Kriging(fit$fitD,x)
  list(mean=pL$mean+pD$mean,sd=sqrt(pL$sd^2+pD$sd^2))
}