setwd("D:/wenje-ma/singapore/codes")
EI=function(x,hmin,fit){
  p=predict_KOH(fit,x)
  s=max(p$sd,1e-10);u=(hmin-p$mean)/s
  s*(u*pnorm(u)+dnorm(u))
}