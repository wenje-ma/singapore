##################################################################
# nested_design.R — nested two-fidelity design
#
# Nested design (Kennedy & O'Hagan 2000): D1 ⊃ D2 ⊃ … ⊃ DK.
# Sequential max-entropy problems (Shannon 1948):
#   D1* = argmax |R1(D1,D1)| ,  D2* = argmax_{D2 ⊆ D1*} |R2(D2,D2)| (9)
# Optimal point to remove from D1 (Joseph 2026):
#   x_k* = argmax Σ_{j≠k} 1 / Π_l { |x_kl - x_jl| + β_l }²        (10)
#   β > 0 prevents a zero denominator (D2 is discrete within the
#   continuous D1). Here D1 = maxpro(n1), then
#   D2 = maxpro.remove(D1, n1-n2, delta=1/n1²), so the high-fidelity
#   points are a subset of the low-fidelity locations (shared points).
##################################################################
setwd("C:/Users/18904/Github/singapore/codes")
library(SFDesign)
nested_design=function(n1,n2,p,seed=1){
  set.seed(seed)
  D1=maxpro_design(n1,p,seed)
  D2=maxpro.remove(D1,n.remove=n1-n2,delta=1/n1^2)
  list(D1=D1,D2=matrix(D2,nrow=n2,ncol=p))
}
