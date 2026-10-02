##################################################################
# fit_KOH.R — KOH auto-regressive fusion fit
#
# Fusion formula (Kennedy & O'Hagan 2000), for K fidelity levels:
#   h_k(x) = h_{k-1}(x) + δ_k(x)                                  (7)
# Gaussian-process assumptions:
#   δ_k(x) ~ GP{0, τ_k² R_k(·)} ;  h_L(x) ~ GP{μ, τ_L² R_L(·)}    (8)
# Implementation: fit fitL (Kriging) on (D1, yL), form the residual
#   δ = yH - ŷL(D2), and fit fitD (Kriging) on (D2, δ).
# Non-multifidelity mode returns fitD = NULL.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
fit_KOH=function(D1,yL,D2=NULL,yH=NULL,multifidelity=TRUE){
  library(rkriging)
  fitL=Fit.Kriging(D1,yL,kernel.parameters=list(type="Gaussian"))
  if(!multifidelity)return(list(fitL=fitL,fitD=NULL))
  delta=yH-Predict.Kriging(fitL,D2)$mean
  fitD=Fit.Kriging(D2,delta,kernel.parameters=list(type="Gaussian"))
  list(fitL=fitL,fitD=fitD)
}