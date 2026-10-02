##################################################################
# EI.R — Expected Improvement acquisition function
#
# Objective  min_{x∈[0,1]^p} h(x) , next point from the surrogate
#   x_{n+1} = argmin_x ĥ_n(x)                                   (11,12)
# Improvement  I(x) = max{ h_min^(n) - h(x), 0 }                  (15)
# Expected improvement (Jones et al. 1998), explicit form:
#   x_{n+1} = argmax_x s_n(x)[ u_n(x)Φ(u_n(x)) + φ(u_n(x)) ]
#   u_n(x) = (h_min^(n) - ĥ_n(x)) / s_n(x)                       (17)
# Derivatives: ∂EI/∂ĥ_n = -Φ(u) < 0 , ∂EI/∂s_n = φ(u) > 0        (18)
# (balances optimization against surrogate accuracy). s_n is floored
# at 1e-10; higher EI = more promising point.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
EI=function(x,hmin,fit){
  p=predict_KOH(fit,x)
  s=max(p$sd,1e-10);u=(hmin-p$mean)/s
  s*(u*pnorm(u)+dnorm(u))
}