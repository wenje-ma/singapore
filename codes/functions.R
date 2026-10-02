##################################################################
# functions.R — benchmark test functions (high + low fidelity)
#
# Four problems in 1/2/4/8 dimensions:
#   d1 Joseph 1-D (Joseph 2026):
#        h(x) = sin(10πx)/(1+64(x-.25)²) + x² ,  x∈[0,1]          (19)
#   d2 Branin (Surjanovic & Bingham 2013):
#        f(x) = (x2 - 5.1/(4π²)x1² + 5/π x1 - 6)²
#               + 10(1 - 1/(8π)) cos x1 + 10 ,  mapped to [0,1]²   (20)
#   d4 additive (Joseph 2026):
#        h(x) = Σ_{k=1}^{4} (1/k) sin((k²+1)π x_k) ,  x∈[0,1]^4    (21)
#   d8 borehole (Morris et al. 1993):
#        y = 2π x3 (x4-x6) / [ ln(x2/x1)
#              (1 + 2 x7 x3/(ln(x2/x1) x1² x8) + x3/x5) ]          (22)
#
# Low-fidelity construction (Song et al. 2024): bias ∝ avg shift
# from the midpoint 0.5,
#   f_L(x) = f_H(x) + (c/p) Σ_{i=1}^{p} (x_i - 1/2)                (23)
# with the concrete constants (eqs 24-27): d1 c=0.3, d2 c=40,
# d4 c=0.5, d8 c=70.
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
fH1=function(u){
  x=u[1]
  sin(10*pi*x)/(1+64*(x-0.25)^2)+x^2
}
fL1=function(u)fH1(u)+0.3*(u[1]-0.5)
fH2=function(u){
  x1=u[1]*15-5;x2=u[2]*15
  (x2-5.1/(4*pi^2)*x1^2+5/pi*x1-6)^2+10*(1-1/(8*pi))*cos(x1)+10
}
fL2=function(u)fH2(u)+40*mean(u-0.5)
fH4=function(u){
  k=1:4
  sum(sin((k^2+1)*pi*u[k])/k)
}
fL4=function(u)fH4(u)+0.5*mean(u-0.5)
fH8=function(u){
  lower=c(0.05,100,63070,990,63.1,700,1120,9855)
  upper=c(0.15,50000,115600,1110,116,820,1680,12045)
  x=lower+u*(upper-lower)
  2*pi*x[3]*(x[4]-x[6])/(log(x[2]/x[1])*(1+2*x[7]*x[3]/(log(x[2]/x[1])*x[1]^2*x[8])+x[3]/x[5]))
}
fL8=function(u)fH8(u)+70*mean(u-0.5)
